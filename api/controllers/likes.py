from flask import Blueprint, jsonify
from connection import connect_to_db


likes = Blueprint('likes', __name__)


# Запрос для получения всех лайков пользователя.
@likes.route("/likes/<nickname>", methods=["GET"])
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
@likes.route("/likes/<nickname>/<eventId>", methods=["POST"])
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


@likes.route("/likes/<nickname>/<eventId>", methods=["DELETE"])
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
