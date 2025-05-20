from flask import Flask, request, jsonify, send_from_directory
from flask_jwt_extended import JWTManager, create_access_token, jwt_required, get_jwt_identity
from flask_cors import CORS
import os
from db import db
from models import User, FriendEntry, PokemonEntry, SilhouetteQuestion
from dotenv import load_dotenv
import requests
import random

base = "https://pokeapi.co/api/v2/"

load_dotenv()

app = Flask(__name__)
app.secret_key = os.getenv("APP_SECRET_KEY")
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///sqlite.db'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
app.config['JWT_SECRET_KEY'] =  os.getenv('JWT_SECRET_KEY')
app.config.update(SESSION_COOKIE_SAMESITE="None", SESSION_COOKIE_SECURE=True)

UPLOAD_FOLDER = os.path.join(os.getcwd(), 'uploads')
os.makedirs(UPLOAD_FOLDER, exist_ok=True)
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER

db.init_app(app)
CORS(app, supports_credentials=False, origins="*")

jwt = JWTManager(app)


def validate(id):
	return bool(User.query.filter_by(id=id).first())

@app.route('/register', methods=['POST'])
def register():
	name = request.json.get('username')
	password = request.json.get('password')
	id = request.json.get('userId')

	if not name or not password or not id:
		return jsonify({"error": "Missing form data"}), 400
	
	if User.query.filter_by(id=id).first():
		return jsonify({"error": "User already exists"}), 400
	
	user = User(name=name, password=password, id=id)
	db.session.add(user)
	db.session.commit()

	access_token = create_access_token(identity=id)

	pokemon = PokemonEntry(userId=id, id=str(random.randint(1, 100)))
	db.session.add(pokemon)
	db.session.commit()

	return jsonify(access_token=access_token), 201

@app.route('/trade', methods=['POST'])
@jwt_required()
def acceptTrade():
	id = get_jwt_identity()
	data = request.get_json()
	friendId = data.get('friendId')
	pokeId = data.get('pokeId')
	if not pokeId or not id:
		return jsonify({"error": "Missing form data"}), 400
	if not validate(id):
		return "Invalid input", 400
	if not validate(friendId):
		return "Invalid input", 400
	if PokemonEntry.query.filter_by(userId=id, id=pokeId).first():
		if PokemonEntry.query.filter_by(userId=friendId, id=pokeId).first():
			return "Your friend already has this pokemon", 400
		if PokemonEntry.query.filter_by(userId=id).count() == 1:
			return "You need at least 2 pokemons to trade", 400
		pokemon = PokemonEntry.query.filter_by(userId=id, id=pokeId).first()
		pokemon.userId = friendId
		db.session.commit()
		return "Traded", 200
	else:
		return "Trade failed", 400

@app.route('/login', methods=['POST'])
def login():
	data = request.get_json()
	password = data.get('password')
	id = data.get('userId')

	if not password or not id:
		return jsonify({"error": "Missing form data"}), 400
	
	user = User.query.filter_by(id=id).first()
	if not user or user.password != password:
		return "Invalid credentials", 401
	
	access_token = create_access_token(identity=id)
	return jsonify(access_token=access_token), 200

@app.route('/verify', methods=['GET'])
@jwt_required()
def verify():
	id = get_jwt_identity()

	print("id",id)
	if not validate(id):
		return "Invalid input", 400
	
	user = User.query.filter_by(id=id).first()
	if not user:
		return "User not found", 404
	
	return "OK", 200

@app.route('/pokemon/<int:pokemonId>', methods=['GET'])
def getPokemon(pokemonId):
	response = requests.get(base + f"/pokemon/{pokemonId}")
	return jsonify(response.json())

@app.route('/about/<userId>', methods=['GET'])
def getUserId(userId):
	user = User.query.filter_by(id=userId).first()
	if user:
		return jsonify({"id": user.id, "name": user.name}), 200
	else:
		return "User not found", 400

@app.route('/pokemons', methods=['GET'])
@jwt_required()
def allPokemons():
	response = requests.get(base + "/pokemon?limit=100")
	data = response.json()
	entries = PokemonEntry.query.filter_by(userId=get_jwt_identity()).all()
	data["captured"] = [entry.id for entry in entries]
	return jsonify(data), 200

@app.route('/captured/<userId>', methods=['GET'])
def capturedPokemons(userId):
	entries = PokemonEntry.query.filter_by(userId=userId).all()
	data = [entry.id for entry in entries]
	return jsonify(data), 200

@app.route('/captured', methods=['GET'])
@jwt_required()
def userCapturedPokemons():
	entries = PokemonEntry.query.filter_by(userId=get_jwt_identity()).all()
	data = [entry.id for entry in entries]
	return jsonify(data), 200

@app.route('/uploads/<userId>', methods=['GET'])
def uploaded_file(userId):
	user = User.query.filter_by(id=userId).first()
	
	if user and user.profile_picture:
		return send_from_directory(app.config['UPLOAD_FOLDER'], user.profile_picture)
	return send_from_directory('public', "profile.svg")

@app.route('/friend/<personId>', methods=['POST', 'DELETE'])
@jwt_required()
def updateFriend(personId):
	id = get_jwt_identity()

	if not validate(id):
		return "Invalid input", 400

	if request.method == 'DELETE':
		entry = FriendEntry.query.filter_by(user_id=id, friend_id=personId).first()
		
		if not entry:
			return "User not in friends list", 400
		db.session.delete(entry)
		db.session.commit()

		return "Removed from friends list", 200

	if request.method == 'POST':
		if FriendEntry.query.filter_by(user_id=id, friend_id=personId).first() or FriendEntry.query.filter_by(user_id=personId, friend_id=id).first():
			return "User already in friends list", 400	
		if id == personId:
			return "Cannot add yourself", 400
		
		friend = User.query.filter_by(id=personId).first()
		if not friend:
			return "User not found", 404
		
		entry = FriendEntry(name=friend.name, user_id=id, friend_id=personId)
		db.session.add(entry)
		db.session.commit()

		return jsonify({"name":friend.name}), 200

@app.route('/friends', methods=['GET'])
@jwt_required()
def getFriends():
	id = get_jwt_identity()

	if not validate(id):
		return "Invalid input", 400
	
	friend_entries = FriendEntry.query.filter_by(user_id=id).all()
	friend_entries.extend(FriendEntry.query.filter_by(friend_id=id).all())

	return jsonify([e.to_dict() for e in friend_entries]), 200

@app.route('/upload', methods=['POST'])
def upload_file():
	file = request.files.get('image')
	user_id = get_jwt_identity()

	if not file or file.filename == '' or not user_id:
		return 'Missing form data or user not logged in', 400

	extension = file.filename.rsplit('.', 1)[-1]
	filename = f"{user_id}.{extension}"
	upload_folder = os.path.join(os.getcwd(), 'uploads')
	os.makedirs(upload_folder, exist_ok=True)

	filepath = os.path.join(upload_folder, filename)
	file.save(filepath)

	user = User.query.filter_by(id=user_id).first()
	user.profile_picture = filename
	db.session.commit()

	return 'Image uploaded and user saved!'


@app.route('/silhouette', methods=['GET'])
@jwt_required()
def get_silhouette():
	id = get_jwt_identity()
	if not validate(id):
		return "Invalid input", 400
	
	silhouette = SilhouetteQuestion.query.filter_by(userId=id).first()
	if silhouette:
		db.session.delete(silhouette)
		db.session.commit()

	silhouette = SilhouetteQuestion(userId=id, pokemon=random.randint(1, 2))
	db.session.add(silhouette)
	db.session.commit()

	print(silhouette.pokemon)

	return jsonify({"pokemon": silhouette.pokemon}), 200

def get_id(name):
	response = requests.get(f"https://pokeapi.co/api/v2/pokemon/{name.lower()}")
	if response.status_code == 200:
		return response.json()["id"]
	return None

def get_name(pokemon_id):
	response = requests.get(f"https://pokeapi.co/api/v2/pokemon/{pokemon_id}")
	if response.status_code == 200:
		return response.json()["name"]
	return None
	
@app.route('/silhouette/<pokemonName>', methods=['POST'])
@jwt_required()
def check_silhouette(pokemonName):
	id = get_jwt_identity()
	if not validate(id):
		return "Invalid input", 400

	silhouette = SilhouetteQuestion.query.filter_by(userId=id).first()
	if not silhouette:
		return "No silhouette found", 404

	pokemonId = get_id(pokemonName)
	name = get_name(silhouette.pokemon)
	
	if not pokemonId or silhouette.pokemon != pokemonId:
		return name, 400

	db.session.delete(silhouette)
	
	if PokemonEntry.query.filter_by(userId=id, id=str(pokemonId)).first():
		return name, 208
	
	db.session.add(PokemonEntry(userId=id, id=str(pokemonId)))
	db.session.commit()

	return name, 200


if __name__ == '__main__':
	with app.app_context():
		db.drop_all()
		db.create_all()
	app.run(debug=True)
