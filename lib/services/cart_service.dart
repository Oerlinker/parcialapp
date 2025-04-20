import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_service.dart';

class CartService {
  final ApiService _api = ApiService();

  Future<List<dynamic>> getCart() async {
    final res = await _api.get('/api/cart/');
    if (res.statusCode != 200) throw Exception('Error al obtener carrito');
    return jsonDecode(res.body) as List<dynamic>;
  }

  Future<Map<String, dynamic>> addItem(int productId, int qty) async {
    final res = await _api.post('/api/cart-items/', {
      'product': productId,
      'quantity': qty,
    });
    if (res.statusCode != 201) throw Exception('Error al añadir al carrito');
    return jsonDecode(res.body) as Map<String, dynamic>;
  }

  Future<void> removeItem(int itemId) async {
    final http.Response res = await _api.delete('/api/cart-items/$itemId/');
    if (res.statusCode != 204) {
      throw Exception('Error al eliminar del carrito');
    }
  }

  Future<void> clearCart() async {
    final http.Response res = await _api.delete('/api/cart/');
    if (res.statusCode != 204) {
      throw Exception('Error al vaciar el carrito');
    }
  }

  Future<void> updateItem(int itemId, int quantity) async {
    final res = await _api.patch(
      '/api/cart-items/$itemId/',
      body: {'quantity': quantity},
    );
    if (res.statusCode != 200 && res.statusCode != 204) {
      throw Exception('Error al actualizar el ítem');
    }
  }

  Future<void> checkout() async {
    final http.Response res = await _api.post('/api/checkout/', {});
    if (res.statusCode != 200) {
      throw Exception('Error al realizar el checkout');
    }
  }

  Future<Map<String, dynamic>> voiceToCart(String texto) async {
    final res = await _api.post('/api/voice-to-cart/', {'texto': texto});
    if (res.statusCode == 200) {
      return jsonDecode(res.body) as Map<String, dynamic>;
    } else {
      throw Exception('Error al procesar comando de voz');
    }
  }
}
