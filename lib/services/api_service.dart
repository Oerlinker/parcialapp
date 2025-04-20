import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  static const _baseUrl = 'https://backenddjango-production-c48c.up.railway.app';
  final _storage = const FlutterSecureStorage();

  Future<Map<String, String>> _headers() async {
    final token = await _storage.read(key: 'auth_token');
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Token $token',
    };
  }


  Future<http.Response> get(String path) async {
    final uri = Uri.parse('$_baseUrl$path');
    final headers = await _headers();
    return http.get(uri, headers: headers);
  }


  Future<http.Response> post(String path, Map<String, dynamic> body) async {
    final uri = Uri.parse('$_baseUrl$path');
    final headers = await _headers();
    return http.post(
      uri,
      headers: headers,
      body: jsonEncode(body),
    );
  }
  Future<http.Response> delete(String path) async {
    final uri = Uri.parse('$_baseUrl$path');
    final headers = await _headers();
    return http.delete(uri, headers: headers);
  }

  Future<http.Response> patch(String path, {Map<String, dynamic>? body}) async {
    final uri = Uri.parse('$_baseUrl$path');
    final headers = await _headers();
    return http.patch(
      uri,
      headers: headers,
      body: body != null ? jsonEncode(body) : null,
    );
  }
}
