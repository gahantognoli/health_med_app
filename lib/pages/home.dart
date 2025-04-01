import 'package:flutter/material.dart';
import 'package:health_med_app/pages/consultas.dart';
import 'package:health_med_app/pages/perfil.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int indiceTela = 0;
  final List<Widget> telas = [
    const Consultas(),
    const Perfil(),
  ];

  void onTabTapped(int index) {
    setState(() {
      indiceTela = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Health & Med',
          style: TextStyle(
            color: Theme.of(context).colorScheme.tertiary,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: telas[indiceTela],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: indiceTela,
        onTap: onTabTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Consultas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}
