import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final _service = AuthService();
  bool _authenticated = false;

  bool get isAuthenticated => _authenticated;

  bool _loading = false;

  bool get loading => _loading;

  String? _infoMessage;

  String? get infoMessage => _infoMessage;

  String? _token;

  String? get token => _token;

  String? _error;

  String? get error => _error;

  Map<String, dynamic>? _userData;

  Map<String, dynamic>? get userData => _userData;

  Future<bool> login(String u, String p) async {
    try {
      _loading = true;
      _error = null;
      notifyListeners();

      final ok = await _service.login(u, p);
      if (ok) {
        _authenticated = true;
        _userData = await _service.getUserInfo();
        _loading = false;
        notifyListeners();
        return true;
      } else {
        _error = 'Credenciales incorrectas';
        _loading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = e.toString();
      _loading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await _service.logout();
    _authenticated = false;
    _userData = null;
    notifyListeners();
  }

  Future<bool> register({
    required String nombre,
    required String apellido,
    required String correo,
    required String password,
    required String passwordConfirm,
  }) async {
    try {
      _loading = true;
      _error = null;
      notifyListeners();
      await _service.registerCliente(
        nombre: nombre,
        apellido: apellido,
        correo: correo,
        password: password,
        passwordConfirm: passwordConfirm,
      );
      _loading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _loading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> requestPasswordReset(String email) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      await _service.requestPasswordReset(email);
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }


  Future<bool> confirmPasswordReset({
    required String uid,
    required String token,
    required String newPassword,
    required String confirmPassword,
  }) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      await _service.confirmPasswordReset(
        uid: uid,
        token: token,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      );
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
  Future<void> checkAuthStatus() async {
    final token = await _service.getToken();


    _authenticated = token != null;

    if (token != null) {
      try {
        _userData = await _service.getUserInfo();
      } catch (e) {

      }
    } else {
      _userData = null;
    }

    notifyListeners();
  }
}
