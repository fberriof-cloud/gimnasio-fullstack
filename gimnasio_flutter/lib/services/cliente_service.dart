import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/cliente.dart';


// ⚠️ Ajusta esta URL según DÓNDE ejecutes Flutter:
// - Flutter Web o Windows en el mismo PC: 'http://localhost:3000'
// - Emulador Android: 'http://10.0.2.2:3000'
const String baseUrl = 'http://localhost:3000';

class ClienteService {
  final String _endpoint = '$baseUrl/api/clientes';

  Future<List<Cliente>> obtenerClientes() async {
    final response = await http.get(Uri.parse(_endpoint));

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => Cliente.fromJson(e)).toList();
    } else {
      throw Exception('Error al cargar clientes');
    }
  }

  Future<Cliente> crearCliente({
    required String nombre,
    required int edad,
    required String membresia,
  }) async {
    final response = await http.post(
      Uri.parse(_endpoint),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nombre': nombre,
        'edad': edad,
        'membresia': membresia,
        'activo': true,
      }),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return Cliente.fromJson(data);
    } else {
      throw Exception('Error al crear cliente');
    }
  }

  Future<Cliente> actualizarCliente(Cliente cliente) async {
    final url = '$_endpoint/${cliente.id}';

    final response = await http.put(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nombre': cliente.nombre,
        'edad': cliente.edad,
        'membresia': cliente.membresia,
        'activo': cliente.activo,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Cliente.fromJson(data);
    } else {
      throw Exception('Error al actualizar cliente');
    }
  }

  Future<void> eliminarCliente(int id) async {
    final url = '$_endpoint/$id';

    final response = await http.delete(Uri.parse(url));

    if (response.statusCode != 200) {
      throw Exception('Error al eliminar cliente');
    }
  }
}
