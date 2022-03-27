# Eleccion de API Gateway

* Estado: propuesta
* Responsables: Mario Azcona, Stefan Donkov, Álvaro Lerga y Rubén Pascual
* Fecha: 2022-02-09

## Contexto y Planteamiento del Problema

Como equipo de desarrollo necestiamos elgir la herramienta de gestión de tráfico de peticiones de la que vamos a hacer uso.

## Factores en la Decisión <!-- opcional -->

* Facilidad de uso
* Precio bajo
* Facilidad de configuración

## Opciones Consideradas

* Kong
* WSO2
* TYK
* KrakenD

## Decisión

 Opción elegida: Kong, porque es de forma gratuita nos ofrece las funcionalidades que necesitamos mediante una facil instalación, ademas de permitirnos una configuración
 sencilla mediante la interfaz grafica, de terceros, Konga, que se puede instalar.

## Ventajas y Desventajas de las opciones

### Kong

Más información de [Kong](https://konghq.com/kong/)

* Positivo, porque es muy sencillo de instalar mediante docker.
* Positivo, porque ofrece analiticas.
* Positivo, porque ofrece autenticación.
* Positivo, porque hay un amplio repertorio de plugins para aumentar la funcionalidad.
* Negativo, porque no ofrece una interfaz gráfica por defecto.


### WSO2

Más información de [WSO2](https://wso2.com/api-manager/)

* Positivo, porque ofrece analiticas.
* Positivo, porque ofrece autenticación.
* Positivo, porque ofrece control de versiones.
* Negativo, porque es de pago


### TYK

Más información de [TYK](https://tyk.io/)

* Positivo, porque ofrece analiticas.
* Positivo, porque ofrece autenticación.
* Positivo, porque permite falsear APIs y peticiones a ellas.
* Positivo, porque permite establecer cuotas y limitar la velocidad.
* Positivo, porque ofrece control de versiones.
* Negativo, porque muchas caracteristicas que facilitan su uso, y otras muchas funcionalidades no son gratuitas.


### KrakenD

Más información de [KrakenD](https://www.krakend.io/)

* Positivo, porque ofrece mucha velocidad de tratamineto de peticiones.
* Positivo, porque ofrece analiticas.
* Positivo, porque ofrece autenticación.
* Negativo, porque no ofrece una interfaz gráfica
