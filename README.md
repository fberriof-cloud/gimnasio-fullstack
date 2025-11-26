# 🏋️‍♂️ Gimnasio Fullstack  
**Aplicación completa para gestión de clientes de un gimnasio**  
Incluye:  
✔ API REST construida con **Node.js + Express**  
✔ Aplicación Frontend en **Flutter Web**  
✔ CRUD completo (Crear, Leer, Actualizar, Eliminar)

---

## 🚀 1. Descripción del Proyecto

Este proyecto es un sistema fullstack para administrar los clientes de un gimnasio.  
Permite:

- Registrar clientes  
- Editarlos  
- Eliminarlos  
- Listarlos desde una API REST  
- Visualización en una app Flutter Web con interfaz limpia y moderna  

---

## 📦 2. Tecnologías Utilizadas

### 🖥 Backend (API REST)
- Node.js  
- Express  
- Cors  
- Body-parser  
- Nodemon  

### 💻 Frontend (App Web)
- Flutter 3.x  
- Dart  

### 🔧 Herramientas
- Visual Studio Code  
- Git & GitHub  
- Postman (para pruebas de API)

---

## 🗂 3. Estructura del Proyecto

<img width="448" height="801" alt="image" src="https://github.com/user-attachments/assets/7174c9f2-80e3-4747-8bac-328c5ec78315" />

---

# 🛠 4. Instalación y Configuración

## 📌 A. API Node.js

---
### 5. Instalar dependencias
bash
cd api-gimnasio
npm install

---

### 6.Ejecutar la API
npm start

---

### 7.La API correra en:
http://localhost:3000/api/clientes

--- 

### 8.Endpoints disponibles

### 9.Método	Ruta	Descripción
- GET	/api/clientes	Obtiene todos los clientes
- POST	/api/clientes	Crea un cliente
- PUT	/api/clientes/:id	Actualiza un cliente
- DELETE	/api/clientes/:id	Elimina un cliente

---

### 10. Aplicacion Flutter

## 11. Intalar las dependencias
- cd gimnasio_flutter
flutter pub get

## 12. Ejecutar MODO WEB
- flutter run -d edge

## O si tienes Chrome
- flutter run -d chrome

## 13. Conexión entre Flutter y la API

# En cliente_service.dart se configura la URL:

- const String baseUrl = 'http://localhost:3000';


