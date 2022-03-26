# Delete cat

Removes the Cat with the given id

**URL** : `/v0/cat/<id>`

**Method** : `DELETE`

**Auth required** : YES

**Permissions required** : User must be in Cat or CatDog group

**Data constraints** : id must be a positive integer

## Success Responses

**Condition** : Cat deleted

**Code** : `200 OK`

**Content** : The number of cats deleted is returned. If succesfull, this number is always 1:

```json
[
    {
        "Rows deleted": "<number>"
    }
]
```

## Error Responses

**Condition** : Internal error deleting the cat 

**Code** : `500 INTERNAL SERVER ERROR`

**Content** :

```json
[
    {
        "error": "Internal error, try again later"
    }
]
````