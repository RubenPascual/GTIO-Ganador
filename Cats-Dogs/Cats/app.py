from flask import Flask, Response, flash, request, redirect, url_for
import json
import cat_utils
import os
import uuid
import base64
import boto3

ALLOWED_EXTENSIONS = set(['png','jpg','jpeg'])

app = Flask(__name__)
app.config['UPLOAD_FOLDER'] = os.getenv('UPLOAD_FOLDER')

s3 = boto3.resource('s3')
bucket = s3.Bucket(os.getenv('S3_NAME'))

storage = "s3"

@app.route('/v0/')
def hello():
    response = 'This is Cats API version v0'
    return (Response(response, status=200, mimetype='application/json'))

#curl localhost:5050/cat/1
@app.route('/v0/cat/<id>', methods=['GET'])
def get_cat_by_id(id):

    data = cat_utils._get_cat_by_id(id)

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
        #Error cat <id> not in DB
        return (Response(json.dumps({"error" : "Cat {} not database".format(id)}),status=404, mimetype='application/json'))

#curl -X POST -d '{ "name": "cat", "race" : "raza"}' localhost:5050/cat -H "content-type: application/json"
@app.route('/v0/cat', methods=['POST'])
def create_cat():
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
            return (Response(json.dumps({"error" : "Internal error, try bagain later"}),status=500, mimetype='application/json'))
    result = cat_utils._create_cat(data)

    #Check the result and return response
    if result != -1:
        result = json.dumps(result)
        return (Response(result, status=200, mimetype='application/json'))
    else:
        #Error inserting cat in DB
        return (Response(json.dumps({"error" : "Internal error, try again later"}),status=500, mimetype='application/json'))


#curl -X PUT -d '{ "name": "gato0", "race": "naranja"}' localhost:5050/v0/cat/1 -H "content-type: application/json"
@app.route('/v0/cat/<id>', methods=['PUT'])
def update_cat(id):

    #######
    #TODO check if the cat exists 
    #######

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
            return (Response(json.dumps({"error" : "Internal error, try again later"}),status=500, mimetype='application/json'))

    #Retrieve the previous path and delete the file
    previous_path = cat_utils._get_cat_by_id(id)["file_path"]
    result = cat_utils._update_cat(id,data)

    if result != -1:
        delete_file(previous_path)

        #######
        #TODO check if the image was deleted successfully 
        #######
        
        result = json.dumps(result)
        return (Response(result, status=200, mimetype='application/json'))
    else:
        #Error inserting cat in DB
        delete_file(path)
        return (Response(json.dumps({"error" : "Internal error, try again later"}),status=500, mimetype='application/json'))



#curl -X DELETE localhost:5050/v0/cat/1
@app.route('/v0/cat/<id>', methods=['DELETE'])
def delete_cat(id):

    #######
    #TODO check if the cat exists 
    #######

    #Delete the data from the database and delete the file
    result, image_path = cat_utils._delete_cat(id)
    deleted = delete_file(image_path)

    #######
    #TODO check if the image was deleted successfully 
    #######

    if result != -1 and deleted != -1:
        result = json.dumps(result)
        return (Response(result, status=200, mimetype='application/json'))
    else:
        #Error deleting cat from DB
        return (Response(json.dumps({"error" : "Error deleting cat from database"}),status=500, mimetype='application/json'))

def allowed_file(filename):
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS

def upload_file(file):
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
    if file.filename == '':
        return -1
    if not allowed_file(file.filename):
        return -2

    if file:
        filename = uuid.uuid4().hex + "." + file.filename.rsplit('.', 1)[1].lower()
        bucket.Object(filename).put(Body=file)
        return filename
    else:
        return -3

def download_file(filename):
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
    file_obj = bucket.Object(filename).get()
    data = file_obj["Body"].read()
    return base64.b64encode(data).decode()

def delete_file(filename):
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