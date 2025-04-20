import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/recommendation_service.dart';

class RecommendationProvider extends ChangeNotifier {
  final _service = RecommendationService();
  List<Product> _items = [];
  bool _loading = false;
  String? _error;

  List<Product> get items   => _items;
  bool         get loading => _loading;
  String?      get error   => _error;

  Future<void> loadRecommendations() async {
    _loading = true;
    _error   = null;
    notifyListeners();

    try {
      _items = await _service.fetchRecommendations();
    } catch (e) {
      _error = e.toString();
    }

    _loading = false;
    notifyListeners();
  }
}
