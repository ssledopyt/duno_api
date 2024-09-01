from flask import Flask

from controllers import places, games, genres, likes, meetings, users
from connection import try_connect_to_db

app = Flask(__name__)

app.register_blueprint(places.places)
app.register_blueprint(games.games)
app.register_blueprint(genres.genres)
app.register_blueprint(likes.likes)
app.register_blueprint(meetings.meetings)
app.register_blueprint(users.users)


@app.route("/")
def hello():
    return "hello"


if __name__ == '__main__':
    if try_connect_to_db():
        app.run(port=4000, host="0.0.0.0")
    else:
        print("No connection\t :(")
