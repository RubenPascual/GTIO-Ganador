# Delete dog

Removes the Dog with the given id

**URL** : `/v0/dog/<id>`

**Method** : `DELETE`

**Auth required** : YES

**Permissions required** : User must be in Dog or CatDog group

**Data constraints** : id must be a positive integer

## Success Responses

**Condition** : Dog deleted

**Code** : `200 OK`

**Content** : The number of dogs deleted is returned. If succesfull, this number is always 1:

```json
[
    {
        "Rows deleted": "<number>"
    }
]
```

## Error Responses

**Condition** : Internal error deleting the dog 

**Code** : `500 INTERNAL SERVER ERROR`

**Content** :

```json
[
    {
        "error": "Internal error, try again later"
    }
]
````