from flask import Blueprint, jsonify
from connection import connect_to_db


genres = Blueprint('genres', __name__)


# Получить все жанры
@genres.route("/genre", methods=["GET"])
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
