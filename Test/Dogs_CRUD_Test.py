# test_with_unittest.py
import os
import psycopg2
import psycopg2.extras
from unittest import TestCase
import cat_utils

DB_HOST = os.getenv("POSTGRES_HOST")
DB_NAME = os.getenv("POSTGRES_DB")
DB_USER = os.getenv("POSTGRES_USER")
DB_PASSWORD = os.getenv("POSTGRES_PASSWORD")

class Dogs_CRUD_Test():
    def _get_dog_by_id_Test(self,id):
        self.assertEquals(dog_utils._get_dog_by_id(-1),-1,"Fallo en _get_dog_by_id_Test al introducir id = -1")
        self.assertEquals(dog_utils._get_dog_by_id(1000000),-1,"Fallo en _get_dog_by_id_Test al introducir un id inexistente")
        self.assertEquals(dog_utils._get_dog_by_id(id),-1,"Fallo en _get_dog_by_id_Test al introducir id = -1")
        self.assertEquals(dog_utils._get_dog_by_id(id),-1,"Fallo en _get_dog_by_id_Test al introducir id = -1")


    def _create_dog_Test(self):
        self.assertEquals(dog_utils._create_dog(-1),-1,"Fallo en  _create_dog_Test al introducir id = -1")
        self.assertEquals(dog_utils._create_dog(1000000),-1,"Fallo en _create_dog_Test al introducir un id inexistente")
        self.assertEquals(dog_utils._create_dog(id),-1,"Fallo en  _create_dog_Test al introducir id = -1")
        self.assertEquals(dog_utils._create_dog(id),-1,"Fallo en  _create_dog_Test al introducir id = -1")

    def _update_dog_Test(self, data):
        self.assertEquals(dog_utils._update_dog(-1),-1,"Fallo en  _create_dog_Test al introducir id = -1")
        self.assertEquals(dog_utils._update_dog(1000000),-1,"Fallo en _create_dog_Test al introducir un id inexistente")
        self.assertEquals(dog_utils._update_dog(id),-1,"Fallo en  _create_dog_Test al introducir id = -1")
        self.assertEquals(dog_utils._update_dog(id),-1,"Fallo en  _create_dog_Test al introducir id = -1")

    def _delete_dog_Test(id):
        self.assertEquals(dog_utils._delete_dog(-1),,"Fallo en  _create_dog_Test al introducir id = -1")
        self.assertEquals(dog_utils._delete_dog(1000000),-1,"Fallo en _create_dog_Test al introducir un id inexistente")
        self.assertEquals(dog_utils._delete_dog(id),({"Rows deleted" : rows_deleted}, image_path),"Fallo en  _create_dog_Test al introducir id = -1")
        self.assertEquals(dog_utils._delete_dog(id),-1,"Fallo en  _create_dog_Test al introducir id = -1")