import 'package:flutter/material.dart';
import 'package:health_med_app/pages/buscar_medicos.dart';
import 'package:health_med_app/pages/meu_perfil.dart';
import 'package:health_med_app/pages/minhas_consultas.dart';

class Index extends StatefulWidget {
  const Index({super.key});

  @override
  State<Index> createState() => _IndexState();
}

class _IndexState extends State<Index> {
  int indiceTela = 0;
  final List<Widget> telas = [
    const BuscarMedicos(),
    const MinhasConsultas(),
    const MeuPerfil(),
  ];

  void onTabTapped(int index) {
    setState(() => indiceTela = index);
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
            icon: Icon(Icons.search),
            label: 'Buscar médicos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.medical_services),
            label: 'Minhas consultas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Meu perfil',
          ),
        ],
      ),
    );
  }
}
