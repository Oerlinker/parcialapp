import 'dart:convert';
import '../services/api_service.dart';
import 'package:url_launcher/url_launcher.dart';

class PaymentService {
  final ApiService _api = ApiService();

  Future<String> createCheckoutSession() async {
    final res = await _api.post('/api/checkout/', {});
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      return data['checkout_url'];
    } else {
      throw Exception('Error creando sesión de pago');
    }
  }
}
