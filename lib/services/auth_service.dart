import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Registrar usuario
  Future<UserModel?> signUp(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;
      return user != null ? UserModel(uid: user.uid, email: user.email!) : null;
    } catch (e) {
      print(e); // Manejo de errores más robusto puede ser implementado
      return null;
    }
  }

  // Iniciar sesión
  Future<UserModel?> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;
      return user != null ? UserModel(uid: user.uid, email: user.email!) : null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  // Cerrar sesión
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  // Obtener usuario actual
  UserModel? getCurrentUser() {
    User? user = _firebaseAuth.currentUser;
    return user != null ? UserModel(uid: user.uid, email: user.email!) : null;
  }
}
