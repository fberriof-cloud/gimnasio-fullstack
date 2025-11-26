import 'package:flutter/material.dart';
import 'model/cliente.dart';
import 'services/cliente_service.dart';
  
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gimnasio - Clientes',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.greenAccent),
        useMaterial3: true,
      ),
      home: const ClientesPage(),
    );
  }
}

class ClientesPage extends StatefulWidget {
  const ClientesPage({super.key});

  @override
  State<ClientesPage> createState() => _ClientesPageState();
}

class _ClientesPageState extends State<ClientesPage> {
  final ClienteService _service = ClienteService();
  late Future<List<Cliente>> _futureClientes;

  @override
  void initState() {
    super.initState();
    _cargarClientes();
  }

  void _cargarClientes() {
    _futureClientes = _service.obtenerClientes();
  }

  Future<void> _mostrarDialogoCliente({Cliente? cliente}) async {
    final nombreCtrl = TextEditingController(text: cliente?.nombre ?? '');
    final edadCtrl = TextEditingController(
        text: cliente != null ? cliente.edad.toString() : '');
    String membresia = cliente?.membresia ?? 'Mensual';

    final esEdicion = cliente != null;

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(esEdicion ? 'Editar cliente' : 'Nuevo cliente'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nombreCtrl,
                  decoration: const InputDecoration(labelText: 'Nombre'),
                ),
                TextField(
                  controller: edadCtrl,
                  decoration: const InputDecoration(labelText: 'Edad'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: membresia,
                  decoration: const InputDecoration(labelText: 'Membresía'),
                  items: const [
                    DropdownMenuItem(
                        value: 'Mensual', child: Text('Mensual')),
                    DropdownMenuItem(
                        value: 'Trimestral', child: Text('Trimestral')),
                    DropdownMenuItem(value: 'Anual', child: Text('Anual')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      membresia = value;
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () => Navigator.pop(context),
            ),
            ElevatedButton(
              child: Text(esEdicion ? 'Guardar cambios' : 'Crear'),
              onPressed: () async {
                final nombre = nombreCtrl.text.trim();
                final edad = int.tryParse(edadCtrl.text.trim()) ?? 0;

                if (nombre.isEmpty || edad <= 0) return;

                try {
                  if (esEdicion) {
                    final actualizado = Cliente(
                      id: cliente!.id,
                      nombre: nombre,
                      edad: edad,
                      membresia: membresia,
                      activo: cliente.activo,
                    );
                    await _service.actualizarCliente(actualizado);
                  } else {
                    await _service.crearCliente(
                      nombre: nombre,
                      edad: edad,
                      membresia: membresia,
                    );
                  }

                  if (mounted) {
                    Navigator.pop(context);
                    setState(_cargarClientes);
                  }
                } catch (e) {
                  debugPrint('Error: $e');
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _eliminarCliente(int id) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Eliminar cliente'),
        content: const Text(
            '¿Seguro que deseas eliminar este cliente del gimnasio?'),
        actions: [
          TextButton(
            child: const Text('Cancelar'),
            onPressed: () => Navigator.pop(context, false),
          ),
          ElevatedButton(
            child: const Text('Eliminar'),
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );

    if (confirmar == true) {
      await _service.eliminarCliente(id);
      if (mounted) {
        setState(_cargarClientes);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clientes del Gimnasio'),
      ),
      body: FutureBuilder<List<Cliente>>(
        future: _futureClientes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          final clientes = snapshot.data ?? [];

          if (clientes.isEmpty) {
            return const Center(child: Text('No hay clientes registrados.'));
          }

          return RefreshIndicator(
            onRefresh: () async {
              setState(_cargarClientes);
            },
            child: ListView.builder(
              itemCount: clientes.length,
              itemBuilder: (context, index) {
                final c = clientes[index];
                return ListTile(
                  leading: CircleAvatar(
                    child: Text(c.nombre.isNotEmpty ? c.nombre[0] : '?'),
                  ),
                  title: Text(c.nombre),
                  subtitle: Text(
                      'Edad: ${c.edad} • Membresía: ${c.membresia} • ${c.activo ? "Activo" : "Inactivo"}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _mostrarDialogoCliente(cliente: c),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _eliminarCliente(c.id),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _mostrarDialogoCliente(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
