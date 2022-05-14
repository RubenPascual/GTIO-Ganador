from flask import Flask, Response, flash, request, redirect, url_for
import json
import dog_utils
import os
import uuid
import base64
import boto3

ALLOWED_EXTENSIONS = set(['png','jpg','jpeg'])

app = Flask(__name__)
app.config['UPLOAD_FOLDER'] = os.getenv('UPLOAD_FOLDER')

s3 = boto3.resource('s3')
bucket = s3.Bucket(os.getenv('S3_NAME'))

@app.route('/v0/')
def hello():
    return 'This is Dogs API version v0'

#curl localhost:5050/dog/1
@app.route('/v0/dog/<id>', methods=['GET'])
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
        #Error dog <id> not in DB
        return (Response(json.dumps({"error" : "Dog {} not database".format(id)}),status=404, mimetype='application/json'))

#curl -X POST -d '{ "name": "dog", "race" : "raza"}' localhost:5050/dog -H "content-type: application/json"
@app.route('/v0/dog', methods=['POST'])
def create_dog():
    #Extract data from the request
    name = request.form.get("name")
    race = request.form.get("race")

    #Check if the request has the file
    if 'file' not in request.files:
        #Error the request must have a file
        return (Response(json.dumps({"error" : "Request must contain a file"}),status=400, mimetype='application/json'))
    file = request.files['file']

    #Upload the image and retrieve the path
    path = upload_file(file)

    #Check if the file was upladed succesfully and insert the data in the DB
    data = "{\"name\" : \"" + name + "\", \"race\": \"" + race + "\"}"
    data = json.loads(data)
    if path != -1 and path != -2 and path != -3:
        data["path"] = path
    else:
        #Error uploading file
        if path == -1:
            return (Response(json.dumps({"error" : "Request must contain a file"}),status=400, mimetype='application/json'))
        elif path == -2:
            return (Response(json.dumps({"error" : "File format not supported"}),status=400, mimetype='application/json'))
        elif path == -3:
            return (Response(json.dumps({"error" : "Unexpected error"}),status=500, mimetype='application/json'))
    result = dog_utils._create_dog(data)

    #Check the result and return response
    if result != -1:
        result = json.dumps(result)
        return (Response(result, status=200, mimetype='application/json'))
    else:
        #Error inserting dog in DB
        return (Response(json.dumps({"error" : "Error inserting dog in database"}),status=500, mimetype='application/json'))


#curl -X PUT -d '{ "name": "gato0", "race": "naranja"}' localhost:5050/v0/dog/1 -H "content-type: application/json"
@app.route('/v0/dog/<id>', methods=['PUT'])
def update_dog(id):
    #Extract data from the request
    name = request.form.get("name")
    race = request.form.get("race")

    #Check if the request has the file
    if 'file' not in request.files:
        #Error the request must have a file
        return (Response(json.dumps({"error" : "Request must contain a file"}),status=400, mimetype='application/json'))
    file = request.files['file']

    #Upload the new image and retrieve the path
    path = upload_file(file)

    #Check if the file was upladed succesfully and update the data
    data = "{\"name\" : \"" + name + "\", \"race\": \"" + race + "\"}"
    data = json.loads(data)
    if path != -1 and path != -2 and path != -3:
        data["path"] = path
    else:
        #Error uploading file
        if path == -1:
            return (Response(json.dumps({"error" : "Request must contain a file"}),status=400, mimetype='application/json'))
        elif path == -2:
            return (Response(json.dumps({"error" : "File format not supported"}),status=400, mimetype='application/json'))
        elif path == -3:
            return (Response(json.dumps({"error" : "Unexpected error"}),status=500, mimetype='application/json'))

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
        #Error inserting dog in DB
        return (Response(json.dumps({"error" : "Error inserting dog in database"}),status=500, mimetype='application/json'))



#curl -X DELETE localhost:5050/v0/dog/1
@app.route('/v0/dog/<id>', methods=['DELETE'])
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
        #Error inserting dog in DB
        return (Response(json.dumps({"error" : "Error inserting dog in database"}),status=500, mimetype='application/json'))

def allowed_file(filename):
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS

def upload_file(file,storage="s3"):
    if storage == "local":
        return _upload_file_local(file)
    if storage == "s3":
        return _upload_file_s3(file)
def _upload_file_local(file):
    # if user does not select file, the browser submits an empty file without filename
    if file.filename == '':
        return -1

    if not allowed_file(file.filename):
        return -2

    #Check file format and upload
    if file:
        filename = uuid.uuid4().hex + "." + file.filename.rsplit('.', 1)[1].lower()
        file.save(os.path.join(app.config['UPLOAD_FOLDER'], filename))
        return filename
    else:
        return -3
def _upload_file_s3(file):
    ##########################################
    # TODO wait for the image to upload???   #
    ##########################################

    #Upload file temporarily to local storage
    filename = upload_file(file)
    if filename != -1 or filename != -2 or filename != -3:
        #Upload file to S3 and delete temporal file
        bucket.upload_file(os.path.join(app.config['UPLOAD_FOLDER'], filename),filename)
        _delete_file_local(filename)
    else:
        return filename

def download_file(filename,storage="s3"):
    if storage == "local":
        return _download_file_local(filename)
    if storage == "s3":
        return _download_file_s3(filename)
def _download_file_local(filename):
    #Read file as binary and encode
    path = os.path.join(app.config['UPLOAD_FOLDER'], filename)
    file = open(path, 'rb')
    data = file.read()
    return base64.b64encode(data).decode()
def _download_file_s3(filename):

    ############################################
    # TODO wait for the image to download???   #
    ############################################

    #Download temporarily the file to local storage
    bucket.download_file(filename, os.path.join(app.config['UPLOAD_FOLDER'], filename))
    #Get local file data and delete temporal file
    data = _download_file_local(filename)
    _delete_file_local(filename)
    return data

def delete_file(filename,storage="s3"):
    if storage == "local":
        return _delete_file_local(filename)
    if storage == "s3":
        return _delete_file_s3(filename)
def _delete_file_local(filename):
    path = os.path.join(app.config['UPLOAD_FOLDER'], filename)
    os.remove(path)
    return 1
def _delete_file_s3(filename):
    bucket.Object(filename).delete()
    return 1

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0')