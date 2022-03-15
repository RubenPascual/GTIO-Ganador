from flask import Flask
from flask import Response
from flask import request
import json

app = Flask(__name__)


@app.route('/')
def hello():
    return "This is Cats API!"
    
#curl localhost:5050/cat/1
@app.route('/cat/<id>', methods=['GET'])
def get_cat_by_id(id):
    # get cat info  
    cat = _get_cat_by_id(id)
    return (Response(json.dumps(cat), status=200, mimetype='application/json'))

def _get_cat_by_id(cat_id):
    name = "Cat " + cat_id
    data = {"name" : name}
    return data

#curl -X POST -d '{ "name": "cat"}' localhost:5050/cat -H "content-type: application/json"
@app.route('/cat', methods=['POST'])
def create_cat():
    if request.is_json:
        data = request.get_json()
        # create new cat
        return (Response(status=200, mimetype='application/json'))
    else:
        return (Response(status=403, mimetype='application/json'))

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0')