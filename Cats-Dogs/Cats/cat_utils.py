import os
import psycopg2

DB_HOST = os.getenv("POSTGRES_HOST")
DB_NAME = os.getenv("POSTGRES_DB")
DB_USER = os.getenv("POSTGRES_USER")
DB_PASSWORD = os.getenv("POSTGRES_PASSWORD")

def connect_db():
    con = psycopg2.connect(database=DB_NAME, user=DB_USER, password=DB_PASSWORD, host=DB_HOST, port="5432")
    return con

def _get_cat_by_id(id):
    name = "Cat " + id
    data = {"name" : name}
    success = 1
    return success,data

def _create_cat(data):
    con = connect_db()
    cursor = con.cursor()

    query = "INSERT INTO cats (name, race, file_path) VALUES (\'{}\',\'{}\',\'gato.jpg\')".format(data['name'],data['race'])
    cursor.execute(query)
    con.commit()

    return 1

def _update_cat(id, data):
    return

def _delete_cat(id):
    return