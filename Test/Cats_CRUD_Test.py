# test_with_unittest.py
# test_with_unittest.py
import unittest
from flask import Flask,request,Response
import requests
import base64
import json
import os
import urllib
import json
# importing sys
import sys
  
#import psycopg2
#import psycopg2.extras)
#from Cats-Dogs/Cats import cat_utils

ALLOWED_EXTENSIONS = set(["png"])
app = Flask(__name__)
app.testing = True
app.config["UPLOAD_FOLDER"] = os.getenv("UPLOAD_FOLDER")
client = app.test_client()

class Cats_CRUD_Test(unittest.TestCase):

    def test_create_cat_Test(self):

       ##Creación de un gato correcta 
        """
        Test de creación de gato
        """

        url = 'http://localhost:5050/v0/cat'
        payload ={
                'name': 'cat', 
                'race' : 'raza',
                'file' : '/home/alumno/Escritorio/Cats&Dogs/GTIO-Ganador/Test/images/test_cat.png'
        }
        
        req = urllib.request.Request(url=url,method='POST')
        req.add_header('Content-Type', 'application/json')
    # resul = urllib.request.urlopen(req) 
        with urllib.request.urlopen(req,data =json.dumps(payload).encode('UTF-8')) as resul:
            self.assertEqual(resul.status,200,"El resultado de create_cat_Test ")
            rjson = resul.read()
            s = rjson.decode('UTF-8')
            rjson = json.loads(rjson.decode('UTF-8'))   
            if(resul.status_code == 200):
                rjson = resul.read()
                s = rjson.decode('UTF-8')
                rjson = json.loads(rjson.decode('UTF-8'))  
                self.assertTrue (
                    rjson["cat_id"] >=0 ,
                    "fallo en  create_cat_Test , se esperaba que fuera positivo y tiene valor : "+rjson["cat_id"]
                )

    def read_cat_Test(self):
        '''
        test get un gato
        '''
        pruebas = [{"id": "1", "cod_expected" : 200}] 
        for i in pruebas:
            url =  'http://localhost:5050/v0/cat/'+i["id"]
            req = urllib.request.Request(url=url, method ='GET')
            with urllib.request.urlopen(req) as resul:
                self.assertEqual(resul.status,i["cod_expected"],"El resultado de read_cat_Test para id = "+i["id"])
                rjson = resul.read()
                s = rjson.decode('UTF-8')
                rjson = json.loads(rjson.decode('UTF-8'))               
                if (resul.status == 200):
                    self.assertTrue (
                        rjson["image"] != None and rjson["name"] != None and rjson["race"] != None ,
                        "fallo en  create_cat_Test , se esperaba que el contenido no estuviera vacio\n valor de la image: "+rjson["image"]+"\nValor de name: "+rjson["name"]+"\nValor de raza: "+ rjson["race"]
                    )

    def update_cat_Test(self):
        '''
        test update un gato
        '''
        pruebas = [{"id": "1", "cod_expected" : 200}] 

        for i in pruebas:
            url = 'http://localhost:5050/v0/cat/'+i["id"]
            payload ={
                    'name': 'cat', 
                    'race' : 'raza',
                    'file' : '/home/alumno/Escritorio/Cats&Dogs/GTIO-Ganador/Test/images/test_cat.png'
            }  
            #resul = client.put(url, data=payload)
            req = urllib.request.Request(url=url,data =json.dumps(payload).encode('UTF-8'),method='PUT')
            resul = urllib.request.urlopen(req) 
            with urllib.request.urlopen(req) as resul:
                self.assertEqual(resul.status,i["cod_expected"],"Codigo incorrecto en el update_cat_Test del gato con  id = "+i["id"]+", código "+resul.status)
                rjson = resul.read()
                s = rjson.decode('UTF-8')
                rjson = json.loads(rjson.decode('UTF-8'))   
                if(resul.status_code == 200):
                    rjson = resul.json()
                    self.assertTrue (
                        rjson["rows_updated"] ==1,
                        "fallo en  update_cat_Test , se esperaba que se actualizara una fila, numero de filas : "+rjson["rows_updated"]
                    )
    def delete_cat_Test(self):
        '''
        delete get un gato
        '''
        pruebas = [{"id": "1", "cod_expected" : 200}] 
        for i in pruebas:
            url =  'http://localhost:5050/v0/cat/'+i["id"]
            #resul = client.delete(url)
            req = urllib.request.Request(url=url,method='DELETE')
        with urllib.request.urlopen(req) as resul:
            self.assertEqual(resul.status,i["cod_expected"],"Codigo incorrecto en el  delete_cat_Test del gato con  id = "+i["id"]+", código "+resul.status)
            rjson = resul.read()
            s = rjson.decode('UTF-8')
            rjson = json.loads(rjson.decode('UTF-8'))   
            if(resul.status_code == 200):
                rjson = resul.json()
                self.assertTrue (
                    rjson["rows_deleted"] ==1 ,
                    "fallo en  delete_cat_Test , se esperaba que se actualizara una fila, numero de filas : "+rjson["rows_deleted"]
                )

