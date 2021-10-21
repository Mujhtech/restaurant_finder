import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:restaurant_finder/controller/auth_controller.dart';
import 'package:restaurant_finder/ui/auth/login.dart';
import 'package:restaurant_finder/ui/home.dart';
import 'package:restaurant_finder/ui/splash.dart';

class AuthStateScreen extends StatelessWidget {
  const AuthStateScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, _) {
        final user = watch(authControllerProvider);
        switch (user.status) {
          case Status.unauthenticated:
            return const LoginScreen();
          case Status.authenticating:
            return const LoginScreen();
          case Status.authenticated:
            return const HomeScreen();
          case Status.uninitialized:
          default:
            return const SplashScreen();
        }
      },
    );
  }
}
