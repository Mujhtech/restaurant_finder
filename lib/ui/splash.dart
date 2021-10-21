import 'dart:async';

import 'package:flutter/material.dart';
import 'package:restaurant_finder/ui/auth/login.dart';
import 'package:restaurant_finder/ui/home.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const LoginScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: const SafeArea(
          child: Center(
            child: Text(
              'Restaurant\nFinder',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.black, fontSize: 32, fontFamily: 'Poppins'),
            ),
          ),
        ));
  }
}

@override
Widget build(BuildContext context) {
  // TODO: implement build
  throw UnimplementedError();
}
