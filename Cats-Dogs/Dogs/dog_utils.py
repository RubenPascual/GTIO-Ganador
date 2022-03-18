import os
import psycopg2
import psycopg2.extras

DB_HOST = os.getenv("POSTGRES_HOST")
DB_NAME = os.getenv("POSTGRES_DB")
DB_USER = os.getenv("POSTGRES_USER")
DB_PASSWORD = os.getenv("POSTGRES_PASSWORD")

def connect_db():
    con = psycopg2.connect(database=DB_NAME, user=DB_USER, password=DB_PASSWORD, host=DB_HOST, port="5432")
    return con

def _get_dog_by_id(id):
    con = connect_db()
    cursor = con.cursor(cursor_factory=psycopg2.extras.RealDictCursor)

    query = "SELECT * FROM dogs WHERE dog_id = %s"
    cursor.execute(query, (id,))
    data = cursor.fetchone()

    cursor.close()
    con.close()

    return data

def _create_dog(data):
    con = connect_db()
    cursor = con.cursor(cursor_factory=psycopg2.extras.RealDictCursor)

    query = "INSERT INTO dogs (name, race, file_path) VALUES (%s,%s,%s) RETURNING dog_id"
    cursor.execute(query, (data['name'],data['race'], "gato.jpg"))

    id = cursor.fetchone()
    if id is not None:
        id = id["dog_id"]
    else:
        id = -1

    con.commit()

    cursor.close()
    con.close()
    return {"dog_id" : id}

def _update_dog(id, data):
    return -1

def _delete_dog(id):
    return -1