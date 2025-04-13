import 'dart:async';

import 'package:flutter/material.dart';
import 'package:health_med_app/locator.dart';
import 'package:health_med_app/pages/index.dart';
import 'package:health_med_app/pages/login.dart';
import 'package:health_med_app/services/auth_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AuthService _authService = getIt<AuthService>();

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () async {
      final estaLogado = await _authService.estaLogado();
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => estaLogado ? const Index() : const Login(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(
          'assets/images/logo.png',
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
