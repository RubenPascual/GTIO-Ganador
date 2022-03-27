# test_with_unittest.py
import unittest
from flask import Flask,request,Response
import requests
import json
import os

import urllib.request

#import psycopg2
#import psycopg2.extras)
#from Cats-Dogs/Cats import cat_utils

ALLOWED_EXTENSIONS = set(['png'])
app = Flask(__name__)
app.testing = True
app.config['UPLOAD_FOLDER'] = os.getenv('UPLOAD_FOLDER')
client = app.test_client()

# create a password manager
password_mgr = urllib.request.HTTPPasswordMgrWithDefaultRealm()

# Add the username and password.
# If we knew the realm, we could use it instead of None.
top_level_url = "http://localhost:8000/cat/v0/"
username = "cat"
password = "cat"
password_mgr.add_password(None, top_level_url, username, password)

handler = urllib.request.HTTPBasicAuthHandler(password_mgr)

# create "opener" (OpenerDirector instance)
opener = urllib.request.build_opener(handler)

# use the opener to fetch a URL
opener.open("http://localhost:8000/cat/v0/")

# Install the opener.
# Now all calls to urllib.request.urlopen use our opener.
urllib.request.install_opener(opener)

class Cats_CRUD_Test(unittest.TestCase):

    def test_create_cat_Test(self):

       ##Creación de un gato correcta 
        """
        Test de creación de gato
        """
        url = 'localhost:8000/cat/v0'
        payload ={
                "name": "cat", 
                "race" : "raza",
                "file" : "/home/alumno/Escritorio/Cats&Dogs/GTIO-Ganador/Test/images/test_cat.png"
        }  
        resul = client.post(url, data = payload,auth=('cat', 'cat'))
        self.assertEqual(resul.status_code,200,"create_cat_Test no ha devuelto un status_code 200")
        if(resul.status_code == 200):
            rjson = resul.json()
            self.assertTrue (
                rjson["cat_id"] >=0 and isinstance(rjson, dict),
                "fallo en  create_cat_Test , se esperaba que fuera positivo y tiene valor : "+rjson["cat_id"]+" y que el tipo recibido fuera un diccionario tipo:"+type(rjson)
            )
        """
        Test de creación de gato
        """
       #Creación de un gato sin "file"   
        url = 'localhost:8000/cat/v0'
        payload ={
                "name": "cat", 
                "race" : "raza",
                "file" : ""
        }  
        resul = client.post(url,data = payload,auth=('cat', 'cat'))
        self.assertEqual(resul.status_code,400,"create_cat_Test no ha devuelto un status_code 400 para un gato sin file")
  

    def test_read_cat_Test(self):
        pruebas = [{"id": "1", "cod_expected" : 200},
            {"id": "1000", "cod_expected" : 400},
            {"id": "-1", "cod_expected" : 400}] 
        for i in pruebas:
            url =  "http://localhost:8000/cat/v0/"+i["id"]
           # resul = client.get(url)
             # print(url+"\n")
            req = urllib.request.Request(url=url, method='GET')
            resul = urllib.request.urlopen(req)


            print(resul)
            self.assertEqual(resul.status_code,i["cod_expected"],"El resultado de read_cat_Test para id = "+i["id"])

            if (resul.status_code == 200):
                rjson = resul.json()
                self.assertTrue (
                    rjson["cat_id"] >=0 and isinstance(rjson, dict),
                    "fallo en  create_cat_Test , se esperaba que fuera positivo y tiene valor : "+rjson["cat_id"]+" y que el tipo recibido fuera un diccionario tipo:"+ type(rjson)
                )

    def test_update_cat_Test(self):

        url = 'localhost:8000/cat/v0/1'
        payload ={
                "name": "cat", 
                "race" : "raza",
                "file" : "/home/alumno/Escritorio/Cats&Dogs/GTIO-Ganador/Test/images/test_cat.png"
        }   
        resul = client.put(url, data=payload,auth=('cat', 'cat'))
        
        self.assertEqual(resul.status_code,200,"create_cat_Test no ha devuelto un status_code 200")
        if(resul.status_code == 200):
            rjson = resul.json()
            self.assertTrue (
                rjson["cat_id"] >=0 and isinstance(rjson, dict),
                "fallo en  create_cat_Test , se esperaba que fuera positivo y tiene valor : "+rjson["cat_id"]+" y que el tipo recibido fuera un diccionario tipo:"+type(rjson)
            )

       #Update de un gato con id negativo"   
        url = 'localhost:8000/cat/v0/-1'
        payload ={
                "name": "cat", 
                "race" : "raza",
                "file" : "/home/alumno/Escritorio/Cats&Dogs/GTIO-Ganador/Test/images/test_cat.png"
        }  
        resul = client.put(url, data =payload,auth=('cat', 'cat'))
        self.assertEqual(resul.status_code,400,"create_cat_Test no ha devuelto un status_code 400 para un gato con id negativo")
   
        #Update de un gato sin "file"   
        url = 'localhost:8000/cat/v0/1'
        payload ={
                "name": "cat", 
                "race" : "raza",
                "file" : ""
        }   
        resul = client.put(url, data= payload,auth=('cat', 'cat'))
        self.assertEqual(resul.status_code,400,"create_cat_Test no ha devuelto un status_code 400 para un gato sin file")

    
    def test_delete_cat_Test(self):
        pruebas = [{"id": "1", "cod_expected" : 200},
            {"id": "1000", "cod_expected" : 400},
            {"id": "-1", "cod_expected" : 400}] 
        for i in pruebas:
            url =  'localhost:8000/cat/v0/'+i["id"]
            resul = client.delete(url,auth=('cat', 'cat'))
            self.assertEqual(resul.status_code,i["cod_expected"],"El resultado de read_cat_Test para id = "+i["id"] )

    def test_google_Test(self):
        url =  'https://www.google.es'
        resul = client.get(url)
        self.assertEqual(resul.status_code,200,"El resultado de read_cat_Test para id = 200")


