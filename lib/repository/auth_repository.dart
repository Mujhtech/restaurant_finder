import 'package:firebase_auth/firebase_auth.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:restaurant_finder/provider/firebase_provider.dart';
import 'package:restaurant_finder/repository/custom_exception.dart';

abstract class BaseAuthRepository {
  Stream<User?> get authStateChanges;
  Future<UserCredential?> signIn(String email, String password);
  Future<UserCredential?> signUp(String email, String password);
  User? getCurrentUser();
  Future<void> signOut();
  Future<void> resetPassword(String email);
  Future<void> verifyResetCode(String code, String password);
}


final authRepositoryProvider =
    Provider<AuthRepository>((ref) => AuthRepository(ref.read));

class AuthRepository implements BaseAuthRepository {
  final Reader _read;

  const AuthRepository(this._read);

  @override
  Stream<User?> get authStateChanges =>
      _read(firebaseAuthProvider).authStateChanges();

  @override
  User? getCurrentUser() {
    return _read(firebaseAuthProvider).currentUser;
  }

  @override
  Future<UserCredential?> signIn(email, password) async {
    try {
      final user = await _read(firebaseAuthProvider)
          .signInWithEmailAndPassword(email: email, password: password);
      return user;
    } on FirebaseAuthException catch (e) {
      throw CustomException(message: e.message);
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _read(firebaseAuthProvider).signOut();
    } on FirebaseAuthException catch (e) {
      throw CustomException(message: e.message);
    }
  }

  @override
  Future<UserCredential?> signUp(email, password) async {
    try {
      final user = await _read(firebaseAuthProvider)
          .createUserWithEmailAndPassword(email: email, password: password);
      return user;
    } on FirebaseAuthException catch (e) {
      throw CustomException(message: e.message);
    }
  }

  @override
  Future<void> resetPassword(email) async {
    try {
      await _read(firebaseAuthProvider)
          .sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw CustomException(message: e.message);
    }
  }

  @override
  Future<void> verifyResetCode(String code, String password) async {
    try {
      await _read(firebaseAuthProvider).confirmPasswordReset(code: code, newPassword: password);
    } on FirebaseAuthException catch (e) {
      throw CustomException(message: e.message);
    }
  }
}
