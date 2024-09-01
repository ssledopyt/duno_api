from ast import literal_eval
from flask import Blueprint, jsonify
from connection import connect_to_db


places = Blueprint('places', __name__)


# Получить всех мест клубов
@places.route("/places", methods=["GET"])
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
    