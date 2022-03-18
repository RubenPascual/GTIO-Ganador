from flask import Flask
from flask import Response
from flask import request
import json
import cat_utils
import os

API_VERSION = os.getenv('API_VERSION')

app = Flask(__name__)

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
    if request.is_json:
        data = request.get_json()
        result = cat_utils._create_cat(data)
        if result != -1:
            result = json.dumps(result)
            return (Response(result, status=200, mimetype='application/json'))
        else:
            return (Response(status=403, mimetype='application/json'))
    else:
        return (Response(status=403, mimetype='application/json'))

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

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0')