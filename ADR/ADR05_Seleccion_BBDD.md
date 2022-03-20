# Eleccion de base de datos para Cats&Dogs

* Estado: aceptada
* Responsables: Rubén Pascual Casas
* Fecha: 14-03-2022


## Contexto y Planteamiento del Problema

Como equipo de desarrollo necesitamos establecer la base de datos que queremos utilizar en los contenedores para almacenar la información de Gatos y Perror

## Factores en la Decisión 

* Compatibilidad con otras herramientas a utilizar
* Rendimiento
* Conocimiento previo

## Opciones Consideradas

* MySQL
* PostgreSQL
* Sqlite

## Decisión

 Opción elegida: PostgreSQL, porque es la opción con mejor rendimiento cumpliendo el factor de decisión 2, otras herramientas hacen uso de ella y además tienen compatibilidad cumpliendo el factor de decisión 1. Por último, cumple el factor de decisión 3 ya que al menos un integrante tiene conocimiento previo.

## Ventajas y Desventajas de las opciones

### MySQL

Más información de [MySQL](https://www.mysql.com/)

* Positivo, porque todos los integrantes tienen experiencia con la herramienta
* Negativo, porque el rendimiento es menor que otras opciones
* Negativo, porque ninguna herramienta hace uso directo de MySQL

### PostgreSQL

Más información de [PostgreSQL](https://www.postgresql.org/)

* Positivo, porque la herramienta que queremos utilizar para la API Gateway (KONG) hace uso de esta base de datos
* Positivo, porque tiene mayor rendimiento que las otras opciones
* Negativo, porque solo un integrante tiene experiencia previa con la herremienta

### Sqlite

Más información de [Sqlite](https://www.sqlite.org/index.html)

* Positivo, porque todos los integrantes tienen experiencia con la herramienta
* Negativo, porque el rendimiento es menor que otras opciones
* Negativo, porque ninguna herramienta hace uso directo de Sqlite