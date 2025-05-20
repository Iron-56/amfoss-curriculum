from db import db

class User(db.Model):
	name = db.Column(db.String(20), nullable=False)
	password = db.Column(db.String(20), nullable=False)
	id = db.Column(db.String(20), primary_key=True)
	profile_picture = db.Column(db.String(30), nullable=True)

	def __repr__(self):
		return f'<User {self.name}>'

class FriendEntry(db.Model):
	__table_args__ = (
		db.PrimaryKeyConstraint('user_id', 'friend_id'),
	)

	name = db.Column(db.String(20), nullable=False)
	user_id = db.Column(db.String(20), db.ForeignKey('user.id'), primary_key=True)
	friend_id = db.Column(db.String(20), db.ForeignKey('user.id'), primary_key=True)
	timestamp = db.Column(db.DateTime, default=db.func.current_timestamp())

	def to_dict(self):
		return {
			"name": self.name,
			"user_id": self.user_id,
			"friend_id": self.friend_id,
			"timestamp": self.timestamp.isoformat()
		}
	
class PokemonEntry(db.Model):
	__table_args__ = (
		db.PrimaryKeyConstraint('userId', 'id'),
	)
	userId = db.Column(db.String(20), primary_key=True)
	id = db.Column(db.String(20), primary_key=True)

	def __repr__(self):
		return f'<PokemonEntry userId={self.userId}, id={self.id}>'


class SilhouetteQuestion(db.Model):
	__tablename__ = 'silhouette_questions'
	userId = db.Column(db.String(20), db.ForeignKey('user.id'), primary_key=True)
	pokemon = db.Column(db.Integer, nullable=False)

	def __repr__(self):
		return f'<SilhouetteQuestion {self.question}>'