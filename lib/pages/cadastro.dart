// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:health_med_app/api/exceptions/problem_details.dart';
import 'package:health_med_app/api/models/paciente_models.dart';

import 'package:health_med_app/api/rest_client.dart';
import 'package:health_med_app/locator.dart';

class Cadastro extends StatefulWidget {
  const Cadastro({super.key});

  @override
  State<Cadastro> createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  final RestClient _restClient = getIt<RestClient>();

  final _formKey = GlobalKey<FormState>();

  final _nomeController = TextEditingController();
  final _cpfController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();

  // Validação e envio
  Future<void> _enviarCadastro() async {
    if (_formKey.currentState!.validate()) {
      final nome = _nomeController.text.trim();
      final cpf = _cpfController.text.trim();
      final email = _emailController.text.trim();
      final senha = _senhaController.text.trim();

      final dados = CadastroPacienteInputModel(
        nome: nome,
        email: email,
        cpf: cpf,
        senha: senha,
      );

      try {
        await _restClient.cadastrarPaciente(dados);
        Timer(
          const Duration(seconds: 2),
          () => Navigator.of(context).pop(),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cadastro realizado com sucesso!'),
            duration: Duration(seconds: 2),
          ),
        );
      } on ProblemDetails catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.title ?? 'Falha ao cadastrar paciente!'),
            duration: const Duration(seconds: 3),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Falha ao cadastrar paciente!'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _cpfController.dispose();
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cadastro',
          style: TextStyle(
            color: Theme.of(context).colorScheme.tertiary,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: buildPagina(context),
    );
  }

  Padding buildPagina(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            const Text(
              'Crie sua conta!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Por favor, preencha os dados abaixo.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _nomeController,
              decoration: InputDecoration(
                labelText: 'Nome',
                labelStyle: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
                border: const OutlineInputBorder(),
              ),
              validator: (value) =>
                  value == null || value.isEmpty ? 'Nome obrigatório' : null,
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _cpfController,
              decoration: InputDecoration(
                labelText: 'CPF',
                labelStyle: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
                border: const OutlineInputBorder(),
              ),
              validator: (value) => value == null || value.length < 6
                  ? 'CPF deve ter 11 caracteres'
                  : null,
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
                border: const OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Email obrigatório';
                }
                final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                if (!emailRegex.hasMatch(value)) {
                  return 'Email inválido';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _senhaController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Senha',
                labelStyle: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
                border: const OutlineInputBorder(),
              ),
              validator: (value) => value == null || value.length < 6
                  ? 'Senha deve ter no mínimo 6 caracteres'
                  : null,
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _enviarCadastro,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.tertiary,
              ),
              child: const Text('Cadastrar'),
            ),
          ],
        ),
      ),
    );
  }
}
