# Framework para desarrollar las APIs REST de Cats & Dogs

* Estado: propuesta <!-- opcional -->
* Responsables: Mario Azcona, Rubén Pascual
* Fecha: 2022-03-09

## Contexto y Planteamiento del Problema

Las APIs de las aplicaciones Cats y Dogs se van a dockerizar y se quiere acceder a ellas a través de una API. Se quiere desarrollar una API REST que permita realizar las acciones CRUD sobre las APIs. Se quiere decidir qué framework es el más adecuado para desarrollar estas APIs.

## Factores en la Decisión <!-- opcional -->

* Facilidad de uso
* Experiencia previa
* Flexibilidad

## Opciones Consideradas

* Flask
* Django

## Decisión

 Opción elegida: Flask, porque es fácil y rápido de usar, se puede adaptar fácilmente a nuestro proyecto, cuyos requisitos pueden cambiar, instalando extensiones y algunos miembros del equipo ya lo han usado

## Ventajas y Desventajas de las opciones

### Flask

* Positivo, porque es fácil y rápido de usar, especialmente haciendo prototipos
* Positivo, porque algunos miembros del equipo lo han usado previametne
* Positivo, porque se pueden instalar extensiones para adaptarlo al proyecto
* Positivo, porque se integra fácilmente con otras herramientas, como por ejemplo gestores de bases de datos
* Negativo, porque es complicado hacer migraciones y pruebas unitarias
* Negativo, porque su sistema de autenciación de usuarios es básico
* Negativo, porque es necesario usar un ORM (Object Relational Mapping)

### Django

* Positivo, porque genera una estructura y código automáticamente para poder empezar rápidamente
* Positivo, porque incluye un sistema de autenticación de usuarios y protección contra ataques comunes
* Positivo, porque incluye un sistema para gestionar bases de datos
* Positivo, porque usa un patrón MVC (Modelo Vista Controlador) que es muy flexible
* Negativo, porque puede llegar a ser complejo a la hora de haer APIs REST
* Negativo, porque su documentación es confusa
* Negativo, porque algunos miembros del equipo lo han usado previamente y su experiencia no ha sido satisfactoria

## Enlaces <!-- opcional -->

* https://flask.palletsprojects.com/en/2.0.x/
* https://www.djangoproject.com/