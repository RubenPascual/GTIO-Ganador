from flask import Flask
from flask import Response
from flask import request
import json
import cat_utils

app = Flask(__name__)


@app.route('/')
def hello():
    return "This is Cats API!"

#curl localhost:5050/cat/1
@app.route('/cat/<id>', methods=['GET'])
def get_cat_by_id(id):
    success, data = cat_utils._get_cat_by_id(id)
    data = json.dumps(data)
    if success != -1:
        return (Response(data, status=200, mimetype='application/json'))
    else:
        return (Response(status=403, mimetype='application/json'))

#curl -X POST -d '{ "name": "cat"}' localhost:5050/cat -H "content-type: application/json"
@app.route('/cat', methods=['POST'])
def create_cat():
    if request.is_json:
        data = request.get_json()
        result = cat_utils._create_cat(data)
        if result != -1:
            return (Response(result, status=200, mimetype='application/json'))
        else:
            return (Response(status=403, mimetype='application/json'))
    else:
        return (Response(status=403, mimetype='application/json'))

@app.route('/cat/<id>', methods=['PUT'])
def update_cat(id):
    if request.is_json:
        data = request.get_json()
        result = cat_utils._update_cat(id,data)
        if result != -1:
            return (Response(result, status=200, mimetype='application/json'))
        else:
            return (Response(status=403, mimetype='application/json'))
    else:
        return (Response(status=403, mimetype='application/json'))

@app.route('/cat/<id>', methods=['DELETE'])
def delete_cat(id):

    result = cat_utils._delete_cat(id)

    if result != -1:
        return (Response(result, status=200, mimetype='application/json'))
    else:
        return (Response(status=403, mimetype='application/json'))

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0')