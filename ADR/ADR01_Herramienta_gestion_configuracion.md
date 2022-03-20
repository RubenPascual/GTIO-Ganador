# Definición de las Herramientas de Gestión de la Configuración

* Estado: aceptada
* Responsables: Mario Azcona, Stefan Donkov, Álvaro Lerga y Rubén Pascual
* Fecha: 2022-02-09

## Contexto y Planteamiento del Problema

Como equipo de desarrollo necesitamos establecer una serie de herramientas para poder realizar la gestión de la configuración y el control de versiones del proyecto. 

## Factores en la Decisión

* Facilidad de uso
* Conocimientos previos de la herramienta
* Precio bajo
* Integración con otras herramientas de gestión

## Opciones Consideradas

* Github
* Bitbucket
* Drive
* Subversion
* Perforce

## Decisión

 Opción elegida: Github, porque es una herramienta que es fácil de usar y en la que todos los integrantes tenemos experiencia, cumpliendo así los factores de decisión 1 y 2. Además, cuenta con una opción gratis cumpliendo el factor de decisión 3. Por otro lado, el hecho de que no se pueda trabajar con archivos grandes no es un problema ya que en los proyectos a realizar de desarrollo web no suelen contar con este tipo de ficheros. Finalmente, cuenta con una fácil integración con otro tipo de herramientas como IDEs (Visual estudio Code, Netbeans...), herramientas de gestión de proyectos (Trello, Kanban...), etc.

### Consecuencias

* Negativa: En el poco probable caso que debamos trabajar con ficheros grandes deberemos encontrar una alternativa e integrarla con GitHub.

## Ventajas y Desventajas de las opciones

### Github

Más información de [GitHub](https://docs.github.com/es)

* Positivo, porque todos los integrantes del equipo tienen experiencia previa con la herramienta y los conocimientos necesarios para trabajar con ella.
* Positivo, porque tiene una comunidad amplia y activa que permite encontrar ayuda fácilmente para cualquier problema.
* Positivo, porque tiene una opción de uso gratuita con una posible aumento a una versión de pago.
* Positivo, porque tiene una fácil integración con servicios de terceros.
* Negativo, porque tiene limitaciones de espacio disponible, ya que no se puede exceder el tamaño de 100MB en archivos individuales y el tamaño de 1GB para el repositorio en la versión gratis.

### Bitbucket

Más información de [BitBucket](https://bitbucket.org/product/es/guides)

* Positivo, porque todos los integrantes del equipo tienen experiencia previa con la herramienta aunque sea menor que la experiencia con Github.
* Positivo, porque tiene una opción de uso gratuita que puede pasar a una de pago si requiere más recursos.
* Positivo, porque tiene una fácil integración con servicios de terceros. En este caso más que Github ya que cuenta con el Atlassian Marketplace.
* Negativo, porque está más centrado en repositorios privados y no en repositorios publicos.
* Negativo, porque tiene una interfaz más complicada de aprender a utilizar.
* Negativo, porque tiene un límite para el número de archivos grandes que puede almacenar.


### Drive

Más información de [Drive](https://support.google.com/drive#topic=14940)

* Positivo, porque dispone de integración con herramientas de la gestión del proyecto como Trello, o Slack.
* Positivo, porque permite llevar un historial de versiones: borrar versiones anteriores, modificarlas y recuperarlas para volver a ser utilizadas.
* Positivo, porque permite modificar un documento simultaneamente a varias personas.
* Negativo, porque a diferencia de otras de las opciones requiere una suscripción mensual para emplear algunas de las funciones y una mayor cantidad de almacenamiento.
* Negativo, porque solo permite guardar versiones durante 30 dias o 100 versiones por archivo.
* Negativo, porque la velocidad de descarga es lenta.
* Negativo, porque existe riesgos potenciales en relación a la seguridad de los archivos que almecena.
* Negativo, porque no dispone de uso desde terminal de comandos y requiere subir todos los archivos a mano.
* Negativo, porque hace falta un plugin para combinar el contenido de varios ficheros.
* Negativo, porque no te permite tener un seguimiento del estado de los archivos locales con respecto a los archivos del repositorio.

### Perforce

Más información de [Perforce](https://www.perforce.com/support/self-service-resources/documentation)

* Positivo, porque permite el manejo tanto de binarios como de archivos grandes.
* Positivo, porque al estar centralizado permite asegurar que todos los usuarios tienen la última versión en todo momento.
* Negativo, porque requiere el pago de una licencia de uso.
* Negativo, porque solo un integrante tiene conocimientos previos de la herramienta.
* Negativo, porque requiere un servidor central que ha de mantenerse activo en todo momento.

### Subversion

Más información de [Subversion](https://subversion.apache.org/docs/)

* Positivo, porque permite el manejo tanto de binarios como de archivos grandes.
* Positivo, porque al estar centralizado permite asegurar que todos los usuarios tienen la última versión en todo momento.
* Positivo, porque tiene un uso más sencillo que Perforce y es muy fácil de aprender.
* Positivo, porque tiene versión gratis, aunque requiere tener un servidor.
* Negativo, porque solo un integrante tiene conocimientos previos de la herramienta.
* Negativo, porque requiere un servidor central que ha de mantenerse activo en todo momento.
* Negativo, porque al ser un sistema de un único servidor no cuenta con la misma escalabilidad y rendimiento que Perforce.