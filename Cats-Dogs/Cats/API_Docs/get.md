# Read cat

Get information of a Cat with a given id

**URL** : `/v0/cat/<id>`

**Method** : `GET`

**Auth required** : YES

**Permissions required** : User must be in Cat or CatDog group

**Data constraints** : id must be a positive integer

## Success Responses

**Condition** : Cat found

**Code** : `200 OK`

**Content** : The cat information is returned. The image is returned as a string of the binary information codified as Base64:

```json
[
    {
        "name": "CatName",
        "race": "CatRace",
        "image": "imageData"
    }
]
```

## Error Responses

**Condition** : Cat with given id does not exist 

**Code** : `404 NOT FOUND`

**Content** : 
```json
[
    {
        "error": "Cat <id> not database"
    }
]
````