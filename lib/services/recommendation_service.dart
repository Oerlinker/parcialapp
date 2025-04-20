import 'dart:convert';
import 'package:parcialapp/services/api_service.dart';
import '../models/product.dart';

class RecommendationService {
  final ApiService _api = ApiService();

  Future<List<Product>> fetchRecommendations() async {
    final res = await _api.get('/api/products/recommendations/');
    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body);
      return data.map((e) => Product.fromJson(e)).toList();
    } else {
      throw Exception('Error al cargar recomendaciones');
    }
  }
}
