from flask import Blueprint, jsonify
from connection import connect_to_db


games = Blueprint('games', __name__)


# Получить все игры
@games.route("/games", methods=["GET"])
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
    