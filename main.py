import time

import psycopg2 as pg
from psycopg2.extensions import register_adapter
from flask import Flask, request, jsonify
import json
import hashlib
import datetime
from ast import literal_eval

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
    return str(True).lower()


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
    return_request = dict(zip(colnames, user))

    # Ответ
    if user is not None:
        return jsonify(return_request)
    else:
        return str(False).lower()

# ----------------------------------------------------------------------------------
# ------------------------------------ВСТРЕЧИ---------------------------------------
# ----------------------------------------------------------------------------------


# Добавить мероприятие в таблицу
@app.route("/meeting/add", methods=["POST"])
def add_to_meeting_table():
    title = request.args.get("title")
    game_name = request.args.get("game_name")
    body = request.args.get("body")
    user_nickname = request.args.get("user_nickname")
    status = bool(request.args.get("status"))
    genre = request.args.get("genre")
    geo_marker = request.args.get("geo_marker")
    count_players = int(request.args.get("count_players"))
    meeting_time = time.localtime(int(request.args.get("meeting_time")) / 1000)


    meeting_geo = literal_eval(geo_marker)
    meeting_geo = f"({meeting_geo[0]}, {meeting_geo[1]})"
    meeting_datetime = datetime.datetime(
        meeting_time.tm_year,
        meeting_time.tm_mon,
        meeting_time.tm_mday,
        meeting_time.tm_hour,
        meeting_time.tm_min
    )
    # SQL запрос для добавления встречи
    sql = """
            INSERT INTO Meeting (title, game, body, organizer, status, geo_marker, genre, count_players, meeting_time)
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)
            RETURNING meeting_id;
        """

    conn = connect_to_db()
    cursor = conn.cursor()
    # Выполнение запроса для добавления встречи
    cursor.execute(sql, (title, game_name, body, user_nickname, status, meeting_geo, genre, count_players, meeting_datetime, ))
    conn.commit()
    cursor.close()

    # Ответ
    return str(True).lower()

#ПОМЕНЯТЬ НА ТОЛЬКО ИЗМЕНЕНИЕ ОПИСАНИЯ и СТАТУСА

# Обновление данных встречи
@app.route("/meeting/<meeting_id>", methods=["PUT"])
def change_meeting_information(meeting_id):
    body = request.args.get("body")
    status = request.args.get("status")
    #geo_marker = request.args.get("geo_marker")

    conn = connect_to_db()
    # SQL запрос для обновления встречи
    sql = """
                UPDATE meeting
                SET body = %s,
                    status = %s
                WHERE meeting_id = %s;
            """
#                    geo_marker = %s

    # Выполнение запроса
    cursor = conn.cursor()
    cursor.execute(sql, (body, status, meeting_id))
    conn.commit()
    cursor.close()

    # Ответ
    return str(True).lower()


# Запрос для получения встречи
@app.route("/meeting/<int:meeting_id>", methods=["GET"])
def select_meeting_information(meeting_id):
    conn = connect_to_db()
    sql = """
            SELECT m.*, loc.name_of_club 
            FROM Meeting as  m inner join 
            location_of_stationary_place as loc
            ON loc.geo_marker ~= m.geo_marker
            WHERE meeting_id = %s ;
        """
    # sql2 = """
    #         SELECT loc.name_of_club
    #         FROM location_of_stationary_place as loc, meeting as m
    #         where loc.geo_marker ~= m.geo_marker and m.meeting_id = %s
    # """
    # Выполнение запроса
    cursor = conn.cursor()
    cursor.execute(sql, (meeting_id,))
    meeting = cursor.fetchone()
    colnames = [desc[0] for desc in cursor.description]

    # cursor.execute(sql2, (meeting_id,))
    # meeting_club = cursor.fetchone()
    # colname_club = [desc[0] for desc in cursor.description]

    return_request = []
    cursor.close()
    meeting = list(meeting)
    meeting[5] = meeting[5].isoformat()
    meeting[10] = meeting[10].isoformat()
    meeting[7] = literal_eval(meeting[7])

    # meeting.append(meeting_club[0])
    # colnames.append(colname_club[0])
    # print(meeting, colnames)
    return_request = dict(zip(colnames, meeting))
    # Ответ

    if meeting is not None:
        return jsonify(return_request)
    else:
        return str(False).lower()


# Запрос для получения всех встреч
@app.route("/meeting", methods=["GET"])
def get_all_meetings():

    conn = connect_to_db()
    sql = """
            SELECT m.*, loc.name_of_club 
            FROM Meeting as  m inner join 
            location_of_stationary_place as loc
            ON loc.geo_marker ~= m.geo_marker
        """


    # Выполнение запроса
    cursor = conn.cursor()
    cursor.execute(sql)
    meetings = cursor.fetchall()
    cursor.close()
    colnames = [desc[0] for desc in cursor.description]
    print(colnames)

    return_request = []

    for meeting in meetings:
        meeting = list(meeting)
        meeting[9] = meeting[9].isoformat()
        meeting[6] = literal_eval(meeting[6])
        return_request.append(dict(zip(colnames, meeting)))
    print(return_request)
    return_request = return_request

    # Ответ
    if meetings is not None:
        return jsonify(return_request)
    else:
        return {"message": "Meetings not found"}


# Запрос для удаления встречи
@app.route("/meeting/<meeting_id>", methods=["DELETE"])
def remove_from_meeting(meeting_id):
    conn = connect_to_db()
    sql = """
            DELETE FROM meeting
            WHERE meeting_id = %s;
        """

    # Выполнение запроса
    cursor = conn.cursor()
    cursor.execute(sql, (meeting_id,))
    conn.commit()
    cursor.close()

    # Ответ
    return str(True).lower()


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
        return_request = popp
    except Exception:
        meeting = None

    # Ответ
    if meeting is not None:
        return jsonify(return_request)
    else:
        return str(False).lower()


# Запрос для добавления\удаления лайков пользователя.
# Надо сделать сначала обработку встреча-(булеан=1), то есть добавить встречу, потом наоборот
@app.route("/likes/<nickname>/<eventId>", methods=["POST"])
def put_user_like(nickname, eventId):
    conn = connect_to_db()
    sql = """
            INSERT INTO likes (meeting_id, nickname)
            VALUES (%s , %s);
        """

    # Выполнение запроса
    cursor = conn.cursor()
    cursor.execute(sql, (eventId, nickname,))
    conn.commit()
    cursor.close()

    # Ответ
    return {"success": True}


@app.route("/likes/<nickname>/<eventId>", methods=["DELETE"])
def delete_user_like(nickname, eventId):
    conn = connect_to_db()
    sql = """
            DELETE FROM likes
            WHERE meeting_id = %s AND nickname = %s;
        """

    # Выполнение запроса
    cursor = conn.cursor()
    cursor.execute(sql, (eventId, nickname,))
    conn.commit()
    cursor.close()

    # Ответ
    return {"success": True}


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
    return_request = return_request

    # Ответ
    if genre is not None:
        return jsonify(return_request)
    else:
        return str(False).lower()


# Получить всех мест клубов
@app.route("/places", methods=["GET"])
def get_all_places():
    conn = connect_to_db()
    # SQL запрос для получения пользователя
    sql = """
            SELECT *
            FROM location_of_stationary_place;
        """

    # Выполнение запроса
    cursor = conn.cursor()
    cursor.execute(sql, )
    places = cursor.fetchall()
    cursor.close()
    colnames = [desc[0] for desc in cursor.description]
    print(colnames)
    # print(meeting)

    return_request = []

    for x in places:
        x = list(x)
        x[1] = literal_eval(x[1])
        return_request.append(dict(zip(colnames, x)))
    print(return_request)

    # Ответ
    if places is not None:
        return jsonify(return_request)
    else:
        return {"message": "Places not found"}


# Получить все игры
@app.route("/games", methods=["GET"])
def get_all_games():
    conn = connect_to_db()
    # SQL запрос для получения пользователя
    sql = """
            SELECT*
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
    return_request = return_request
    print(return_request)
    # Ответ
    if game is not None:
        return jsonify(return_request)
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
