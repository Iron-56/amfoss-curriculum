from db import db

class SerializableMixin:
    def to_dict(self):
        return {c.name: getattr(self, c.name) for c in self.__table__.columns}

class Watchlist(db.Model):
	id = db.Column(db.Integer, primary_key=True)
	user_id = db.Column(db.String(20), db.ForeignKey('user.id'))
	movie_id = db.Column(db.String(20), nullable=False)

	def to_dict(self):
		return {
			"userId": self.user_id,
			"movieId": self.movie_id,
		}

class HistoryEntry(db.Model):
	id = db.Column(db.Integer, primary_key=True)
	user_id = db.Column(db.String(20), db.ForeignKey('user.id'))
	movie_id = db.Column(db.String(20), nullable=False)

	def to_dict(self):
		return {
			"userId": self.user_id,
			"movieId": self.movie_id,
		}

class User(db.Model):
	name = db.Column(db.String(20), nullable=False)
	password = db.Column(db.String(20), nullable=False)
	id = db.Column(db.String(20), primary_key=True)
	profile_picture = db.Column(db.String(30), nullable=True)

	def __repr__(self):
		return f'<User {self.name}>'

class MovieComment(db.Model):
	id = db.Column(db.Integer, primary_key=True)
	movie_id = db.Column(db.String(20), nullable=False)
	text = db.Column(db.String(200), nullable=False)
	user_id = db.Column(db.String(20), db.ForeignKey('user.id'), nullable=False)
	likes = db.Column(db.Integer, default=0, nullable=False)
	username = db.Column(db.String(20))

	def to_dict(self):
		return {
			"id": self.id,
			"userId": self.user_id,
			"movieId": self.movie_id,
			"text": self.text,
			"likes": self.likes,
			"name": self.username
			# "timestamp": self.timestamp.isoformat() if self.timestamp else None
		}

	def __repr__(self):
		return f'<Comment {self.text}>'
	
class FollowEntry(db.Model):
	user_id = db.Column(db.String(20), db.ForeignKey('user.id'), primary_key=True)
	follow_user_id = db.Column(db.String(20), db.ForeignKey('user.id'), primary_key=True)
	timestamp = db.Column(db.DateTime, default=db.func.current_timestamp())

	def to_dict(self):
		return {
			"user_id": self.user_id,
			"follow_user_id": self.follow_user_id,
			"timestamp": self.timestamp.isoformat()
		}

class Playlist(db.Model, SerializableMixin):
	id = db.Column(db.Integer, primary_key=True)
	name = db.Column(db.String(100), nullable=False)
	user_id = db.Column(db.String(20), db.ForeignKey('user.id'), nullable=False)
	likes = db.Column(db.Integer, default=0)

	def __repr__(self):
		return self.id
	
class PlaylistEntry(db.Model):
	id = db.Column(db.Integer, primary_key=True)
	playlist_id = db.Column(db.Integer, db.ForeignKey('playlist.id'), nullable=False)
	imdb_id = db.Column(db.String(20), nullable=False)

	def __repr__(self):
		return self.imdb_id