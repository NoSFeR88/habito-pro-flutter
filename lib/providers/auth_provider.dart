import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  
  User? _user;
  bool _isLoading = false;
  String _errorMessage = '';
  Map<String, dynamic>? _userData;

  User? get user => _user;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  bool get isSignedIn => _user != null;
  bool get isAnonymous => _user?.isAnonymous ?? false;
  Map<String, dynamic>? get userData => _userData;

  AuthProvider() {
    _initializeAuth();
  }

  void _initializeAuth() {
    _authService.authStateChanges.listen((User? user) {
      _user = user;
      if (user != null) {
        _loadUserData();
      } else {
        _userData = null;
      }
      notifyListeners();
    });
  }

  // Cargar datos del usuario desde Firestore
  Future<void> _loadUserData() async {
    try {
      _userData = await _authService.getUserData();
    } catch (e) {
      debugPrint('User data loading error: $e');
    }
  }

  // Login anónimo
  Future<bool> signInAnonymously() async {
    _setLoading(true);
    try {
      final result = await _authService.signInAnonymously();
      _clearError();
      return result != null;
    } catch (e) {
      _setError(_authService.getAuthErrorMessage(e));
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Login con Google
  Future<bool> signInWithGoogle() async {
    _setLoading(true);
    try {
      final result = await _authService.signInWithGoogle();
      _clearError();
      return result != null;
    } catch (e) {
      _setError(_authService.getAuthErrorMessage(e));
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Login con email y contraseña
  Future<bool> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    try {
      final result = await _authService.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _clearError();
      return result != null;
    } catch (e) {
      _setError(_authService.getAuthErrorMessage(e));
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Registro con email y contraseña
  Future<bool> createUserWithEmailAndPassword({
    required String email,
    required String password,
    String? displayName,
  }) async {
    _setLoading(true);
    try {
      final result = await _authService.createUserWithEmailAndPassword(
        email: email,
        password: password,
        displayName: displayName,
      );
      _clearError();
      return result != null;
    } catch (e) {
      _setError(_authService.getAuthErrorMessage(e));
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Cerrar sesión
  Future<void> signOut() async {
    _setLoading(true);
    try {
      await _authService.signOut();
      _clearError();
    } catch (e) {
      _setError(_authService.getAuthErrorMessage(e));
    } finally {
      _setLoading(false);
    }
  }

  // Restablecer contraseña
  Future<bool> sendPasswordResetEmail(String email) async {
    _setLoading(true);
    try {
      await _authService.sendPasswordResetEmail(email);
      _clearError();
      return true;
    } catch (e) {
      _setError(_authService.getAuthErrorMessage(e));
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Actualizar perfil
  Future<bool> updateUserProfile({
    String? displayName,
    String? photoURL,
  }) async {
    _setLoading(true);
    try {
      await _authService.updateUserProfile(
        displayName: displayName,
        photoURL: photoURL,
      );
      await _loadUserData(); // Recargar datos
      _clearError();
      return true;
    } catch (e) {
      _setError(_authService.getAuthErrorMessage(e));
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Eliminar cuenta
  Future<bool> deleteAccount() async {
    _setLoading(true);
    try {
      await _authService.deleteAccount();
      _clearError();
      return true;
    } catch (e) {
      _setError(_authService.getAuthErrorMessage(e));
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Vincular cuenta anónima con Google
  Future<bool> linkAnonymousWithGoogle() async {
    _setLoading(true);
    try {
      final result = await _authService.linkAnonymousWithGoogle();
      _clearError();
      return result != null;
    } catch (e) {
      _setError(_authService.getAuthErrorMessage(e));
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Verificar si es usuario premium
  Future<bool> isPremiumUser() async {
    try {
      return await _authService.isPremiumUser();
    } catch (e) {
      return false;
    }
  }

  // Actualizar estado premium
  Future<void> updatePremiumStatus(bool isPremium) async {
    try {
      await _authService.updatePremiumStatus(isPremium);
      await _loadUserData(); // Recargar datos
    } catch (e) {
      _setError('Error actualizando estado premium');
    }
  }

  // Actualizar preferencias
  Future<bool> updateUserPreferences(Map<String, dynamic> preferences) async {
    try {
      await _authService.updateUserPreferences(preferences);
      await _loadUserData(); // Recargar datos
      return true;
    } catch (e) {
      _setError('Error actualizando preferencias');
      return false;
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = '';
    notifyListeners();
  }

  void clearError() {
    _clearError();
  }
}