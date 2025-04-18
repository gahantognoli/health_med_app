import 'package:flutter/material.dart';
import 'package:health_med_app/api/exceptions/problem_details.dart';
import 'package:health_med_app/api/models/login_models.dart';
import 'package:health_med_app/api/rest_client.dart';
import 'package:health_med_app/locator.dart';
import 'package:health_med_app/pages/cadastro.dart';
import 'package:health_med_app/pages/index.dart';
import 'package:health_med_app/services/auth_service.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final RestClient _restClient = getIt<RestClient>();
  final AuthService _authService = getIt<AuthService>();

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();

  void _fazerLogin() async {
    if (_formKey.currentState!.validate()) {
      try {
        final email = _emailController.text;
        final senha = _senhaController.text;

        final loginRequest = LoginRequest(
          usuario: email,
          senha: senha,
          tipoUsuario: TipoUsuario.paciente.index,
        );

        var loginResponse = await _restClient.login(loginRequest);

        if (loginResponse.accessToken == null) {
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Falha ao realizar login!'),
              duration: Duration(seconds: 3),
            ),
          );
          return;
        }

        _authService.salvarToken(loginResponse.accessToken!);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const Index(),
          ),
        );
      } on ProblemDetails catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.title ?? 'Falha ao realizar login!'),
            duration: const Duration(seconds: 3),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Falha ao realizar login!'),
            duration: Duration(seconds: 3),
          ),
        );
      }
      // Exemplo de feedback
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Login',
          style: TextStyle(
            color: Theme.of(context).colorScheme.tertiary,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: buildPage(context),
    );
  }

  Padding buildPage(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.2,
              child: Center(
                child: Image.asset(
                  'assets/images/logo.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Bem-vindo de volta!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Por favor, faça login para continuar.',
              style: TextStyle(fontSize: 16),
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
                  return 'Digite seu email';
                } else if (!value.contains('@')) {
                  return 'Email inválido';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
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
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Digite sua senha';
                } else if (value.length < 6) {
                  return 'A senha deve ter pelo menos 6 caracteres';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _fazerLogin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.tertiary,
                ),
                child: const Text('Entrar'),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const Cadastro(),
                    ),
                  );
                },
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).colorScheme.primary,
                ),
                child: const Text('Registrar-se'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
