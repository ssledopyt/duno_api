import datetime
import time

from ast import literal_eval
from flask import Blueprint, request, jsonify
from connection import connect_to_db


meetings = Blueprint('meetings', __name__)


# Добавить мероприятие в таблицу
@meetings.route("/meeting/add", methods=["POST"])
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
@meetings.route("/meeting/<meeting_id>", methods=["PUT"])
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
@meetings.route("/meeting/<int:meeting_id>", methods=["GET"])
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
@meetings.route("/meeting", methods=["GET"])
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
@meetings.route("/meeting/<meeting_id>", methods=["DELETE"])
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
