// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:health_med_app/api/exceptions/problem_details.dart';
import 'package:health_med_app/api/models/paciente_models.dart';
import 'package:health_med_app/api/rest_client.dart';
import 'package:health_med_app/locator.dart';
import 'package:health_med_app/widgets/erro.dart';

class MeuPerfil extends StatefulWidget {
  const MeuPerfil({super.key});

  @override
  State<MeuPerfil> createState() => _MeuPerfilState();
}

class _MeuPerfilState extends State<MeuPerfil> {
  final RestClient _restClient = getIt<RestClient>();

  bool _isLoading = true;
  bool _hasError = false;
  PacienteViewModel? _paciente;
  final _nomeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  Future<void> _carregarDados() async {
    try {
      const String pacienteId =
          '34ca26eb-e3d1-4a31-b8a2-07f529154795'; //todo: pegar do usuario logado
      var paciente = await _restClient.obterPaciente(pacienteId);
      setState(() {
        _paciente = paciente;
        _nomeController.text = paciente.nome;
        _isLoading = false;
        _hasError = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  Future<void> atualizarDados() async {
    try {
      const String pacienteId =
          '34ca26eb-e3d1-4a31-b8a2-07f529154795'; //todo: pegar do usuario logado

      var pacienteInputModel = AtualizacaoPacienteInputModel(
        nome: _nomeController.text,
      );

      await _restClient.atualizarPaciente(pacienteId, pacienteInputModel);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Dados atualizados com sucesso!'),
          duration: Duration(seconds: 2),
        ),
      );
    } on ProblemDetails catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.detail ?? 'Falha ao atualizar dados!'),
          duration: const Duration(seconds: 3),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Falha ao atualizar dados!'),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  Future<void> excluirConta() async {
    try {
      const String pacienteId =
          '34ca26eb-e3d1-4a31-b8a2-07f529154795'; //todo: pegar do usuario logado
      await _restClient.excluirPaciente(pacienteId);
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Conta excluída com sucesso!'),
          duration: Duration(seconds: 2),
        ),
      );
      //todo: redirecionar para tela de login
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Falha ao excluir conta!'),
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
              : buildPagina(),
    );
  }

  Widget buildPagina() {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            enabled: true,
            decoration: InputDecoration(
              labelText: 'Nome',
              labelStyle: TextStyle(
                color: Theme.of(context).colorScheme.primary,
              ),
              border: const OutlineInputBorder(),
            ),
            controller: _nomeController,
          ),
          const SizedBox(height: 20),
          TextField(
            enabled: false,
            decoration: InputDecoration(
              labelText: 'Email',
              labelStyle: TextStyle(
                color: Theme.of(context).colorScheme.primary,
              ),
              border: const OutlineInputBorder(),
            ),
            controller: TextEditingController(text: _paciente?.email),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: atualizarDados,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.tertiary,
                  ),
                  child: const Text('Atualizar'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  onPressed: () async {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Excluir conta'),
                          content: const Text(
                            'Tem certeza que deseja excluir sua conta?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Cancelar'),
                            ),
                            ElevatedButton(
                                onPressed: excluirConta,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                ),
                                child: const Text('Excluir conta')),
                          ],
                        );
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Excluir conta'),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
