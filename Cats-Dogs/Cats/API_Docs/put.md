# Update cat

Update information of a Cat with a given id

**URL** : `/v0/cat/<id>`

**Method** : `PUT`

**Auth required** : YES

**Permissions required** : User must be in Cat or CatDog group

**Data constraints** : id must be a positive integer. The request must provide a name, a race and an image. The image must be in png format.

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

**Condition** : Cat updated successfully

**Code** : `200 OK`

**Content** : The number of cats updated is returned. If succesfull, this number is always 1:

```json
[
    {
        "Rows updated": "<number>"
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

**Condition** : Internal error updating the cat 

**Code** : `500 INTERNAL SERVER ERROR`

**Content** :

```json
[
    {
        "error": "Internal error, try again later"
    }
]
````