// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:health_med_app/api/exceptions/problem_details.dart';
import 'package:health_med_app/api/models/consulta_models.dart';
import 'package:health_med_app/api/models/disponibilidade_models.dart';
import 'package:health_med_app/api/models/medico_models.dart';
import 'package:health_med_app/api/rest_client.dart';
import 'package:health_med_app/locator.dart';
import 'package:health_med_app/widgets/erro.dart';
import 'package:health_med_app/widgets/selecionar_horario_dialog.dart';

class AgendarConsulta extends StatefulWidget {
  final String idMedico;

  const AgendarConsulta({
    super.key,
    required this.idMedico,
  });

  @override
  State<AgendarConsulta> createState() => _AgendarConsultaState();
}

class _AgendarConsultaState extends State<AgendarConsulta> {
  final RestClient _restClient = getIt<RestClient>();

  MedicoViewModel? _medico;
  List<ConsultaViewModel>? _consultasOcupadas;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  Future<void> _carregarDados() async {
    try {
      final medico = await _restClient.obterMedico(widget.idMedico);
      final consultasMedico = await _restClient.obterConsultasPendentesMedico(
        widget.idMedico,
      );
      setState(() {
        _medico = medico;
        _consultasOcupadas = consultasMedico;
        _hasError = false;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
    }
  }

  Future<void> showDialogSelecionarHorario() async {
    const qtdDiasDisponiveis = 90;
    var datasAgendamentos = List.generate(
      qtdDiasDisponiveis * 24,
      (index) {
        int dias = index ~/ 24;
        int horas = index % 24;
        var hoje = DateTime.now();
        var dataRef = DateTime(
          hoje.year,
          hoje.month,
          hoje.day,
          hoje.hour + 1,
        );
        return dataRef.add(Duration(days: dias, hours: horas));
      },
    );

    var datasDisponiveis = datasAgendamentos;

    if (_medico!.disponibilidade != null) {
      datasDisponiveis = datasDisponiveis
          .where((data) => _medico!.disponibilidade!
              .map((d) => d.diaSemana)
              .contains(data.weekday))
          .where((data) {
            var disponibilidadeMedico = _medico!.disponibilidade!
                .firstWhere((d) => d.diaSemana == data.weekday);

            return data.hour >= disponibilidadeMedico.horaInicio &&
                data.hour <= disponibilidadeMedico.horaFim;
          })
          .toList();
    }

    if (_consultasOcupadas != null) {
      datasDisponiveis = datasDisponiveis
          .where((data) =>
              !_consultasOcupadas!.any((consulta) => consulta.horario == data))
          .toList();
    }

    var diasDisponiveis = datasDisponiveis
        .map((data) => DateTime(data.year, data.month, data.day))
        .toSet()
        .toList();

    var horariosDisponiveis =
        diasDisponiveis.fold<Map<DateTime, List<String>>>({}, (map, data) {
      DisponibilidadeViewModel? disponibilidadeMedico;

      if (_medico!.disponibilidade != null) {
        disponibilidadeMedico = _medico!.disponibilidade!
            .firstWhere((d) => d.diaSemana == data.weekday);
      }

      var horarios = disponibilidadeMedico != null
          ? List.generate(
              disponibilidadeMedico.horaFim -
                  disponibilidadeMedico.horaInicio +
                  1,
              (index) =>
                  '${(disponibilidadeMedico!.horaInicio + index).toString().padLeft(2, '0')}:00',
            )
          : List.generate(
              24,
              (index) => '${index.toString().padLeft(2, '0')}:00',
            );

      horarios = horarios.where((hora) {
        DateTime horarioCompleto = DateTime(
            data.year, data.month, data.day, int.parse(hora.split(':')[0]));

        return datasDisponiveis.contains(horarioCompleto);
      }).toList();

      if (horarios.isNotEmpty) {
        map[data] = horarios;
      }

      return map;
    });

    var resposta = await showDialog(
      context: context,
      builder: (context) => SelecionarHorarioDialog(
        diasDisponiveis: diasDisponiveis,
        horariosDisponiveis: horariosDisponiveis,
        qtdDiasDisponiveis: qtdDiasDisponiveis,
      ),
    );

    if (resposta != null) {
      var dataSelecionada = resposta['data'] as DateTime;
      var horarioSelecionado = resposta['horario'] as String;
      await _agendarConsulta(dataSelecionada, horarioSelecionado);
    }
  }

  Future<void> _agendarConsulta(
      DateTime dataSelecionada, String horarioSelecionado) async {
    try {
      var consulta = AgendarConsultaInputModel(
        medicoId: _medico!.id,
        pacienteId:
            '34ca26eb-e3d1-4a31-b8a2-07f529154795', //todo: pegar do usuario logado
        horario: DateTime(
          dataSelecionada.year,
          dataSelecionada.month,
          dataSelecionada.day,
          int.parse(horarioSelecionado.split(':')[0]),
        ),
      );

      await _restClient.agendarConsulta(consulta);

      Timer(
        const Duration(seconds: 2),
        () => Navigator.of(context).pop(),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Consulta agendada com sucesso!'),
          duration: Duration(seconds: 2),
        ),
      );
    } on ProblemDetails catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.detail ?? 'Erro ao agendar consulta'),
          duration: const Duration(seconds: 3),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro ao agendar consulta'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Agendar consulta',
          style: TextStyle(
            color: Theme.of(context).colorScheme.tertiary,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _hasError
              ? const Erro()
              : buildPagina(),
    );
  }

  Widget buildPagina() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          buildTitulo(_medico!.nome),
          buildMedicoInfo(_medico!),
          buildAgendarButton(),
        ],
      ),
    );
  }

  Widget buildTitulo(String nomeMedico) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          Icons.person_pin_outlined,
          size: 50,
          color: Theme.of(context).colorScheme.secondary,
        ),
        const SizedBox(height: 10),
        Text(
          nomeMedico,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  Widget buildMedicoInfo(MedicoViewModel medicoViewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                    right: 10), // Espaçamento entre os campos
                child: TextField(
                  enabled: false,
                  decoration: InputDecoration(
                    labelText: 'CRM',
                    labelStyle: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    border: const OutlineInputBorder(),
                  ),
                  controller: TextEditingController(text: medicoViewModel.crm),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 10), // Espaçamento entre os campos
                child: TextField(
                  enabled: false,
                  decoration: InputDecoration(
                    labelText: 'Especialidade',
                    labelStyle: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    border: const OutlineInputBorder(),
                  ),
                  controller: TextEditingController(
                    text: medicoViewModel.especialidade.nome,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                    right: 10), // Espaçamento entre os campos
                child: TextField(
                  enabled: false,
                  decoration: InputDecoration(
                    labelText: 'Valor da consulta',
                    labelStyle: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    border: const OutlineInputBorder(),
                  ),
                  controller: TextEditingController(
                    text:
                        'R\$ ${medicoViewModel.valorConsulta.toStringAsFixed(2)}',
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 10), // Espaçamento entre os campos
                child: TextField(
                  enabled: false,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    border: const OutlineInputBorder(),
                  ),
                  controller: TextEditingController(
                    text: medicoViewModel.email,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildAgendarButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: ElevatedButton(
        onPressed: showDialogSelecionarHorario,
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.tertiary,
          padding: const EdgeInsets.symmetric(vertical: 10),
        ),
        child: const Text(
          'Selecionar horário',
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
