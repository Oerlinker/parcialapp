import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_service.dart';
import '../models/product.dart';

class ProductService {
  final _api = ApiService();

  Future<List<Product>> fetchProducts() async {
    final res = await _api.get('/api/products/');
    if (res.statusCode == 200) {
      final body = utf8.decode(res.bodyBytes);
      final List<dynamic> data = jsonDecode(body);
      return data.map((e) => Product.fromJson(e)).toList();
    } else {
      throw Exception('Error al cargar productos: ${res.statusCode}');
    }
  }
  Future<Product> fetchById(int id) async {
    final res = await _api.get('/api/products/$id/');
    if (res.statusCode == 200) {
      final body = utf8.decode(res.bodyBytes);
      final data = jsonDecode(body);
      return Product.fromJson(data);
    } else {
      throw Exception('Error al obtener producto $id');
    }
  }
}