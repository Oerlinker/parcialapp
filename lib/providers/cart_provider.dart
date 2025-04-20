import 'package:flutter/material.dart';
import 'package:parcialapp/services/api_service.dart';
import '../models/cart_item.dart';
import '../models/product.dart';
import '../services/cart_service.dart';
import '../services/product_service.dart';
import 'dart:convert';

final CartService _cartService = CartService();

class CartProvider extends ChangeNotifier {
  String lastAddedItems = '';
  bool loadingVoice = false;

  final _service = CartService();
  final ApiService _apiService = ApiService();
  final List<CartItem> _items = [];
  bool _loading = false;
  String? _error;

  List<CartItem> get items => List.unmodifiable(_items);

  bool get loading => _loading;

  String? get error => _error;

  double get total => _items.fold(0, (sum, i) => sum + i.subtotal);

  Future<void> loadCart() async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final data = await _service.getCart();
      _items.clear();

      if (data.isNotEmpty) {
        final List items = data[0]['items'];
        final productService = ProductService();

        for (var item in items) {
          final int productId = item['product'];
          final product = await productService.fetchById(productId);

          _items.add(
            CartItem(
              id: item['id'],
              product: product,
              quantity: item['quantity'],
            ),
          );
        }
      }
    } catch (e) {
      _error = e.toString();
    }

    _loading = false;
    notifyListeners();
  }

  Future<void> addProduct(Product p) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final newItemJson = await _service.addItem(p.id, 1);

      _items.add(
        CartItem(
          id: newItemJson['id'],
          product: p,
          quantity: newItemJson['quantity'],
        ),
      );
    } catch (e) {
      _error = e.toString();
    }

    _loading = false;
    notifyListeners();
  }

  Future<void> increaseQuantity(int itemId) async {
    try {
      final item = _items.firstWhere((e) => e.id == itemId);
      final newQuantity = item.quantity + 1;
      await _cartService.updateItem(itemId, newQuantity);
      item.quantity = newQuantity;
      notifyListeners();
    } catch (e) {
      _error = 'Error al aumentar cantidad';
      notifyListeners();
    }
  }

  Future<void> decreaseQuantity(int itemId) async {
    try {
      final item = _items.firstWhere((e) => e.id == itemId);
      if (item.quantity > 1) {
        final newQuantity = item.quantity - 1;
        await _cartService.updateItem(itemId, newQuantity);
        item.quantity = newQuantity;
        notifyListeners();
      } else {
        await removeItem(itemId);
      }
    } catch (e) {
      _error = 'Error al disminuir cantidad';
      notifyListeners();
    }
  }

  Future<void> removeItem(int itemId) async {
    try {
      await _cartService.removeItem(itemId);
      _items.removeWhere((e) => e.id == itemId);

      notifyListeners();
    } catch (e) {
      _error = 'Error al eliminar del carrito';
      notifyListeners();
    }
  }

  Future<void> processVoiceCommand(String texto) async {
    loadingVoice = true;
    notifyListeners();

    final data = await _service.voiceToCart(texto);
    lastAddedItems = (data['added_items'] as List)
        .map((e) => '${e['quantity']}× ${e['product']}')
        .join(', ');

    await loadCart();

    loadingVoice = false;
    notifyListeners();
  }
}
