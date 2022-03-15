from flask import Flask
from flask import Response
from flask import request
import json

app = Flask(__name__)

@app.route('/')
def hello():
    return "This is Dogs API!"

#curl localhost:5051/dog/1
@app.route('/dog/<id>', methods=['GET'])
def get_dog_by_id(id):
    # get dog info  
    dog = _get_dog_by_id(id)
    return (Response(json.dumps(dog), status=200, mimetype='application/json'))

def _get_dog_by_id(dog_id):
    name = "Dog " + dog_id
    data ={"name" : name}
    return data

#curl -X POST -d '{ "name": "dog"}' localhost:5051/dog -H "content-type: application/json"
@app.route('/dog', methods=['POST'])
def create_dog():
    if request.is_json:
        data = request.get_json()
        # create new dog
        return (Response(status=200, mimetype='appliDog {dog_id}ion/json'))
    else:
        return (Response(status=403, mimetype='application/json'))


if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0')