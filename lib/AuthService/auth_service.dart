import 'package:firebase_auth/firebase_auth.dart';

class AuthService {

  Future<void> signup({
    required String email, 
    required String password
  }) async {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password
    );
  }

  Future<void> login({
    required String email, 
    required String password
  }) async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password
    );
  }


}