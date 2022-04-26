# test_with_unittest.py
import unittest
import requests
import base64
import json
import os
import json
# importing sys
import sys
import time
import errno

class DOGS_CRUD(unittest.TestCase):

    def test_read_dog_Test(self):
        '''
        Test leer un perro
        '''
        try:
            with open(os.path.dirname(os.path.abspath(__file__))+'images/test_dog.png','rb') as img:
                url1 = 'http://localhost:5051/v0/dog'
                payload={'name': 'perro',
                        'race' : 'raza'}
                files=[
                ('file',('test_dog.png',img,'image/png'))
                ]
                time.sleep(0.01)
                resul = requests.request("POST", url1, data=payload, files=files)
                rjson = resul.json()
            pruebas = [{"id": str(rjson["dog_id"]), "cod_expected" : 200},
                    {"id": "-1", "cod_expected" : 404},
                    {"id": "1000", "cod_expected" : 404}
            ]
            for i in pruebas:
                url = 'http://localhost:5051/v0/dog/' + i["id"]
                time.sleep(0.01)
                resul = requests.request("GET", url)
                self.assertEqual(resul.status_code,i["cod_expected"])         
                if (resul.status_code == 200):
                    rjson =  resul.json()
                    self.assertTrue (
                        rjson["image"] != None and rjson["name"] != None and rjson["race"] != None ,
                        "fallo en  create_cat_Test , se esperaba que el contenido no estuviera vacio\n valor de la image: "+rjson["image"]+"\nValor de name: "+rjson["name"]+"\nValor de raza: "+ rjson["race"]
                    )
        except IOError as e:
            if e.errno == errno.EPIPE:
                pass
    def test_create_dog_Test(self):

       ##Creación de un perro correcta 
        """
        Test de creación de perro
        """
        try:
            url = 'http://localhost:5051/v0/dog'
            pruebas = [{"file": "test_dog.png" , "cod_expected" : 200},
                {"file": "" , "cod_expected" : 400},
                {"file": "test_dog.pgr" , "cod_expected" : 400}
            ]
            for i in pruebas:
                payload={'name': 'perro',
                        'race': 'raza'
                }
                with open(os.path.dirname(os.path.abspath(__file__))+'images/test_dog.png','rb') as img:
                    files=[
                    ('file',(i["file"],img,'image/png'))
                    ]
                    time.sleep(0.01)
                    resul = requests.request("POST", url, data=payload, files=files)  
                    self.assertEqual(resul.status_code,i["cod_expected"])      
                    if (resul.status_code == 200):
                        rjson =  resul.json()
                        self.assertTrue (
                            rjson["dog_id"] >=0 ,
                            "fallo en  create_cat_Test , se esperaba que fuera positivo y tiene valor : "+ str(rjson["dog_id"])
                            )
        except IOError as e:
            if e.errno == errno.EPIPE:
                pass
    def test_update_dog_Test(self):
        '''
        test update un perro
        '''
        try:
            with open(os.path.dirname(os.path.abspath(__file__))+'images/test_dog.png','rb') as img:
                url1 = 'http://localhost:5051/v0/dog'
                payload={'name': 'perro',
                        'race' : 'raza'}
                files=[
                ('file',('test_dog.png',img,'image/png'))
                ]
                time.sleep(0.01)
                resul = requests.request("POST", url1, data=payload, files=files)
                rjson = resul.json()
            pruebas = [{"id": str(rjson["dog_id"]), "cod_expected" : 200},
                    {"id": "-1", "cod_expected" : 404},
                    {"id": "1000", "cod_expected" : 404}
            ]
            for i in pruebas:
                url = 'http://localhost:5051/v0/dog'+i["id"]
                payload ={
                    'name': 'perro', 
                    'race' : 'raza',
                    'file' :os.path.dirname(os.path.abspath(__file__))+'images/test_dog.png'
                }
                time.sleep(0.01)
                resul = requests.put(url, data=payload) 
                if(resul.status_code == 200):
                    rjson = resul.json()
                    self.assertTrue (
                        rjson["rows_updated"] ==1,
                        "fallo en  update_cat_Test , se esperaba que se actualizara una fila, numero de filas : "+rjson["rows_updated"]
                    )
        
        except IOError as e:
            if e.errno == errno.EPIPE:
                pass

    def test_delete_dog_Test(self):
        '''
        borrar un perro
        '''
        try:
            with open(os.path.dirname(os.path.abspath(__file__))+'images/test_dog.png','rb') as img:
                url1 = 'http://localhost:5051/v0/dog'
                payload={'name': 'perro',
                        'race' : 'raza'}
                files=[
                ('file',('test_dog.png',img,'image/png'))
                ]
                time.sleep(0.01)
                resul = requests.request("POST", url1, data=payload, files=files)
                rjson = resul.json()
            pruebas = [{"id": str(rjson["dog_id"]), "cod_expected" : 200},
                    {"id": "-1", "cod_expected" : 500},
                    {"id": "1000", "cod_expected" : 500}
            ]
            for i in pruebas:

                url =  'http://localhost:5051/v0/dog/'+i["id"]
                time.sleep(0.01)
                resul = requests.request("DELETE", url)
                self.assertEqual(resul.status_code,i["cod_expected"],"Codigo incorrecto en el  delete_cat_Test del perro con  id = "+i["id"]+", código "+ str(resul.status_code))
                if(resul.status_code == 200):
                    rjson = resul.json()

                    self.assertTrue (
                        rjson["Rows deleted"] ==1 ,
                        "fallo en  delete_cat_Test , se esperaba que se actualizara una fila, numero de filas : " +  str(rjson["Rows deleted"])
                    )
        except IOError as e:
            if e.errno == errno.EPIPE:
                pass



