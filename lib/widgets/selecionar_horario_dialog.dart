import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SelecionarHorarioDialog extends StatefulWidget {
  final List<DateTime> diasDisponiveis;
  final Map<DateTime, List<String>> horariosDisponiveis;
  final int qtdDiasDisponiveis;

  const SelecionarHorarioDialog({
    super.key,
    required this.diasDisponiveis,
    required this.horariosDisponiveis,
    required this.qtdDiasDisponiveis,
  });

  @override
  State<SelecionarHorarioDialog> createState() =>
      _SelecionarHorarioDialogState();
}

class _SelecionarHorarioDialogState extends State<SelecionarHorarioDialog> {
  DateTime? _dataSelecionada;
  String? _horarioSelecionado;

  void _confirmarSelecao() {
    if (_dataSelecionada != null && _horarioSelecionado != null) {
      Navigator.pop(context, {
        'data': _dataSelecionada,
        'horario': _horarioSelecionado,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Selecionar horário"),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildCalendario(),
            const SizedBox(height: 20),
            if (_dataSelecionada != null) _buildHorarios(),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancelar"),
        ),
        ElevatedButton(
          onPressed: _horarioSelecionado != null ? _confirmarSelecao : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Theme.of(context).colorScheme.tertiary,
          ),
          child: const Text("Confirmar"),
        ),
      ],
    );
  }

  Widget _buildCalendario() {
    return Column(
      children: [
        const Text("Escolha o dia da consulta"),
        const SizedBox(height: 10),
        ElevatedButton.icon(
          onPressed: () async {
            DateTime? dataEscolhida = await showDatePicker(
              context: context,
              initialDate: widget.diasDisponiveis.first,
              firstDate:widget.diasDisponiveis.first,
              lastDate:
                  DateTime.now().add(Duration(days: widget.qtdDiasDisponiveis)),
              selectableDayPredicate: (date) =>
                  widget.diasDisponiveis.contains(date),
            );

            if (dataEscolhida != null) {
              setState(() {
                _dataSelecionada = dataEscolhida;
                _horarioSelecionado = null;
              });
            }
          },
          icon: const Icon(Icons.calendar_today),
          label: Text(
            _dataSelecionada == null
                ? "Selecionar data"
                : DateFormat('dd/MM/yyyy').format(_dataSelecionada!),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Theme.of(context).colorScheme.tertiary,
          ),
        ),
      ],
    );
  }

  Widget _buildHorarios() {
    List<String> horarios = widget.horariosDisponiveis[_dataSelecionada] ?? [];

    return Column(
      children: [
        const Text("Escolha um horário disponível"),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          children: horarios.map((horario) {
            bool isSelected = horario == _horarioSelecionado;
            return ChoiceChip(
              label: Text(horario),
              selected: isSelected,
              onSelected: (_) {
                setState(() => _horarioSelecionado = horario);
              },
              checkmarkColor: Theme.of(context).colorScheme.secondary,
            );
          }).toList(),
        ),
      ],
    );
  }
}
