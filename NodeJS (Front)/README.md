# Forma de uso
1. Descargar el directorio `NodeJS (Front)`
## Para abrir el archivo y editar
2. Abrir el directorio en algún editor de código
## Para ejecutar
2. Copia la dirección del proyecto (E.g. `C:\...\NodeJS (Front)`)
3. En una terminal, ejecuta el comando `npm run dev`

# Sistema de Gestión de Inventario

Este proyecto consiste en el desarrollo de un sistema web orientado a la gestión y control de inventario.  
La aplicación permite administrar productos, marcas, categorías y unidades de medida de manera sencilla, buscando mejorar el control de la información y facilitar las operaciones dentro del sistema.

El proyecto fue desarrollado utilizando una arquitectura separada entre frontend y backend, permitiendo una mejor organización del código y una comunicación mediante API REST.

---

# Tecnologías utilizadas

## Frontend

El frontend fue desarrollado utilizando:

- React
- Vite
- JavaScript
- CSS
- Axios

Herramientas utilizadas:

- Visual Studio Code
- Node.js

---

## Backend

El backend fue desarrollado utilizando:

- Java SDK 25
- Spring Boot

Herramientas utilizadas:

- IntelliJ IDEA

---

# Estructura del proyecto

```txt
src/
 ├── components/
 ├── pages/
 ├── services/
 ├── assets/
 └── App.jsx
````

---

# Descripción de carpetas y archivos

## App.jsx

Archivo principal de la aplicación.
Se encarga de renderizar las rutas, componentes principales y la estructura general del sistema.

---

## components

Esta carpeta contiene componentes reutilizables utilizados en distintas partes del sistema.

### Navbar.jsx

Componente encargado de mostrar la barra de navegación principal del sistema y permitir el acceso a las diferentes páginas.

---

## pages

En esta carpeta se encuentran las vistas principales del sistema.

### Inicio.jsx

Página principal mostrada al iniciar el sistema.

### Producto.jsx

Vista encargada de la gestión de productos.
Permite registrar, editar, listar y cambiar el estado de los productos existentes.

### Marca.jsx

Página destinada a la administración de marcas de productos.

### Categoria.jsx

Vista utilizada para gestionar las categorías de los productos registrados en el sistema.

### UnidadDeMedida.jsx

Página encargada de administrar las unidades de medida utilizadas por los productos.

---

## services

Contiene los archivos encargados de realizar las peticiones HTTP hacia el backend mediante la API REST.

### api.js

Archivo principal de configuración de Axios.
Define la URL base utilizada para las conexiones con el backend.

### productoService.js

Contiene las funciones relacionadas con las operaciones de productos, como listar, registrar, editar y actualizar estados.

### marcaService.js

Maneja las operaciones relacionadas con las marcas.

### categoriaService.js

Realiza las peticiones correspondientes a las categorías.

### unidadDeMedidaService.js

Gestiona las operaciones relacionadas con las unidades de medida.

### selectorService.js

Archivo utilizado para obtener información auxiliar utilizada en selectores o listas desplegables dentro del sistema.

---

# Funcionamiento general del sistema

El usuario interactúa desde la interfaz desarrollada en React.
Las acciones realizadas son enviadas al backend mediante peticiones HTTP, donde se procesan las operaciones correspondientes y posteriormente se devuelve la información al frontend.

La comunicación entre frontend y backend se realiza mediante API REST, permitiendo enviar y recibir información desde la base de datos de forma dinámica.

---

# Funcionalidades principales

El sistema cuenta con las siguientes funcionalidades:

* Registro de productos
* Edición de información
* Eliminación lógica de registros
* Gestión de marcas
* Gestión de categorías
* Gestión de unidades de medida
* Consumo de API REST
* Interfaz dinámica desarrollada con React

---

# Comunicación con el backend

El frontend se conecta con el backend mediante peticiones HTTP realizadas desde los archivos ubicados en:

```txt
src/services
```

La API trabaja localmente utilizando una dirección similar a:

```txt
http://localhost:8080/api
```


# Objetivo del proyecto

El propósito principal de este sistema es mejorar el control de inventario y facilitar la administración de la información mediante una aplicación web moderna, organizada y fácil de utilizar.


# Conclusión

El desarrollo del proyecto permitió aplicar conocimientos de desarrollo frontend y backend, así como el consumo de APIs y la organización modular del código utilizando tecnologías modernas.

