import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'api_service.dart';

class AuthService {
  static const _baseUrl =
      'https://backenddjango-production-c48c.up.railway.app';
  final _storage = const FlutterSecureStorage();
  final _api = ApiService();

  Future<bool> login(String username, String password) async {
    final uri = Uri.parse('$_baseUrl/api-token-auth/');
    final res = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );
    if (res.statusCode == 200) {
      final token = jsonDecode(res.body)['token'];
      await _storage.write(key: 'auth_token', value: token);
      return true;
    }
    return false;
  }

  Future<void> logout() async {
    await _storage.delete(key: 'auth_token');
  }

  Future<String?> getToken() => _storage.read(key: 'auth_token');

  Future<Map<String, dynamic>> getUserInfo() async {
    final res = await _api.get('/api/me/');
    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    } else {
      throw Exception('Error al obtener información del usuario');
    }
  }

  Future<void> registerCliente({
    required String nombre,
    required String apellido,
    required String correo,
    required String password,
    required String passwordConfirm,
  }) async {
    final res = await _api.post('/api/register-cliente/', {
      'nombre': nombre,
      'apellido': apellido,
      'correo': correo,
      'password': password,
      'password_confirm': passwordConfirm,
    });
    if (res.statusCode != 201) {
      final body = jsonDecode(res.body);
      final msg = body['detail'] ?? body.toString();
      throw Exception(msg);
    }
  }

  Future<void> requestPasswordReset(String email) async {
    final res = await _api.post(
      '/api/password-reset/',
      {'correo': email},
    );
    if (res.statusCode != 200) {
      throw Exception('Error al solicitar restablecimiento de contraseña');
    }
  }

  Future<void> confirmPasswordReset({
    required String uid,
    required String token,
    required String newPassword,
    required String confirmPassword,
  }) async {
    final res = await _api.post('/api/reset-password-confirm/$uid/$token/', {
      'new_password': newPassword,
      'confirm_password': confirmPassword,
    });
    if (res.statusCode != 200) {
      throw Exception('Error al confirmar nueva contraseña');
    }
  }
}
