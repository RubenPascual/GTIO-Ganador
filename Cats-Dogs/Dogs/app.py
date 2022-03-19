from flask import Flask, Response, flash, request, redirect, url_for
import json
import dog_utils
import os
import uuid
import base64

API_VERSION = os.getenv('API_VERSION')
ALLOWED_EXTENSIONS = set(['png'])

app = Flask(__name__)
app.config['UPLOAD_FOLDER'] = os.getenv('UPLOAD_FOLDER')

@app.route('/{}/'.format(API_VERSION))
def hello():
    return 'This is Dogs API version {}'.format(API_VERSION)

#curl localhost:5050/dog/1
@app.route('/{}/dog/<id>'.format(API_VERSION), methods=['GET'])
def get_dog_by_id(id):

    data = dog_utils._get_dog_by_id(id)

    #Check if the returned data is valid
    if data is not None:
        #Get the image as binary encoded in base64
        image_path = data["file_path"]
        image = download_file(image_path)

        #######
        #TODO check if the image is correct, exists, etc 
        #######

        #Return the data
        response = {"name" : data["name"], "race" : data["race"], "image" : image}
        response = json.dumps(response)
        return (Response(response, status=200, mimetype='application/json'))
    else:
        return (Response(status=403, mimetype='application/json'))

#curl -X POST -d '{ "name": "dog", "race" : "raza"}' localhost:5050/dog -H "content-type: application/json"
@app.route('/{}/dog'.format(API_VERSION), methods=['POST'])
def create_dog():
    #Extract data from the request
    name = request.form.get("name")
    race = request.form.get("race")

    #Check if the request has the file
    if 'file' not in request.files:
        return (Response(status=403, mimetype='application/json'))
    file = request.files['file']

    #Upload the image and retrieve the path
    path = upload_file(file)

    #Check if the file was upladed succesfully and insert the data in the DB
    data = "{\"name\" : \"" + name + "\", \"race\": \"" + race + "\"}"
    data = json.loads(data)
    if path != -1 and path != -2:
        data["path"] = path
    else:
        return (Response(status=403, mimetype='application/json'))
    result = dog_utils._create_dog(data)

    #Check the result and return response
    if result != -1:
        result = json.dumps(result)
        return (Response(result, status=200, mimetype='application/json'))
    else:
        return (Response(status=403, mimetype='application/json'))


#curl -X PUT -d '{ "name": "perro0", "race": "naranja"}' localhost:5050/v0/dog/1 -H "content-type: application/json"
@app.route('/{}/dog/<id>'.format(API_VERSION), methods=['PUT'])
def update_dog(id):
    #Extract data from the request
    name = request.form.get("name")
    race = request.form.get("race")

    #Check if the request has the file
    if 'file' not in request.files:
        return (Response(status=403, mimetype='application/json'))
    file = request.files['file']

    #Upload the new image and retrieve the path
    path = upload_file(file)

    #Check if the file was upladed succesfully and update the data
    data = "{\"name\" : \"" + name + "\", \"race\": \"" + race + "\"}"
    data = json.loads(data)
    if path != -1 and path != -2:
        data["path"] = path
    else:
        return (Response(status=403, mimetype='application/json'))

    #Retrieve the previous path and delete the file
    previous_path = dog_utils._get_dog_by_id(id)["file_path"]
    delete_file(previous_path)
    result = dog_utils._update_dog(id,data)

    #######
    #TODO check if the image was deleted successfully 
    #######

    if result != -1:
        result = json.dumps(result)
        return (Response(result, status=200, mimetype='application/json'))
    else:
        return (Response(status=403, mimetype='application/json'))



#curl -X DELETE localhost:5050/v0/dog/1
@app.route('/{}/dog/<id>'.format(API_VERSION), methods=['DELETE'])
def delete_dog(id):
    #Delete the data from the database and delete the file
    result, image_path = dog_utils._delete_dog(id)
    deleted = delete_file(image_path)

    #######
    #TODO check if the image was deleted successfully 
    #######

    if result != -1 and deleted != -1:
        result = json.dumps(result)
        return (Response(result, status=200, mimetype='application/json'))
    else:
        return (Response(status=403, mimetype='application/json'))

def allowed_file(filename):
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS

def upload_file(file):
    # if user does not select file, the browser submits an empty file without filename
    if file.filename == '':
        return -1

    #Check file format and upload
    if file and allowed_file(file.filename):
        filename = uuid.uuid4().hex + "." + file.filename.rsplit('.', 1)[1].lower()
        file.save(os.path.join(app.config['UPLOAD_FOLDER'], filename))
        return filename

def download_file(filename):
    #Read file as binary and encode
    path = os.path.join(app.config['UPLOAD_FOLDER'], filename)
    file = open(path, 'rb')
    data = file.read()
    return base64.b64encode(data).decode()

def delete_file(filename):
    path = os.path.join(app.config['UPLOAD_FOLDER'], filename)
    os.remove(path)
    return 1

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0')