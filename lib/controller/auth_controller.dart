import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:restaurant_finder/repository/auth_repository.dart';
import 'package:restaurant_finder/repository/custom_exception.dart';

enum Status { uninitialized, authenticated, authenticating, unauthenticated }

final authControllerProvider = ChangeNotifierProvider<AuthController>(
    (ref) => AuthController(ref.read)..appStarted());

class AuthController extends ChangeNotifier {
  final Reader _read;
  User? _user;
  String? _error;
  Status _status = Status.uninitialized;
  bool loading = false;

  String? get error => _error;
  Status? get status => _status;
  User? get fbUser => _user;

  StreamSubscription<User?>? _authStateChangesSubscription;

  AuthController(this._read) {
    _authStateChangesSubscription?.cancel();
    _authStateChangesSubscription = _read(authRepositoryProvider)
        .authStateChanges
        .listen(_onAuthStateChanged);
  }

  @override
  void dispose() {
    super.dispose();
    _authStateChangesSubscription?.cancel();
  }

  Future<void> appStarted() async {
    final user = _read(authRepositoryProvider).getCurrentUser();
    if (user == null) {
      return;
    }
  }

  Future<bool> signIn(String email, String password) async {
    try {
      loading = true;
      notifyListeners();
      await _read(authRepositoryProvider).signIn(email, password);
      _error = '';
      loading = false;
      notifyListeners();
      return true;
    } on CustomException catch (e) {
      _error = e.message;
      loading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signUp(String email, String password) async {
    try {
      loading = true;
      notifyListeners();
      await _read(authRepositoryProvider).signUp(email, password);
      _error = '';
      loading = false;
      notifyListeners();
      return true;
    } on CustomException catch (e) {
      _error = e.message;
      loading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> signOut() async {
    await _read(authRepositoryProvider).signOut();
  }

  Future<void> _onAuthStateChanged(User? firebaseUser) async {
    if (firebaseUser == null) {
      _status = Status.unauthenticated;
      notifyListeners();
    } else {
      _user = firebaseUser;
      _status = Status.authenticated;
      notifyListeners();
    }
    notifyListeners();
  }

  Future<bool> deactivateAccount() async {
    try {
      return true;
    } catch (err) {
      return false;
    }
  }
}
