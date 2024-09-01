from flask import Blueprint, request, jsonify
from connection import connect_to_db


users = Blueprint('users', __name__)


# ДОБАВЛЕНИЕ/РЕГИСТРАЦИЯ ПОЛЬЗОВАТЕЛЯ
@users.route("/user", methods=["POST"])
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
@users.route("/check_pass", methods=["GET"])
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
@users.route("/user/<user_id>", methods=["PUT"])
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
@users.route("/user/<nickname>", methods=["GET"])
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
