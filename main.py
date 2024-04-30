import psycopg2 as pg
from flask import Flask, request
import json
import hashlib
import datetime

app = Flask(__name__)

@app.route("/")
def hello():
    return "hello"


# ----------------------------------------------------------------------------------
# ---------------------------------ПОЛЬЗОВАТЕЛЬ-------------------------------------
# ----------------------------------------------------------------------------------


# ДОБАВЛЕНИЕ/РЕГИСТРАЦИЯ ПОЛЬЗОВАТЕЛЯ
@app.route("/user", methods=["POST"])
def add_to_user_table():
    name = request.args.get("name")
    second_name = request.args.get("second_name")
    phone = request.args.get("phone")
    email = request.args.get("email")
    #password = hashlib.sha256(request.args.get("password").encode('utf-8')).hexdigest()
    password = request.args.get("password")
    nickname = request.args.get("nickname")

    # SQL запрос для добавления пользователя
    sql = '''
            INSERT INTO users (name, second_name, phone, email, password, nickname)
            VALUES (%s, %s, %s, %s, %s, %s)
            RETURNING user_id;
        '''

    conn = connect_to_db()
    cursor = conn.cursor()
    cursor.execute(sql, (name, second_name, phone, email, password, nickname,),)
    cursor.scroll(0, mode='absolute')
    user_id = cursor.fetchone()[0]
    conn.commit()
    cursor.close()
    # Ответ
    return str(True).lower()


# ПРОВЕРКА ПАРОЛЯ НА КОРРЕКТНОСТЬ
@app.route("/check_pass", methods=["GET"])
def check_password():
    nickname = request.args.get("nickname")
    password = request.args.get("password")
    # SQL запрос
    sql = """
        SELECT password
        FROM users
        WHERE nickname = %s;
    """
    conn = connect_to_db()

    # Выполнение запроса
    cursor = conn.cursor()
    cursor.execute(sql, (nickname,))

    # Получение результата
    user_data = cursor.fetchone()

    # Закрытие курсора
    cursor.close()
    # Проверка пароля
    if user_data is not None:
        stored_password_hash = user_data[0]
        print(user_data, stored_password_hash)
        #input_password_hash = hashlib.sha256(password.encode('utf-8')).hexdigest()

        return str(stored_password_hash == password).lower()
    else:
        return str(False).lower()


# Изменение информации о пользователе
@app.route("/user/<user_id>", methods=["PUT"])
def change_user_information(user_id):
    name = request.args.get("name")
    second_name = request.args.get("second_name")
    password = request.args.get("password")

    conn = connect_to_db()
    # SQL запрос для обновления пользователя
    sql = """
        UPDATE users
        SET password = IFNULL(%s, password),
            name = IFNULL(%s, name),
            second_name = IFNULL(%s, second_name)
        WHERE user_id = %s;
    """

    # Выполнение запроса
    cursor = conn.cursor()
    cursor.execute(sql, (password, name, second_name, user_id))
    conn.commit()
    cursor.close()

    # Ответ
    return {"success": True}


# Найти информацию о пользователе по никнейму
@app.route("/user/<nickname>", methods=["GET"])
def select_user_information(nickname):

    conn = connect_to_db()
    # SQL запрос для получения пользователя
    sql = """
            SELECT *
            FROM users
            WHERE nickname = %s;
        """

    # Выполнение запроса
    cursor = conn.cursor()
    cursor.execute(sql, (nickname,))
    user = cursor.fetchone()
    cursor.close()
    colnames = [desc[0] for desc in cursor.description]
    return_request = json.loads(json.dumps(dict(zip(colnames, user))))

    # Ответ
    if user is not None:
        return return_request
    else:
        return {"success": False, "message": "User not found"}

# ----------------------------------------------------------------------------------
# ------------------------------------ВСТРЕЧИ---------------------------------------
# ----------------------------------------------------------------------------------


# Добавить мероприятие в таблицу
@app.route("/meeting", methods=["POST"])
def add_to_meeting_table():
    title = request.args.get("title")
    game_name = request.args.get("game_name")
    body = request.args.get("body")
    user_nickname = request.args.get("user_nickname")
    status = request.args.get("status")
    geo_marker = request.args.get("geo_marker")
    count_players = request.args.get("count_players")
    meeting_time = request.args.get("meeting_time")
    closed_at = request.args.get("closed_at")

    # SQL запрос для получения названия игры
    sql_game = """
            SELECT game_name
            FROM game
            WHERE game_name = %s;
        """

    # SQL запрос для добавления встречи
    sql = """
            INSERT INTO Meeting (title, game, body, organizer, status, geo_marker, count_players, meeting_time, closed_at)
            VALUES (%s, %s, %s, %s, %s, %s, %s)
            RETURNING meeting_id;
        """

    # Выполнение запроса для получения названия игры
    conn = connect_to_db()
    cursor = conn.cursor()
    cursor.execute(sql_game, (game_name,))
    game_name = cursor.fetchone()[0]
    conn.commit()
    cursor.close()

    # Выполнение запроса для добавления встречи
    cursor.execute(sql, (title, game_name, body, user_nickname, status, geo_marker, count_players, meeting_time, closed_at,  ))
    meeting_id = cursor.fetchone()[0]
    conn.commit()
    cursor.close()


    # Ответ
    return {"success": True, "meeting_id": meeting_id}


# Обновление данных встречи
@app.route("/meeting/<meeting_id>", methods=["PUT"])
def change_meeting_information(meeting_id):
    body = request.args.get("body")
    status = request.args.get("status")
    geo_marker = request.args.get("geo_marker")

    conn = connect_to_db()
    # SQL запрос для обновления встречи
    sql = """
                UPDATE meetings
                SET body = IFNULL(%s, body),
                    status = IFNULL(%s, status),
                    geo_marker = IFNULL(%s, geo_marker)
                WHERE meeting_id = %s;
            """

    # Выполнение запроса
    cursor = conn.cursor()
    cursor.execute(sql, (body, status, geo_marker, meeting_id))
    conn.commit()
    cursor.close()

    # Ответ
    return {"success": True}


# Запрос для получения встречи
@app.route("/meeting/<int:meeting_id>", methods=["GET"])
def select_meeting_information(meeting_id):

    conn = connect_to_db()
    sql = """
            SELECT *
            FROM Meeting
            WHERE meeting_id = %s;
        """

    # Выполнение запроса
    cursor = conn.cursor()
    try:
        cursor.execute(sql, (meeting_id,))
        meeting = cursor.fetchone()
        cursor.close()
        colnames = [desc[0] for desc in cursor.description]
        return_request = json.loads(json.dumps(dict(zip(colnames, meeting))))
    except Exception:
        meeting = None

    # Ответ
    if meeting is not None:
        return return_request
    else:
        return {"success": False, "message": "Meeting not found"}


# Запрос для получения всех встреч
@app.route("/meeting", methods=["GET"])
def get_all_meetings():

    conn = connect_to_db()
    sql = """
            SELECT *
            FROM Meeting
        """

    # Выполнение запроса
    cursor = conn.cursor()
    cursor.execute(sql)
    meeting = cursor.fetchall()
    cursor.close()
    colnames = [desc[0] for desc in cursor.description]
    print(colnames)
    #print(meeting)

    return_request = []

    for x in meeting:
        x=list(x)
        x[5] = x[5].isoformat()
        x[10] = x[10].isoformat()
        return_request.append(dict(zip(colnames, x)))
    print(return_request)
    return_request = json.loads(json.dumps(return_request))

    # Ответ
    if meeting is not None:
        return return_request
    else:
        return {"message": "Meetings not found"}


# Запрос для удаления встречи
@app.route("/meeting/<meeting_id>", methods=["DELETE"])
def remove_from_meeting(meeting_id):
    conn = connect_to_db()
    sql = """
            DELETE FROM Meetings
            WHERE id = %s;
        """

    # Выполнение запроса
    cursor = conn.cursor()
    cursor.execute(sql, (meeting_id,))
    conn.commit()
    cursor.close()

    # Ответ
    return {"success": True}


# Запрос для получения всех лайков пользователя.
@app.route("/likes/<nickname>", methods=["GET"])
def user_likes(nickname):
    conn = connect_to_db()
    sql = """
            SELECT m.meeting_id
            FROM meeting AS m
            JOIN likes AS l ON m.meeting_id = l.meeting_id
            WHERE l.nickname = %s;
        """

    # Выполнение запроса
    cursor = conn.cursor()
    try:
        cursor.execute(sql, (nickname,))
        meeting = cursor.fetchall()
        cursor.close()
        colnames = [desc[0] for desc in cursor.description]
        return_request = {}
        dict_meeting = []
        print(meeting)
        for x in meeting:
            dict_meeting.append(x[0])
        popp = dict.fromkeys(colnames, dict_meeting)
        return_request = json.loads(json.dumps(popp))
    except Exception:
        meeting = None

    # Ответ
    if meeting is not None:
        return return_request
    else:
        return str(False).lower()


# Запрос для добавления\удаления лайков пользователя.
# Надо сделать сначала обработку встреча-(булеан=1), то есть добавить встречу, потом наоборот
@app.route("/likes/<nickname>/", methods=["POST"])
def put_user_likes(nickname):
    conn = connect_to_db()
    sql = """
            SELECT m.meeting_id
            FROM meeting AS m
            JOIN likes AS l ON m.meeting_id = l.meeting_id
            WHERE l.nickname = %s;
        """

    # Выполнение запроса
    cursor = conn.cursor()
    try:
        cursor.execute(sql, (nickname,))
        meeting = cursor.fetchall()
        cursor.close()
        colnames = [desc[0] for desc in cursor.description]
        return_request = {}
        dict_meeting = []
        print(meeting)
        for x in meeting:
            dict_meeting.append(x[0])
        popp = dict.fromkeys(colnames, dict_meeting)
        return_request = json.loads(json.dumps(popp))
    except Exception:
        meeting = None

    # Ответ
    if meeting is not None:
        return return_request
    else:
        return str(False).lower()


# Получить все жанры
@app.route("/genre", methods=["GET"])
def get_all_genres():
    conn = connect_to_db()
    # SQL запрос для получения пользователя
    sql = """
            SELECT name
            FROM genre;
        """

    # Выполнение запроса
    cursor = conn.cursor()
    cursor.execute(sql, )
    genre = cursor.fetchall()
    cursor.close()
    colnames = [desc[0] for desc in cursor.description]
    return_request = []
    for x in genre:
        return_request.append(dict(zip(colnames, x)))
    return_request = json.loads(json.dumps(return_request))

    # Ответ
    if genre is not None:
        return return_request
    else:
        return str(False).lower()


# Получить все игры
@app.route("/games", methods=["GET"])
def get_all_games():
    conn = connect_to_db()
    # SQL запрос для получения пользователя
    sql = """
            SELECT game_name
            FROM game;
        """

    # Выполнение запроса
    cursor = conn.cursor()
    cursor.execute(sql, )
    game = cursor.fetchall()
    cursor.close()
    colnames = [desc[0] for desc in cursor.description]
    return_request = []
    for x in game:
        return_request.append(dict(zip(colnames, x)))
    return_request = json.loads(json.dumps(return_request))

    # Ответ
    if game is not None:
        return return_request
    else:
        return str(False).lower()
# ----------------------------------------------------------------------------------
# ------------------------------------START DB--------------------------------------
# ----------------------------------------------------------------------------------


# Попытка подключения к БД
def try_connect_to_db():
    try:
        conn = pg.connect(
            host='localhost',
            database='duno',
            port=5432,
            user='postgres',
            password='p_admin'
        )
        print("Connection established.")
        return True
    except Exception as err:
        print("Something went wrong.")
        print(err)
        return False


def connect_to_db():
    conn = pg.connect(
        host='localhost',
        database='duno',
        port=5432,
        user='postgres',
        password='p_admin'
    )
    return conn

def timestamp_to_json(results):
    # Инициализация списка
    data = []

    # Обработка результатов
    for row in results:
        timestamp = row[0]

        # Преобразование timestamp в JSON-совместимый формат
        # (в зависимости от ваших требований)
        if isinstance(timestamp, datetime.datetime):
            timestamp_json = timestamp.isoformat()
        elif isinstance(timestamp, datetime.date):
            timestamp_json = timestamp.isoformat()
        else:
            timestamp_json = str(timestamp)

        # Добавление timestamp в список
        data.append({"timestamp": timestamp_json})
    return data

if __name__ == '__main__':
    if try_connect_to_db():
        app.run(port=4000, host="0.0.0.0")
    else:
        print(":(")
