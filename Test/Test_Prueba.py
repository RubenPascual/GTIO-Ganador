# test_with_unittest.py
import unittest
from flask import Flask,request,Response
import requests
import base64
import json
import os
import urllib
import json

from poster3.encode import multipart_encode
from poster3.streaminghttp import register_openers
# importing sys
import sys


import requests
  
# adding Folder_2 to the system path
#sys.path.insert(0, '/home/alumno/Escritorio/Cats&Dogs/GTIO-Ganador/Cats-Dogs/Cats')
#import app as appc
#appc.app.config.update({
#    "TESTING": True,
#})
#ALLOWED_EXTENSIONS = set(["png"])
#app = Flask(__name__)
#app.testing = True
#app.config["UPLOAD_FOLDER"] = os.getenv("UPLOAD_FOLDER")
#client = appc.app.test_client()

# create a password manager
#password_mgr = urllib.request.HTTPPasswordMgrWithDefaultRealm()

# Add the username and password.
# If we knew the realm, we could use it instead of None.
#top_level_url = "http://localhost:8000/cat/"
#username = 'cat'
#password = 'cat'
#password_mgr.add_password(None, top_level_url, username, password)

#handler = urllib.request.HTTPBasicAuthHandler(password_mgr)

# create "opener" (OpenerDirector instance)
#opener = urllib.request.build_opener(handler)

# use the opener to fetch a URL
#opener.open("http://localhost:8000/cat/")

# Install the opener.
# Now all calls to urllib.request.urlopen use our opener.
#urllib.request.install_opener(opener)

register_openers()

class TestSum(unittest.TestCase):
    def test_read_cat_Test(self):
        pruebas = [{"id": "1", "cod_expected" : 200}] 
        for i in pruebas:
            url =  'http://localhost:5050/v0/cat/'+i["id"]
            url2 =  'http://localhost:8000/cat/v0/'+i["id"]

            req = urllib.request.Request(url=url, method ='GET')
            username ='cat'
            password ='cat'
            s = '%s:%s' % (username,password)
            print(url)
           # base64string = base64.b64encode(s.encode("utf-8"))
          #  base64string = base64.b64encode(s.encode("utf-8"))
           # req.add_header("Authorization", "Basic %s" % base64string)   
          #  resul = urllib.request.urlopen(req)
           # print(url)
          #  print(url2)
           # resul = client.get(url)
          #  print(resul.status_code)
           # resul2 = client.get(url2,auth =('cat','cat'))

            with urllib.request.urlopen(req) as resul:
                self.assertEqual(resul.status,i["cod_expected"],"El resultado de read_cat_Test para id = "+i["id"])
                rjson = resul.read()
                s = rjson.decode('UTF-8')
                rjson = json.loads(rjson.decode('UTF-8'))               
                print(resul.status)
                if (resul.status == 200):
                    self.assertTrue (
                        rjson["image"] != None and rjson["name"] != None and rjson["race"] != None ,
                        "fallo en  create_cat_Test , se esperaba que el contenido no estuviera vacio\n valor de la image: "+rjson["image"]+"\nValor de name: "+rjson["name"]+"\nValor de raza: "+ rjson["race"]
                    )

    def test_create_cat_Test(self):

       ##Creación de un gato correcta 
        """
        Test de creación de gato
        """

        url = 'http://localhost:5050/v0/cat'
        datagen, headers =  multipart_encode({
                'name': 'cat', 
                'race' : 'raza',
                'file' : '/home/alumno/Escritorio/Cats&Dogs/GTIO-Ganador/Test/images/test_cat.png'
        })
        print(json.dumps(payload).encode('UTF-8'))
        req = urllib.request.Request(url=url,data =datagen,method='POST')
       # req.add_header('Content-Type', 'application/json')
        # resul = urllib.request.urlopen(req) 
        with urllib.request.urlopen(req) as resul:
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
