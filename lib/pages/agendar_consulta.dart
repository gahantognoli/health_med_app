import 'package:flutter/material.dart';

class AgendarConsulta extends StatelessWidget {
  final String medico;

  const AgendarConsulta({
    super.key,
    required this.medico,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Consulta - $medico', style: TextStyle(
            color: Theme.of(context).colorScheme.tertiary,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: const Center(
        child: Text('Agendar Consulta'),
      ),
    );
  }
}
