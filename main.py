import psycopg2 as pg
from flask import Flask

app = Flask(__name__)

@app.route("/")
def hello_world():
    #cursor = connect_to_db()
    return "YES"

@app.route("/add_to_user_table/<user>")
def add_to_user_table():
    cursor = connect_to_db()

@app.route("/add_to_meeting_table")
def add_to_meeting_table():
    cursor = connect_to_db()

@app.route("/remove_from_meeting")
def remove_from_meeting():
    cursor = connect_to_db()

@app.route("/change_user_information")
def change_user_information():
    cursor = connect_to_db()

@app.route("/change_meeting_information")
def change_meeting_information():
    cursor = connect_to_db()

@app.route("/select_user_information")
def select_user_information():
    cursor = connect_to_db()

@app.route("/select_meeting_information")
def select_meeting_information():
    cursor = connect_to_db()




def connect_to_db():
    try:
        conn = pg.connect(
            host='localhost',
            database='Duno',
            port=5432,
            user='postgres',
            password='p_admin'
        )

        cursor = conn.cursor()
        print("Connection established.")
        return cursor
    except Exception as err:
        print("Something went wrong.")
        print(err)
        return False


def fetch_data(cursor):
    cursor.execute('''SELECT* FROM Genre''')
    data = cursor.fetchall()
    return data

def add_to_user_table():
    print(9)

def add_to_meeting_table():
    00

def remove_from_meeting():
    0

def change_user_information():
    0

def change_meeting_information():
    0

def select_user_information():
    0

def select_meeting_information():
    0


if __name__ == '__main__':
    app.run(port=4000, host="0.0.0.0")
