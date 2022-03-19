from flask import Flask, Response, flash, request, redirect, url_for
import json
import cat_utils
import os
import uuid

API_VERSION = os.getenv('API_VERSION')
ALLOWED_EXTENSIONS = set(['png', 'jpg', 'jpeg'])

app = Flask(__name__)
app.config['UPLOAD_FOLDER'] = os.getenv('UPLOAD_FOLDER')

@app.route('/{}/'.format(API_VERSION))
def hello():
    return 'This is Cats API version {}'.format(API_VERSION)

#curl localhost:5050/cat/1
@app.route('/{}/cat/<id>'.format(API_VERSION), methods=['GET'])
def get_cat_by_id(id):
    data = cat_utils._get_cat_by_id(id)
    if data is not None:
        data = json.dumps(data)
        return (Response(data, status=200, mimetype='application/json'))
    else:
        return (Response(status=403, mimetype='application/json'))

#curl -X POST -d '{ "name": "cat", "race" : "raza"}' localhost:5050/cat -H "content-type: application/json"
@app.route('/{}/cat'.format(API_VERSION), methods=['POST'])
def create_cat():
    name = request.form.get("name")
    race = request.form.get("race")

    data = "{\"name\" : \"" + name + "\", \"race\": \"" + race + "\"}"
    data = json.loads(data)
    path = upload_file()

    if path != -1 and path != -2:
        data["path"] = path
    else:
        return (Response(status=401, mimetype='application/json'))

    result = cat_utils._create_cat(data)
    if result != -1:
        result = json.dumps(result)
        return (Response(result, status=200, mimetype='application/json'))
    else:
        return (Response(status=402, mimetype='application/json'))


#curl -X PUT -d '{ "name": "gato0", "race": "naranja"}' localhost:5050/v0/cat/1 -H "content-type: application/json"
@app.route('/{}/cat/<id>'.format(API_VERSION), methods=['PUT'])
def update_cat(id):
    if request.is_json:
        data = request.get_json()
        result = cat_utils._update_cat(id,data)
        if result != -1:
            result = json.dumps(result)
            return (Response(result, status=200, mimetype='application/json'))
        else:
            return (Response(status=403, mimetype='application/json'))
    else:
        return (Response(status=403, mimetype='application/json'))


#curl -X DELETE localhost:5050/v0/cat/1
@app.route('/{}/cat/<id>'.format(API_VERSION), methods=['DELETE'])
def delete_cat(id):
    result = cat_utils._delete_cat(id)

    if result != -1:
        result = json.dumps(result)
        return (Response(result, status=200, mimetype='application/json'))
    else:
        return (Response(status=403, mimetype='application/json'))

def allowed_file(filename):
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS

def upload_file():
    # check if the post request has the file part
    if 'file' not in request.files:
        flash('No file part')
        return -1
    file = request.files['file']
    # if user does not select file, browser also
    # submit an empty part without filename
    if file.filename == '':
        flash('No selected file')
        return -2
    if file and allowed_file(file.filename):
        filename = uuid.uuid4().hex + "." + file.filename.rsplit('.', 1)[1].lower()
        file.save(os.path.join(app.config['UPLOAD_FOLDER'], filename))
        return filename


if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0')