# AirCheck Galicia

AirCheck Galicia es una aplicación Flutter desarrollada para la práctica TR5 de Desarrollo de Interfaces. La aplicación permite consultar la calidad del aire en varias ciudades de Galicia y generar un informe PDF con los datos actuales de una ciudad seleccionada.

## Enfoque de la aplicación

La aplicación está pensada para una persona que practica deporte al aire libre y quiere saber rápidamente si el aire está en condiciones adecuadas para salir a correr o hacer ciclismo.

La pantalla principal muestra una ciudad favorita y una comparativa entre varias ciudades gallegas. Desde esa pantalla se puede acceder al detalle de cada ciudad, consultar los principales contaminantes y generar un informe PDF.

## Arquitectura MVVM

El proyecto sigue una estructura MVVM separando responsabilidades:

- `models/`: contiene las clases de datos `City` y `AirReading`.
- `data/air_api.dart`: realiza las peticiones HTTP a Open-Meteo.
- `data/air_repository.dart`: combina la búsqueda de ciudad con los datos de calidad del aire.
- `viewmodels/air_vm.dart`: gestiona el estado de la aplicación, la ciudad seleccionada, la ciudad favorita, los estados de carga/error y la lógica de recomendación deportiva.
- `views/`: contiene las pantallas principales de la aplicación.
- `widgets/`: contiene las gráficas hechas con `fl_chart`.
- `services/pdf_service.dart`: genera el informe PDF usando `pdf`.

Las vistas no llaman directamente a la API. Observan el `AirVm` mediante `provider`, y el ViewModel usa el repositorio para obtener los datos.

## Fuente de datos

La aplicación utiliza la API pública de Open-Meteo:

- Geocoding API: búsqueda de ciudades y obtención de coordenadas.
- Air Quality API: consulta de datos actuales de calidad del aire.

Documentación oficial:

- https://open-meteo.com/en/docs/geocoding-api
- https://open-meteo.com/en/docs/air-quality-api

## Ciudades consultadas

La aplicación consulta varias ciudades gallegas:

- A Coruña
- Santiago de Compostela
- Vigo
- Ourense
- Lugo
- Ferrol
- Pontevedra

## Datos mostrados

Para cada ciudad se manejan los siguientes datos:

- AQI europeo
- PM10
- PM2.5
- Dióxido de nitrógeno NO2
- Ozono O3
- Dióxido de azufre SO2
- Monóxido de carbono CO

## Lógica de recomendación deportiva

La aplicación muestra un bloque llamado “¿Salgo a hacer deporte al aire libre?” basado en el índice europeo de calidad del aire:

- Si AQI <= 40: “Sí, adelante”.
- Si 40 < AQI <= 80: “Con moderación”.
- Si AQI > 80: “Mejor hoy no”.

Esta lógica es sencilla y sirve para transformar el dato técnico en una recomendación rápida para el usuario.

## Gráficas utilizadas

### Gráfica de barras

La gráfica de barras compara el valor `european_aqi` entre las ciudades consultadas.

Esta gráfica permite decidir rápidamente en qué ciudad hay mejor calidad del aire. Cuanto menor es el AQI, mejor es la calidad del aire.

### Gráfica circular

La gráfica circular muestra el peso relativo de los contaminantes principales en la ciudad seleccionada:

- PM10
- PM2.5
- NO2
- O3

Esta gráfica permite ver qué contaminante predomina en una ciudad concreta.

## Exportación PDF

Desde la pantalla de detalle se puede generar un informe PDF de la ciudad seleccionada.

El PDF incluye:

- Título del informe.
- Nombre de la ciudad.
- País y coordenadas.
- Fecha y hora de actualización de los datos.
- Fecha y hora de generación del informe.
- Tabla con los siete parámetros de calidad del aire.
- Veredicto deportivo.
- Fuente de datos: Open-Meteo Air Quality API.

## Dependencias usadas

Las dependencias principales del proyecto son:

- `http`: peticiones HTTP a la API.
- `provider`: gestión de estado con ChangeNotifier.
- `fl_chart`: gráficas de barras y circular.
- `pdf`: generación del informe PDF.
- `printing`: previsualización e impresión del PDF.

## Capturas

### Pantalla principal

Pendiente de añadir captura.

### Pantalla de detalle

Pendiente de añadir captura.

### PDF generado

Pendiente de añadir captura.

## PDF de ejemplo

En la carpeta `docs/` se incluye un PDF de ejemplo generado desde la aplicación.