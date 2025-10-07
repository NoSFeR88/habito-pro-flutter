import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Stream del usuario actual
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Usuario actual
  User? get currentUser => _auth.currentUser;

  // Verificar si está logueado
  bool get isSignedIn => _auth.currentUser != null;

  // Login anónimo
  Future<UserCredential?> signInAnonymously() async {
    try {
      final credential = await _auth.signInAnonymously();
      
      // Crear documento de usuario si no existe
      if (credential.user != null) {
        await _createUserDocument(credential.user!);
      }
      
      return credential;
    } catch (e) {
      throw Exception('Anonymous login error: $e');
    }
  }

  // Login con Google
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Trigger el flujo de autenticación
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
        return null; // Usuario canceló el login
      }

      // Obtener detalles de autenticación
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Crear credenciales
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Autenticar con Firebase
      final userCredential = await _auth.signInWithCredential(credential);
      
      // Crear/actualizar documento de usuario
      if (userCredential.user != null) {
        await _createUserDocument(userCredential.user!);
      }

      return userCredential;
    } catch (e) {
      throw Exception('Google login error: $e');
    }
  }

  // Login con email y contraseña
  Future<UserCredential?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      if (credential.user != null) {
        await _createUserDocument(credential.user!);
      }
      
      return credential;
    } catch (e) {
      throw Exception('Email login error: $e');
    }
  }

  // Registro con email y contraseña
  Future<UserCredential?> createUserWithEmailAndPassword({
    required String email,
    required String password,
    String? displayName,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // Actualizar el perfil con el nombre si se proporciona
      if (displayName != null && credential.user != null) {
        await credential.user!.updateDisplayName(displayName);
      }
      
      // Crear documento de usuario
      if (credential.user != null) {
        await _createUserDocument(credential.user!, displayName: displayName);
      }
      
      return credential;
    } catch (e) {
      throw Exception('Registration error: $e');
    }
  }

  // Cerrar sesión
  Future<void> signOut() async {
    try {
      await Future.wait([
        _auth.signOut(),
        _googleSignIn.signOut(),
      ]);
    } catch (e) {
      throw Exception('Logout error: $e');
    }
  }

  // Restablecer contraseña
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw Exception('Password reset error: $e');
    }
  }

  // Eliminar cuenta
  Future<void> deleteAccount() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        // Eliminar datos del usuario de Firestore
        await _firestore.collection('users').doc(user.uid).delete();
        
        // Eliminar cuenta de Authentication
        await user.delete();
      }
    } catch (e) {
      throw Exception('Delete account error: $e');
    }
  }

  // Actualizar perfil de usuario
  Future<void> updateUserProfile({
    String? displayName,
    String? photoURL,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await user.updateDisplayName(displayName);
        await user.updatePhotoURL(photoURL);
        
        // Actualizar en Firestore
        await _firestore.collection('users').doc(user.uid).update({
          'displayName': displayName,
          'photoURL': photoURL,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      throw Exception('Profile update error: $e');
    }
  }

  // Crear documento de usuario en Firestore
  Future<void> _createUserDocument(User user, {String? displayName}) async {
    try {
      final userDoc = _firestore.collection('users').doc(user.uid);
      final docSnapshot = await userDoc.get();
      
      if (!docSnapshot.exists) {
        await userDoc.set({
          'uid': user.uid,
          'email': user.email,
          'displayName': displayName ?? user.displayName ?? 'Usuario',
          'photoURL': user.photoURL,
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
          'isAnonymous': user.isAnonymous,
          'preferences': {
            'theme': 'system', // system, light, dark
            'notifications': true,
            'language': 'es',
            'isPremium': false,
          },
          'stats': {
            'totalHabits': 0,
            'totalCompletions': 0,
            'longestStreak': 0,
            'joinDate': FieldValue.serverTimestamp(),
          }
        });
      } else {
        // Actualizar última conexión
        await userDoc.update({
          'updatedAt': FieldValue.serverTimestamp(),
          'lastLogin': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      debugPrint('User document creation error: $e');
      // No lanzar excepción aquí para no interferir con el login
    }
  }

  // Obtener datos del usuario desde Firestore
  Future<Map<String, dynamic>?> getUserData() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final doc = await _firestore.collection('users').doc(user.uid).get();
        return doc.exists ? doc.data() : null;
      }
      return null;
    } catch (e) {
      throw Exception('User data error: $e');
    }
  }

  // Actualizar preferencias de usuario
  Future<void> updateUserPreferences(Map<String, dynamic> preferences) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).update({
          'preferences': preferences,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      throw Exception('Preferences update error: $e');
    }
  }

  // Verificar si el usuario es premium
  Future<bool> isPremiumUser() async {
    try {
      final userData = await getUserData();
      return userData?['preferences']?['isPremium'] ?? false;
    } catch (e) {
      return false;
    }
  }

  // Actualizar estado premium
  Future<void> updatePremiumStatus(bool isPremium) async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).update({
          'preferences.isPremium': isPremium,
          'premiumUpdatedAt': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      throw Exception('Premium status error: $e');
    }
  }

  // Convertir usuario anónimo a permanente
  Future<UserCredential?> linkAnonymousWithGoogle() async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null || !currentUser.isAnonymous) {
        return null;
      }

      // Login con Google
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Vincular cuentas
      final userCredential = await currentUser.linkWithCredential(credential);
      
      // Actualizar documento de usuario
      if (userCredential.user != null) {
        await _firestore.collection('users').doc(userCredential.user!.uid).update({
          'email': userCredential.user!.email,
          'displayName': userCredential.user!.displayName,
          'photoURL': userCredential.user!.photoURL,
          'isAnonymous': false,
          'linkedAt': FieldValue.serverTimestamp(),
        });
      }

      return userCredential;
    } catch (e) {
      throw Exception('Account linking error: $e');
    }
  }

  // Manejar errores de autenticación
  String getAuthErrorMessage(dynamic error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'user-not-found':
          return 'No existe una cuenta con este email.';
        case 'wrong-password':
          return 'Contraseña incorrecta.';
        case 'email-already-in-use':
          return 'Ya existe una cuenta con este email.';
        case 'weak-password':
          return 'La contraseña debe tener al menos 6 caracteres.';
        case 'invalid-email':
          return 'El email no es válido.';
        case 'too-many-requests':
          return 'Demasiados intentos. Intenta más tarde.';
        case 'network-request-failed':
          return 'Error de conexión. Verifica tu internet.';
        default:
          return 'Error de autenticación: ${error.message}';
      }
    }
    return 'Error desconocido: $error';
  }
}