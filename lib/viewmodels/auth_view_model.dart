import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  UserModel? _user;
  String? _errorMessage;

  UserModel? get user => _user;
  String? get errorMessage => _errorMessage;

  // Registrar usuario
  Future<void> signUp(String email, String password) async {
    _user = await _authService.signUp(email, password);
    if (_user == null) {
      _errorMessage = 'Error al registrarse. Inténtalo de nuevo.';
      notifyListeners();
    } else {
      _errorMessage = null;
      notifyListeners();
    }
  }

  // Iniciar sesión
  Future<void> signIn(String email, String password) async {
    _user = await _authService.signIn(email, password);
    if (_user == null) {
      _errorMessage = 'Error al iniciar sesión. Inténtalo de nuevo.';
      notifyListeners();
    } else {
      _errorMessage = null;
      notifyListeners();
    }
  }

  // Cerrar sesión
  Future<void> signOut() async {
    await _authService.signOut();
    _user = null;
    notifyListeners();
  }

  // Obtener usuario actual
  void getCurrentUser() {
    _user = _authService.getCurrentUser();
    notifyListeners();
  }
}
