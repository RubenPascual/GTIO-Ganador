# Update dog

Update information of a Dog with a given id

**URL** : `/v0/dog/<id>`

**Method** : `PUT`

**Auth required** : YES

**Permissions required** : User must be in Dog or CatDog group

**Data constraints** : id must be a positive integer. The request must provide a name, a race and an image. The image must be in png format. The request must be a form with the following fields:

- name: string
- race: string
- image: png file

## Success Responses

**Condition** : Dog updated successfully

**Code** : `200 OK`

**Content** : The number of dogs updated is returned. If succesfull, this number is always 1:

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

**Condition** : Internal error updating the dog 

**Code** : `500 INTERNAL SERVER ERROR`

**Content** :

```json
[
    {
        "error": "Internal error, try again later"
    }
]
````