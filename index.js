// index.js
const express = require('express');
const cors = require('cors');

const app = express();
const PORT = 3000;

// Middlewares
app.use(cors());
app.use(express.json()); // Para leer JSON en las peticiones
app.use(express.static('public'));
// "Base de datos" en memoria
// Entidad: clientes del gimnasio
let clientes = [
  { id: 1, nombre: 'Juan Pérez', edad: 28, membresia: 'Mensual', activo: true },
  { id: 2, nombre: 'Ana Gómez', edad: 32, membresia: 'Anual', activo: true }
];

let nextId = 3;

// Ruta de prueba
app.get('/', (req, res) => {
  res.send('API Gimnasio funcionando 💪');
});

/* ========== CRUD CLIENTES ========== */

// GET - Todos los clientes
app.get('/api/clientes', (req, res) => {
  res.json(clientes);
});

// GET - Cliente por ID
app.get('/api/clientes/:id', (req, res) => {
  const id = parseInt(req.params.id);
  const cliente = clientes.find(c => c.id === id);

  if (!cliente) {
    return res.status(404).json({ mensaje: 'Cliente no encontrado' });
  }

  res.json(cliente);
});

// POST - Crear cliente
app.post('/api/clientes', (req, res) => {
  const { nombre, edad, membresia, activo } = req.body;

  if (!nombre || !edad || !membresia) {
    return res.status(400).json({ mensaje: 'Nombre, edad y membresía son obligatorios' });
  }

  const nuevo = {
    id: nextId++,
    nombre,
    edad,
    membresia,
    activo: activo ?? true
  };

  clientes.push(nuevo);
  res.status(201).json(nuevo);
});

// PUT - Actualizar cliente
app.put('/api/clientes/:id', (req, res) => {
  const id = parseInt(req.params.id);
  const index = clientes.findIndex(c => c.id === id);

  if (index === -1) {
    return res.status(404).json({ mensaje: 'Cliente no encontrado' });
  }

  const { nombre, edad, membresia, activo } = req.body;

  clientes[index] = {
    ...clientes[index],
    nombre: nombre ?? clientes[index].nombre,
    edad: edad ?? clientes[index].edad,
    membresia: membresia ?? clientes[index].membresia,
    activo: activo ?? clientes[index].activo
  };

  res.json(clientes[index]);
});

// DELETE - Eliminar cliente
app.delete('/api/clientes/:id', (req, res) => {
  const id = parseInt(req.params.id);
  const index = clientes.findIndex(c => c.id === id);

  if (index === -1) {
    return res.status(404).json({ mensaje: 'Cliente no encontrado' });
  }

  const eliminado = clientes[index];
  clientes.splice(index, 1);

  res.json({ mensaje: 'Cliente eliminado', cliente: eliminado });
});

// Iniciar servidor
app.listen(PORT, () => {
  console.log(`Servidor API Gimnasio escuchando en http://localhost:${PORT}`);
});
