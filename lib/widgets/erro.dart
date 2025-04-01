import 'package:flutter/material.dart';

class Erro extends StatelessWidget {
  const Erro({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.error,
            size: 100,
            color: Colors.red,
          ),
          SizedBox(height: 20),
          Text(
            'Ocorreu um erro inesperado.',
            style: TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
