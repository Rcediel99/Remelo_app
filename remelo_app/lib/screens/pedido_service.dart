import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PedidoService {
  static const String baseUrl = 'http://192.168.20.93:8000/api'; // reemplaza TU_IP

  static Future<List<Map<String, dynamic>>> obtenerPedidos() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('$baseUrl/orders/user'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      print('Error al obtener pedidos: ${response.body}');
      throw Exception('No se pudieron cargar los pedidos');
    }
  }
}
