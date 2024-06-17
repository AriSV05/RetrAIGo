## Integrantes:
Nicole Araya Ballestero | Esteban Mojica Gonzalez | Daniel Ramirez Calvo | Ariana Solano Vallejos 
##
RetroAIGo - 2024
UNA

# Resumen
Esto es un juego de un puzzle de 8 piezas, se tienen 6 estados iniciales previamente cargados, cada uno de estos estados jugara hasta llegar al estado final [empty, 1, 2], [3, 4, 5], [6, 7, 8].
Para esto, se utilizaron los algoritmo distancias Manhattan y Hamming, junto con el algoritmo Counting inversions.

# Descarga

Se descarga la aplicación del drive del profesor en formato zip

## Instalación

Una vez descargado el zip se descomprime

Abrimos el CMD en donde se hizo la debida descompresión del proyecto

Entramos en la carpeta del proyecto con el comando

```
cd EIF420O-I-2024-RetrAIGo-NicoleArayaBallestero-04-01pm
```

Seguidamente se deben instalar todas las dependencias que necesita el sitio web para funcionar.
Desde la carpeta web_page, instalaremos las dependencias:

```
cd web_page
npm i
```
o
```
cd web_page
yarn add
```

Para ejecutar el sitio web utilizaremos el siguiente comando:

```
npm start
```

Y ejecutar el servidor prolog de RetroAIGo, en otra CMD, nos dirigimos a la carpeta prolog y ejecutamos el servidor:

```
cd ..
cd prolog/servidor
swipl
[http_server].
```