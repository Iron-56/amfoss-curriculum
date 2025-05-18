from flask import Flask, request, jsonify, session, send_from_directory
from flask_cors import CORS
from flask_sqlalchemy import SQLAlchemy
import os
from db import db
from models import User, MovieComment, Playlist, Watchlist, HistoryEntry, FollowEntry
from datetime import timedelta
from bs4 import BeautifulSoup
from dotenv import load_dotenv
import requests

base = "https://api.themoviedb.org/3/"

load_dotenv()

app = Flask(__name__)

API_KEY = os.getenv("API_KEY")
APP_KEY = os.getenv("APP_KEY")

apikey = os.getenv(API_KEY)
app.secret_key = os.getenv(APP_KEY)
app.config['SQLALCHEMY_DATABASE_URI'] = 'sqlite:///sqlite.db'
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False
app.config.update(
    SESSION_COOKIE_SAMESITE="None",
    SESSION_COOKIE_SECURE=True
)


UPLOAD_FOLDER = os.path.join(os.getcwd(), 'uploads')
os.makedirs(UPLOAD_FOLDER, exist_ok=True)
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER

db.init_app(app)
CORS(app, supports_credentials=True, origins=['http://localhost:3000','http://127.0.0.1:3000'])

@app.route('/')
def home():
	user_id = session.get('userId')
	return f'User ID: {user_id}'

@app.route('/register', methods=['POST'])
def register():
	data = request.get_json()
	name = data.get('username')
	password = data.get('password')
	id = data.get('userId')

	if not name or not password or not id:
		return jsonify({"error": "Missing form data"}), 400
	
	if User.query.filter_by(id=id).first():
		return jsonify({"error": "User already exists"}), 400
	
	user = User(name=name, password=password, id=id)
	db.session.add(user)
	db.session.commit()

	session.permanent = True
	session['userId'] = id
	session['username'] = name
	session['password'] = password

	return "User created!", 201

@app.route('/delete_all_playlists')
def delete_all_playlists():
	try:
		db.session.query(Playlist).delete()
		db.session.commit()
		return "All playlists have been deleted.", 200
	except Exception as e:
		db.session.rollback()
		return f"An error occurred: {str(e)}", 500

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

	session['userId'] = id
	session['username'] = user.name
	session['password'] = password
	
	return "Login successful!", 200

@app.route('/comments', methods=['GET'])
def get_comments():
	movie_id = request.args.get('movieId')
	if not movie_id:
		return jsonify({"error": "Missing movie ID"}), 400
	
	comments = MovieComment.query.filter_by(movie_id=movie_id).all()
	return jsonify([c.to_dict() for c in comments])

@app.route('/comments', methods=['POST'])
def new_comment():
	data = request.get_json()
	text = data.get('text')
	movie_id = data.get('movieId')
	user_id = session.get('userId')

	if not text or not user_id:
		return 'Missing form data', 400

	user = User.query.filter_by(id=user_id).first()
	if not user:
		return 'User not found', 404

	username = user.name

	new_comment = MovieComment(text=text, user_id=user_id, movie_id=movie_id, username=username)
	db.session.add(new_comment)
	db.session.commit()

	return 'Comment added!', 200


@app.route('/search', methods=['POST'])
def search():
	title = request.args.get('q')
	genres = request.get_json()['filters']
	print(genres)
	if len(genres) > 0:
		genre_ids = ','.join(str(genre) for genre in genres)
		response = requests.get(base + f"discover/movie?api_key={apikey}&with_genres={genre_ids}")
		return jsonify(response.json())
	response = requests.get(base + f"search/movie?api_key={apikey}&query={title}")
	return jsonify(response.json())


@app.route("/discover/<int:movie_id>")
def movies_by_genre(movie_id):
	genre_ids = []
	response = requests.get(base + f"movie/{movie_id}?api_key={apikey}&language=en-US")
	
	if response.status_code == 200:
		data = response.json()
		genres = data.get("genres", []) 
		genre_ids = [genre["id"] for genre in genres]
	
	if not genre_ids:
		return jsonify({"error": "No genres found for this movie."}), 404
	
	response = requests.get(base + f"discover/movie?api_key={apikey}&with_genres={genre_ids[0]}&language=en-US")
	
	if response.status_code == 200:
		data = response.json()
		return jsonify(data.get("results", []))
	else:
		return jsonify([])

@app.route('/trending')
def get_trending_movies():
	url = f"https://api.themoviedb.org/3/trending/movie/day?api_key={apikey}"
	response = requests.get(url)
	if response.status_code == 200:
		return jsonify(response.json())
	else:
		return jsonify({"error": "Failed to fetch trending movies"}), 500

@app.route('/genres', methods=['GET'])
def get_genres():
	url = f"{base}genre/movie/list?api_key={apikey}&language=en-US"
	response = requests.get(url)
	if response.status_code == 200:
		return jsonify(response.json().get("genres"))
	return jsonify({"error": "Failed to fetch genres"}), 500
	
@app.route('/session')
def session_data():
	return jsonify(dict(session))

@app.route('/watchlist', methods=['GET', 'POST', 'DELETE'])
def update_watchlist():
    user_id = session.get('userId')
    if not user_id:
        return 'User not logged in!', 400

    user = User.query.filter_by(id=user_id).first()
    if not user:
        return 'User not found', 404

    if request.method == 'DELETE':
        movie_id = request.args.get('movieId')
        if not movie_id:
            return 'Missing movie ID', 400

        entry = Watchlist.query.filter_by(user_id=user_id, movie_id=movie_id).first()
        if not entry:
            return 'Movie not in watchlist', 400

        db.session.delete(entry)
        db.session.commit()
        return 'Movie removed from watchlist!'

    if request.method == 'POST':
        movie_id = request.args.get('movieId')
        if not movie_id:
            return 'Missing movie ID', 400

        existing = Watchlist.query.filter_by(user_id=user_id, movie_id=movie_id).first()
        if existing:
            return 'Movie already in watchlist', 400

        new_entry = Watchlist(user_id=user_id, movie_id=movie_id)
        db.session.add(new_entry)
        db.session.commit()
        return 'Movie added to watchlist!', 201

    if request.method == 'GET':
        watchlist_entries = Watchlist.query.filter_by(user_id=user_id).all()

        movies = []
        for entry in watchlist_entries:
            movie_id = entry.movie_id
            response = requests.get(base + f"movie/{movie_id}?api_key={apikey}")
            if response.status_code == 200:
                movies.append(response.json())
            else:
                return jsonify({"error": f"Failed to fetch movie {movie_id}"}), 500

        return jsonify(movies)

    return 'Invalid request method', 400

@app.route('/logout', methods=['POST'])
def logout():
	session.pop('userId', None)
	session.pop('username', None)
	session.pop('password', None)
	return 'Logged out successfully!', 200

@app.route('/history/<user_id>', methods=['GET'])
def get_history(user_id):
	if not user_id:
		return 'Missing user ID', 400

	history_entries = HistoryEntry.query.filter_by(user_id=user_id).all()
	movies = []
	for entry in history_entries:
		movie_id = entry.movie_id
		response = requests.get(base + f"movie/{movie_id}?api_key={apikey}")
		if response.status_code == 200:
			movies.append(response.json())
		else:
			return jsonify({"error": f"Failed to fetch movie {movie_id}"}), 500

	return jsonify(movies)

@app.route('/about', methods=['GET'])
def about_you():
	user_id = session.get('userId')
	if not user_id:
		return 'User not signed in', 400

	user = User.query.filter_by(id=user_id).first()
	if not user:
		return 'User not found', 404

	return jsonify({
		'id': user.id,
		'name': user.name
	})

@app.route('/about/<user_id>', methods=['GET'])
def about_user(user_id):
	if not user_id:
		return 'Missing user ID', 400

	user = User.query.filter_by(id=user_id).first()
	if not user:
		return 'User not found', 404

	return jsonify({
		'id': user.id,
		'name': user.name
	})

@app.route('/userdata/<user_id>', methods=['GET'])
def get_user_data(user_id):
	if not user_id:
		return 'Missing user ID', 400

	user = User.query.filter_by(id=user_id).first()
	if not user:
		return 'User not found', 404
	
	followers = FollowEntry.query.filter_by(follow_user_id=user_id).all()
	following = FollowEntry.query.filter_by(user_id=user_id).all()

	follower_ids = {f.user_id for f in followers}
	following_ids = {f.follow_user_id for f in following}

	mutual_ids = follower_ids & following_ids

	mutual_users = User.query.filter(User.id.in_(mutual_ids)).all()
	mutual_followers_info = [{'id': u.id, 'name': u.name} for u in mutual_users]

	

	return jsonify({
		'id': user.id,
		'name': user.name,
		# 'mutual_followers': mutual_followers_info,
		'followers': [{'id': f.user_id} for f in followers],
	})


@app.route('/history', methods=['GET', 'POST'])
def update_history():
	user_id = session.get('userId')
	if not user_id:
		return 'User not logged in!', 400

	if request.method == 'POST':
		movie_id = request.args.get('movieId')
		if not movie_id:
			return 'Missing movie ID', 400

		new_entry = HistoryEntry(user_id=user_id, movie_id=movie_id)
		db.session.add(new_entry)
		db.session.commit()
		return 'Movie added to history!', 201

	if request.method == 'GET':
		history_entries = HistoryEntry.query.filter_by(user_id=user_id).all()

		movies = []
		for entry in history_entries:
			movie_id = entry.movie_id
			response = requests.get(base + f"movie/{movie_id}?api_key={apikey}")
			if response.status_code == 200:
				movies.append(response.json())
			else:
				return jsonify({"error": f"Failed to fetch movie {movie_id}"}), 500

		return jsonify(movies)

	return 'Invalid request method', 400

@app.route('/playlist', methods=['POST'])
def create_playlist():
	data = request.get_json()
	name = data.get('name')
	public = data.get('public', False)
	user_id = session.get('userId')

	if (not user_id) or (not name):
		return "Missing data"

	pl = Playlist(name=name, user_id=user_id)
	db.session.add(pl)
	db.session.commit()

	return "Playlist created!", 201

@app.route('/playlist', methods=['GET'])
def get_playlists():
	user_id = session.get('userId')

	print("User ID:", user_id)

	if not user_id:
		return jsonify({"error": "Missing user ID"}), 400

	playlists = Playlist.query.filter_by(user_id=user_id).all()
	return jsonify([p.to_dict() for p in playlists])

@app.route('/uploads/<userId>', methods=['GET'])
def uploaded_file(userId):
	user = User.query.filter_by(id=userId).first()
	
	if user and user.profile_picture:
		return send_from_directory(app.config['UPLOAD_FOLDER'], user.profile_picture)
	return send_from_directory('public', "profile.svg")

@app.route('/follow/<personId>', methods=['POST', 'DELETE'])
def follow(personId):
	userId = session.get('userId')

	user = User.query.filter_by(id=personId).first()

	if user and userId == user.id:
		return "Invalid input", 400

	if request.method == 'DELETE':
		entry = FollowEntry.query.filter_by(user_id=userId, follow_user_id=personId).first()
		
		if not entry:
			return "User not in following list", 400
		db.session.delete(entry)
		db.session.commit()

		return "Removed from following list", 200

	if request.method == 'POST':

		entry = FollowEntry(user_id=userId, follow_user_id=personId)
		db.session.add(entry)
		db.session.commit()

		return "Added to following list", 200

@app.route('/unfollow/<personId>', methods=['DELETE'])
def unfollow(personId):
	userId = session.get('userId')

	user = User.query.filter_by(id=personId).first()

	if user.id == personId:
		return "User cannot unfollow themself", 400

	entry = FollowEntry.query.filter_by(user_id=userId, follow_user_id=personId).first()
	
	if not entry:
		return "User not in following list", 400
	
	db.session.delete(entry)
	db.session.commit()

	return "Removed from following list", 200

@app.route('/following', methods=['GET'])
def following():
	userId = session.get('userId')

	following_entries = FollowEntry.query.filter_by(user_id=userId).all()
	return jsonify([e.to_dict() for e in following_entries])

@app.route('/followers', methods=['GET'])
def followers():
	userId = session.get('userId')

	follower_entries = FollowEntry.query.filter_by(follow_user_id=userId).all()
	return jsonify([e.to_dict() for e in follower_entries])
	
@app.route('/moviedata', methods=['GET'])
def moviedata():
	id = request.args.get('q')
	response = requests.get(base + f"movie/{id}?api_key={apikey}")

	return jsonify(response.json())

@app.route('/upload', methods=['POST'])
def upload_file():
	file = request.files.get('image')
	user_id = session.get('userId')

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


if __name__ == '__main__':
	with app.app_context():
		db.create_all()
	app.run(debug=True)
