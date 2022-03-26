# Create cat

Insert a new cat in the database

**URL** : `/v0/cat`

**Method** : `POST`

**Auth required** : YES

**Permissions required** : User must be in Cat or CatDog group

**Data constraints** : Provide a name, a race and an image. The image must be in png format.

```json
[
    {
        "name": "[string]",
        "race": "[string]",
        "image": "[png file]"
    }
]
```

## Success Responses

**Condition** : Cat created successfully

**Code** : `200 OK`

**Content** : The id of ther new cat is returned. The id is a positive integer:

```json
[
    {
        "cat_id": "<id>"
    }
]
```

## Error Responses

**Condition** : Request does not have a file 

**Code** : `400 BAD REQUEST`

**Content** : 

```json
[
    {
        "error": "Request must contain a file"
    }
]
````

### OR

**Condition** : Fileformat provided not supported 

**Code** : `400 BAD REQUEST`

**Content** :

```json
[
    {
        "error": "File format not supported"
    }
]
````

### OR

**Condition** : Internal error creting the cat 

**Code** : `500 INTERNAL SERVER ERROR`

**Content** :

```json
[
    {
        "error": "Internal error, try again later"
    }
]
````