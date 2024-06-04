import 'dart:developer' as developer;
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;

  Future<User?> createUserwithEmailandPassword(
      String email, String password) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return cred.user;
    } catch (err) {
      if (err is FirebaseAuthException) {
        developer.log(err.message ?? 'An unknown error occurred');
      } else {
        developer.log('An unknown error occurred');
      }
    }
    return null;
  }

  Future<User?> loginUserwithEmailandPassword(
      String email, String password) async {
    try {
      final cred = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return cred.user;
    } catch (err) {
      if (err is FirebaseAuthException) {
        developer.log(err.message ?? 'An unknown error occurred');
      } else {
        developer.log('An unknown error occurred');
      }
    }
    return null;
  }

  Future<void> signout() async {
    try {
      await _auth.signOut();
    } catch (err) {
      if (err is FirebaseAuthException) {
        developer.log(err.message ?? 'An unknown error occurred');
      } else {
        developer.log('An unknown error occurred');
      }
    }
  }
}
