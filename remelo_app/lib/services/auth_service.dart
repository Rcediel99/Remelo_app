import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String baseUrl = 'http://192.168.20.93:8000/api';

  // 🔐 Iniciar sesión
  static Future<bool> login(String email, String password) async {
    try {
      final url = Uri.parse('$baseUrl/auth/user/login');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final prefs = await SharedPreferences.getInstance();

        // ✅ Intenta obtener el token bajo distintos nombres posibles
        final token = data['access_token'] ?? data['token'];

        if (token == null || token is! String || token.isEmpty) {
          print('⚠️ No se recibió un token válido desde el backend.');
          return false;
        }

        // ✅ Guardar el token en SharedPreferences
        await prefs.setString('token', token);
        print('🔐 Token guardado: $token');

        // ✅ Guardar datos del usuario si están disponibles
        final user = data['user'];
        if (user != null) {
          await prefs.setString('user_name', user['name'] ?? 'Invitado');
          await prefs.setString('user_email', user['email'] ?? '');
          await prefs.setString('user_role', user['role'] ?? 'Cliente');
        } else {
          await prefs.setString('user_name', 'Invitado');
          await prefs.setString('user_email', '');
          await prefs.setString('user_role', 'Cliente');
        }

        return true;
      } else {
        print('❌ Error en login: ${response.body}');
        return false;
      }
    } catch (e) {
      print('❌ Excepción en login: $e');
      return false;
    }
  }

  // ✏️ Actualizar perfil
  static Future<bool> actualizarPerfil(String name, String email) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      print('⚠️ No hay token guardado para actualizar perfil.');
      return false;
    }

    final response = await http.put(
      Uri.parse('$baseUrl/user/update'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'name': name, 'email': email}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      await prefs.setString('user_name', data['user']['name']);
      await prefs.setString('user_email', data['user']['email']);
      return true;
    } else {
      print('❌ Error actualizando perfil: ${response.body}');
      return false;
    }
  }

  // 📝 Registro de usuario
  static Future<bool> register({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    final url = Uri.parse('$baseUrl/auth/user/register');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
          'password_confirmation': confirmPassword,
        }),
      ).timeout(const Duration(seconds: 10)); // ⏱️ Tiempo máximo de espera

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final prefs = await SharedPreferences.getInstance();

        final token = data['access_token'] ?? data['token'];

        if (token == null || token is! String || token.isEmpty) {
          print('⚠️ No se recibió un token válido en el registro.');
          return false;
        }

        await prefs.setString('token', token);
        await prefs.setString('user_name', data['user']['name']);
        await prefs.setString('user_email', data['user']['email']);
        await prefs.setString('user_role', data['user']['role'] ?? 'Cliente');

        return true;
      } else {
        print('❌ Registro fallido: ${response.body}');
        return false;
      }
    } catch (e) {
      print('⚠️ Excepción en registro: $e');
      return false;
    }
  }
}
