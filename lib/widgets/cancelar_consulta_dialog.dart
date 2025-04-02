import 'package:flutter/material.dart';

class CancelarConsultaDialog extends StatefulWidget {
  const CancelarConsultaDialog({super.key});

  @override
  State<CancelarConsultaDialog> createState() => _CancelarConsultaDialogState();
}

class _CancelarConsultaDialogState extends State<CancelarConsultaDialog> {
  String motivoCancelamento = '';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Cancelar consulta'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Você tem certeza que deseja cancelar essa consulta?'),
          const SizedBox(height: 20),
          TextField(
            decoration: InputDecoration(
              labelText: 'Motivo do cancelamento',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            maxLength: 200,
            maxLines: 5,
            onChanged: (value) => setState(() {
              motivoCancelamento = value;
            }),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop({
            'cancelar': false,
            'motivoCancelamento': motivoCancelamento,
          }),
          child: const Text('Não'),
        ),
        ElevatedButton(
          onPressed: motivoCancelamento.isEmpty
              ? null
              : () => Navigator.of(context).pop({
                    'cancelar': true,
                    'motivoCancelamento': motivoCancelamento,
                  }),
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Theme.of(context).colorScheme.tertiary,
          ),
          child: const Text("Sim"),
        ),
      ],
    );
  }
}
