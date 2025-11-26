const API_URL = 'http://localhost:3000/api/clientes';

const form = document.getElementById('formCliente');
const tabla = document.getElementById('tablaClientes');
const btnCancelar = document.getElementById('btnCancelar');

const idInput = document.getElementById('clienteId');
const nombre = document.getElementById('nombre');
const edad = document.getElementById('edad');
const membresia = document.getElementById('membresia');

// Cargar clientes al inicio
cargarClientes();

function cargarClientes() {
  fetch(API_URL)
    .then(res => res.json())
    .then(clientes => {
      renderClientes(clientes);
      actualizarStats(clientes); // 👉 actualiza el banner lateral
    })
    .catch(err => console.error('Error al cargar clientes', err));
}

function renderClientes(lista) {
  tabla.innerHTML = '';

  lista.forEach(c => {
    const fila = document.createElement('tr');

    fila.innerHTML = `
      <td>${c.id}</td>
      <td>${c.nombre}</td>
      <td>${c.edad}</td>
      <td>${c.membresia}</td>
      <td>
        <span class="${c.activo ? 'tag-activo' : 'tag-inactivo'}">
          ${c.activo ? 'Activo' : 'Inactivo'}
        </span>
      </td>
      <td>
        <div class="table-actions">
          <button class="btn-edit" onclick="editar(${c.id})">Editar</button>
          <button class="btn-delete" onclick="eliminarCliente(${c.id})">Eliminar</button>
        </div>
      </td>
    `;

    tabla.appendChild(fila);
  });
}
function actualizarStats(lista) {
  const total = lista.length;
  const activos = lista.filter(c => c.activo).length;

  const mensual = lista.filter(c => c.membresia === 'Mensual').length;
  const trimestral = lista.filter(c => c.membresia === 'Trimestral').length;
  const anual = lista.filter(c => c.membresia === 'Anual').length;

  const porcActivos = total > 0 ? Math.round((activos / total) * 100) : 0;

  document.getElementById('statTotal').textContent = total;
  document.getElementById('statActivos').textContent = activos;
  document.getElementById('statPorcActivos').textContent = `${porcActivos}% del total`;

  document.getElementById('statMensual').textContent = mensual;
  document.getElementById('statTrimestral').textContent = trimestral;
  document.getElementById('statAnual').textContent = anual;
}


// Crear / actualizar cliente
form.addEventListener('submit', e => {
  e.preventDefault();

  const data = {
    nombre: nombre.value,
    edad: Number(edad.value),
    membresia: membresia.value,
    activo: true
  };

  const id = idInput.value;

  // Si hay id -> PUT (editar), si no -> POST (crear)
  if (id) {
    fetch(`${API_URL}/${id}`, {
      method: 'PUT',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(data)
    })
      .then(() => {
        resetForm();
        cargarClientes();
      })
      .catch(err => console.error('Error al actualizar', err));
  } else {
    fetch(API_URL, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(data)
    })
      .then(() => {
        resetForm();
        cargarClientes();
      })
      .catch(err => console.error('Error al crear', err));
  }
});

function editar(id) {
  fetch(`${API_URL}/${id}`)
    .then(res => res.json())
    .then(c => {
      idInput.value = c.id;
      nombre.value = c.nombre;
      edad.value = c.edad;
      membresia.value = c.membresia;
      btnCancelar.style.display = 'inline-block';
    })
    .catch(err => console.error('Error al obtener cliente', err));
}

function eliminarCliente(id) {
  if (!confirm('¿Seguro que deseas eliminar este cliente?')) return;

  fetch(`${API_URL}/${id}`, { method: 'DELETE' })
    .then(() => cargarClientes())
    .catch(err => console.error('Error al eliminar', err));
}

btnCancelar.addEventListener('click', resetForm);

function resetForm() {
  idInput.value = '';
  form.reset();
  btnCancelar.style.display = 'none';
}
