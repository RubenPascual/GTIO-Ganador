# Elección de herramientas de Integración Continua

* Estado: aceptada
* Responsables:Mario Azcona, Stefan Donkov, Álvaro Lerga y Rubén Pascual
* Fecha: 2022-02-20

Historia técnica: Story 9: COMO cliente QUIERO tener una herramienta de integración continua 

## Contexto y Planteamiento del Problema

Como equipo de desarrollo necestiamos elegir la herramienta que nos permita realizar una integración continua del código desarrollado los test y su despliegue.

## Factores en la Decisión <!-- opcional -->

* Conocimiento previo por parte de los integrantes del equipo de desarrollo
* Facilidad de uso
* Información que se obtiene de la ejecución
* 
* … <!-- el número de factores puede variar-->

## Opciones Consideradas

* Jenkins
* Gitlab
* Codeship
* Kraken CI
* Buddy

## Decisión

 Opción elegida: Hemos elegido la herramienta de Jenkins, porque varios integrantes del grupo lo conocen y han trabajado con el previamente, permite una instalación rápida y se puede realizar una integración fácil con otras herramientas que estamos empleando como github. Además se trata de una herramienta muy utilizada por lo que hay una gran comunidad que puede reseponder posibles preguntas.

### Consecuencias

* Positiva, el cononcimiento previo de la herramienta permite utilizarla de manera más eficiente durante el desarrollo del proyecto.
* Negativa, la falta de claridad en algunos de los mensajes puede complicarnos la resolución de problemas.

## Ventajas y Desventajas de las opciones

### Jenkins
Mas información de [Jenkins] (https://www.jenkins.io/)


* Positivo, porque varios integrantes ya lo conocían y habian trabajado con la herramienta previamente.
* Positivo, porque es de instalación fácil.
* Positivo, porque es fácil de debuguear y aporta mucha información sobre la ejecucción y de cada fase.
* Positivo, porque es de código libre y existe una gran comunidad de usuarios.
* Positivo, porque dispone de una fácil integración con el repositorio.
* Positivo, porque se puede  ustilizar de forma gratuita.
* Negativo, porque la interfaz de usuario en ocasiones no es clara y menos intuitiva que otras herramientas..
* Negativo, porque falta de claridad en alguno de los mensajes.
* Negativo, porque hay que mantener la infrastructura.
* Negativo, porque no dispone de soporte oficial.

### Gitlab

Mas información de [Gitlab] (https://docs.gitlab.com/ee/ci/)


* Positivo, porque ofrece un plan gratuito.
* Positivo, porque permite establecer horarios de despliegue. 
* Positivo, porque es facil de configurar.
* Negativo, porque no había sido utilizado por ningún miembro del equipo para la integración continua.
* Negativo, porque no ofrece tanta información de la ejecución como otras alternativas.



### CodeShip
Mas información de [CodeShip] (https://docs.cloudbees.com/docs/cloudbees-codeship/latest/)

* Positivo, porque avisa de fallos en los test durante los despliegues.
* Positivo, porque permite integración cono github y bitbucket.
* Negativo, porque no era conocido por los integrantes del equipo lo que implicaría estudio de la heramienta.
* Negativo, porque en ocasiones muestra falsos positivos en los test. 
* Negativo, porque suele ralentizarse si existe demasiada exigencia como durante la ejecucción despliegues en paraleo.



###
Mas información de [Buddy] (https://buddy.works/)

* Positivo, se pueden realizar un despliegue de forma más rápida que en las herramientas anteriores.
* Positivo, porque dispone de tutoriales y facilidades para comenzar a utilizarlo.
* Negativo, porque las opciones gratuitas que ofrece son escasas.