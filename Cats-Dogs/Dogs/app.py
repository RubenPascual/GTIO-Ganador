from flask import Flask
from flask import Response
from flask import request
import json
import dog_utils
import os

API_VERSION = os.getenv("API_VERSION")

app = Flask(__name__)

@app.route('/{}/'.format(API_VERSION))
def hello():
    return "This is Dogs API version {API_VERSION}"

#curl localhost:5050/dog/1
@app.route('/{}/dog/<id>'.format(API_VERSION), methods=['GET'])
def get_dog_by_id(id):
    data = dog_utils._get_dog_by_id(id)
    if data is not None:
        data = json.dumps(data)
        return (Response(data, status=200, mimetype='application/json'))
    else:
        return (Response(status=403, mimetype='application/json'))

#curl -X POST -d '{ "name": "dog"}' localhost:5050/dog -H "content-type: application/json"
@app.route('/{}/dog'.format(API_VERSION), methods=['POST'])
def create_dog():
    if request.is_json:
        data = request.get_json()
        result = dog_utils._create_dog(data)
        if result != -1:
            result = json.dumps(result)
            return (Response(result, status=200, mimetype='application/json'))
        else:
            return (Response(status=403, mimetype='application/json'))
    else:
        return (Response(status=403, mimetype='application/json'))

@app.route('/{}/dog/<id>'.format(API_VERSION), methods=['PUT'])
def update_dog(id):
    if request.is_json:
        data = request.get_json()
        result = dog_utils._update_dog(id,data)
        if result != -1:
            return (Response(result, status=200, mimetype='application/json'))
        else:
            return (Response(status=403, mimetype='application/json'))
    else:
        return (Response(status=403, mimetype='application/json'))

@app.route('/{}/dog/<id>'.format(API_VERSION), methods=['DELETE'])
def delete_dog(id):

    result = dog_utils._delete_dog(id)

    if result != -1:
        return (Response(result, status=200, mimetype='application/json'))
    else:
        return (Response(status=403, mimetype='application/json'))

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0')