// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:health_med_app/api/exceptions/problem_details.dart';
import 'package:health_med_app/api/models/consulta_models.dart';
import 'package:health_med_app/api/rest_client.dart';
import 'package:health_med_app/locator.dart';
import 'package:health_med_app/widgets/cancelar_consulta_dialog.dart';
import 'package:health_med_app/widgets/erro.dart';
import 'package:intl/intl.dart';

class MinhasConsultas extends StatefulWidget {
  const MinhasConsultas({super.key});

  @override
  State<MinhasConsultas> createState() => _MinhasConsultasState();
}

class _MinhasConsultasState extends State<MinhasConsultas> {
  final RestClient _restClient = getIt<RestClient>();

  List<ConsultaViewModel>? _consultas;
  bool _isLoading = true;
  bool _hasError = false;
  bool somenteConsultasPendentes = true;

  @override
  void initState() {
    super.initState();
    _carregarConsultas();
  }

  Future<void> _carregarConsultas() async {
    try {
      const String pacienteId =
          '34ca26eb-e3d1-4a31-b8a2-07f529154795'; //todo: pegar do usuario logado
      final consultas = await _restClient.obterConsultasPaciente(pacienteId);
      setState(() {
        _hasError = false;
        _isLoading = false;
        _consultas = consultas;
        if (somenteConsultasPendentes) {
          filtrarConsultasPendentes();
        }
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  void filtrarConsultasPendentes() {
    _consultas = _consultas
        ?.where((consulta) =>
            consulta.horario.isAfter(DateTime.now()) &&
            (consulta.status == "Aguardando aceite" ||
                consulta.status == "Aceita"))
        .toList();
  }

  Future<void> cancelarConsulta(
      String consultaId, String motivoCancelamento) async {
    try {
      await _restClient.cancelarConsulta(consultaId, motivoCancelamento);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Consulta cancelada com sucesso!'),
          duration: Duration(seconds: 2),
        ),
      );
    } on ProblemDetails catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.detail ?? 'Erro ao cancelar consulta'),
          duration: const Duration(seconds: 3),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erro ao cancelar consulta'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _hasError
              ? const Erro()
              : buildListaConsultas(),
    );
  }

  Widget buildListaConsultas() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: _consultas == null
          ? const Center(child: Text('Nenhuma consulta agendada.'))
          : Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Somente consultas pendentes: '),
                    SizedBox(
                      child: Switch(
                        value: somenteConsultasPendentes,
                        onChanged: (value) => {
                          setState(
                            () {
                              somenteConsultasPendentes = value;
                              _carregarConsultas();
                            },
                          )
                        },
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: _consultas?.length ?? 0,
                    itemBuilder: (context, index) {
                      final consulta = _consultas![index];
                      return Card(
                        child: ListTile(
                          title: Text(consulta.medico.nome),
                          subtitle: Text(
                              '${DateFormat('dd/MM/yyyy HH:mm').format(consulta.horario)}\n${consulta.status}'),
                          trailing: consulta.horario.isAfter(DateTime.now()) &&
                                  (consulta.status == "Aceita" ||
                                      consulta.status == "Aguardando aceite")
                              ? ElevatedButton(
                                  onPressed: () async {
                                    final consultaId = consulta.id;
                                    final resposta = await showDialog(
                                        context: context,
                                        builder: (context) =>
                                            const CancelarConsultaDialog());
                                    if (resposta != null) {
                                      if (resposta['cancelar'] == true) {
                                        await cancelarConsulta(
                                            consultaId,
                                            resposta['motivoCancelamento']
                                                as String);
                                        _carregarConsultas();
                                      }
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    foregroundColor: Colors.white,
                                  ),
                                  child: const Text('Cancelar'),
                                )
                              : null,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
