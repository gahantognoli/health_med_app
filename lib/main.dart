import 'package:flutter/material.dart';
import 'package:health_med_app/locator.dart';
import 'package:health_med_app/pages/login.dart';
import 'package:health_med_app/services/config_service.dart';
import 'package:health_med_app/pages/splash_screen.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ConfigService.loadConfig();
  setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Health Med App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 22, 124, 207),
          primary: const Color.fromARGB(255, 22, 124, 207),
          secondary: Colors.teal,
          tertiary: Colors.white,
        ),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
      navigatorKey: navigatorKey,
      routes: {
        '/login': (context) => const Login(),
      },
    );
  }
}
