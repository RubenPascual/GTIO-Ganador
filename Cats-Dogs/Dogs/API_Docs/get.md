# Read dog

Get information of a Dog with a given id

**URL** : `/v0/dog/<id>`

**Method** : `GET`

**Auth required** : YES

**Permissions required** : User must be in Dog or CatDog group

**Data constraints** : id must be a positive integer

## Success Responses

**Condition** : Dog found

**Code** : `200 OK`

**Content** : The dog information is returned. The image is returned as a string of the binary information codified as Base64:

```json
[
    {
        "name": "DogName",
        "race": "DogRace",
        "image": "imageData"
    }
]
```

## Error Responses

**Condition** : Dog with given id does not exist 

**Code** : `404 NOT FOUND`

**Content** : 
```json
[
    {
        "error": "Dog <id> not database"
    }
]
````