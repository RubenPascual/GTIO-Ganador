# test_with_unittest.py
import unittest
import requests
import base64
import json
import os
import json
# importing sys
import sys
import errno
  



class CATS_CRUD(unittest.TestCase):
    
    def test_read_cat_Test(self):
        try:
            with open(os.path.dirname(os.path.abspath(__file__))+'images/test_cat.png','rb') as img:
                url1 = 'http://localhost:5050/v0/cat'
                payload={'name': 'gato',
                        'race' : 'raza'}
                files=[
                ('file',('test_cat.png',img,'image/png'))
                ]
                resul = requests.request("POST", url1, data=payload, files=files)
                rjson = resul.json()
            pruebas = [{"id": str(rjson["cat_id"]), "cod_expected" : 200},
                    {"id": "-1", "cod_expected" : 404},
                    {"id": "1000", "cod_expected" : 404}
            ]
            for i in pruebas:
                url = "http://localhost:5050/v0/cat/" + i["id"]
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
    def test_create_cat_Test(self):
    ##Creación de un gato correcta 
        """
        Test de creación de gato
        """
        try:
            url = 'http://localhost:5050/v0/cat'
            pruebas = [{"file": "test_cat.png" , "cod_expected" : 200},
                {"file": "" , "cod_expected" : 400},
                {"file": "test_cat.pgr" , "cod_expected" : 400}
            ]
            for i in pruebas:
                payload={'name': 'gato',
                        'race': 'raza'
                }
                with open(os.path.dirname(os.path.abspath(__file__))+'images/test_cat.png','rb') as img:
                    files=[
                    ('file',(i["file"],'','image/png'))
                    ]

                    resul = requests.request("POST", url, data=payload, files=files)  
                    self.assertEqual(resul.status_code,i["cod_expected"])      
                    if (resul.status_code == 200):
                        rjson =  resul.json()
                        print(rjson)
                        self.assertTrue (
                            rjson["cat_id"] >=0 ,
                            "fallo en  create_cat_Test , se esperaba que fuera positivo y tiene valor : "+ str(rjson["cat_id"])
                            )
        except IOError as e:
            if e.errno == errno.EPIPE:
                pass

    def test_update_cat_Test(self):
        '''
        test update un gato
        '''
        try:

            with open(os.path.dirname(os.path.abspath(__file__))+'images/test_cat.png','rb') as img:
                url1 = 'http://localhost:5050/v0/cat'
                payload={'name': 'gato',
                        'race' : 'raza'}
                files=[
                ('file',('test_cat.png',img,'image/png'))
                ]

                resul = requests.request("POST", url1, data=payload, files=files)
                rjson = resul.json()
            pruebas = [{"id": str(rjson["cat_id"]), "cod_expected" : 200},
                    {"id": "-1", "cod_expected" : 404},
                    {"id": "1000", "cod_expected" : 404}
            ]
            for i in pruebas:
                url = 'http://localhost:5050/v0/cat/'+i["id"]
                payload ={
                    'name': 'cat', 
                    'race' : 'raza',
                    'file' : os.path.dirname(os.path.abspath(__file__))+'images/test_cat.png'
                }  
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


    def test_delete_cat_Test(self):
        '''
        delete get un gato
        '''
        try:
            with open(os.path.dirname(os.path.abspath(__file__))+'images/test_cat.png','rb') as img:
                url1 = 'http://localhost:5050/v0/cat'
                payload={'name': 'gato',
                        'race' : 'raza'}
                files=[
                ('file',('test_cat.png',img,'image/png'))
                ]

                resul = requests.request("POST", url1, data=payload, files=files)
                rjson = resul.json()
            pruebas = [{"id": str(rjson["cat_id"]), "cod_expected" : 200},
                    {"id": "-1", "cod_expected" : 500},
                    {"id": "1000", "cod_expected" : 500}
            ]
            for i in pruebas:
                url =  'http://localhost:5050/v0/cat/'+i["id"]
                resul = requests.request("DELETE", url)
                self.assertEqual(resul.status_code,i["cod_expected"],"Codigo incorrecto en el  delete_cat_Test del gato con  id = "+i["id"]+", código "+ str(resul.status_code))
                if(resul.status_code == 200):
                    rjson = resul.json()
                    print(rjson)
                    self.assertTrue (
                        rjson["Rows deleted"] ==1 ,
                        "fallo en  delete_cat_Test , se esperaba que se actualizara una fila, numero de filas : " +  str(rjson["Rows deleted"])
                    )
                    print(rjson["Rows deleted"])
        except IOError as e:
            if e.errno == errno.EPIPE:
                pass



