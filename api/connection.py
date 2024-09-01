import env
import psycopg2 as pg


# Попытка подключения к БД
def try_connect_to_db():
    try:
        conn = pg.connect(
            host = env.DB_HOST,
            database=env.PSQL_DB,
            port=5432,
            user=env.PSQL_USER,
            password=env.PSQL_PASS
        )
        print("Connection established.")
        return True
    except Exception as err:
        print("Something went wrong.")
        print(err)
        return False


def connect_to_db():
    conn = pg.connect(
        host = env.DB_HOST,
        database=env.PSQL_DB,
        port=5432,
        user=env.PSQL_USER,
        password=env.PSQL_PASS
    )
    return conn
