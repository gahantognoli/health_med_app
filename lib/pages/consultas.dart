import 'package:flutter/material.dart';
import 'package:health_med_app/api/models/especialidade_models.dart';
import 'package:health_med_app/api/models/medico_models.dart';
import 'package:health_med_app/api/rest_client.dart';
import 'package:health_med_app/locator.dart';
import 'package:health_med_app/pages/agendar_consulta.dart';
import 'package:health_med_app/widgets/erro.dart';

class Consultas extends StatefulWidget {
  const Consultas({super.key});

  @override
  State<Consultas> createState() => _ConsultasState();
}

class _ConsultasState extends State<Consultas> {
  final RestClient _restClient = getIt<RestClient>();

  String? _especialidadeSelecionadaId;
  List<MedicoViewModel>? _medicos;
  List<EspecialidadeViewModel>? _especialidades;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _carregarEspecialidades();
  }

  Future<void> _carregarEspecialidades() async {
    try {
      final especialidades = await _restClient.obterEspecialidades();
      setState(() {
        _especialidades = especialidades;
        _hasError = false;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
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

  Padding buildPagina() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          buildTitulo(),
          if (_especialidades != null && _especialidades!.isNotEmpty)
            buildDropDownMedicos(),
          if (_medicos != null && _medicos!.isNotEmpty)
            buildListaMedicos()
          else
            const Center(child: Text('Nenhum médico encontrado.')),
        ],
      ),
    );
  }

  Widget buildTitulo() {
    return const Text(
      'Agendar consulta?',
      style: TextStyle(
        fontSize: 18,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget buildDropDownMedicos() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          DropdownMenu<String>(
            initialSelection: _especialidadeSelecionadaId ?? "",
            onSelected: (String? value) {
              if (value != null) {
                setState(() => _especialidadeSelecionadaId = value);
              }
            },
            width: double.infinity,
            hintText: 'Selecione uma especialidade',
            dropdownMenuEntries: [
              DropdownMenuEntry<String>(
                value: "",
                label: "Todos",
                leadingIcon: Icon(
                  Icons.medical_services,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              ..._especialidades!.map(
                (especialidade) => DropdownMenuEntry<String>(
                  value: especialidade.id,
                  label: especialidade.nome,
                  leadingIcon: Icon(
                    Icons.medical_services,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                _restClient
                    .obterMedicos(_especialidadeSelecionadaId ?? "")
                    .then((medicos) {
                  setState(() => _medicos = medicos);
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.tertiary,
              ),
              child: const Text('Buscar médicos'),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildListaMedicos() {
    return Expanded(
      child: ListView.builder(
        itemCount: _medicos!.length,
        itemBuilder: (context, index) {
          final medico = _medicos![index];
          return ListTile(
            leading: Icon(
              Icons.person_pin_outlined,
              color: Theme.of(context).colorScheme.secondary,
            ),
            title: Text(medico.nome),
            subtitle: Text(
              '${medico.especialidade.nome} \n'
              'R\$ ${medico.valorConsulta.toStringAsFixed(2)}\n',
            ),
            trailing: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AgendarConsulta(
                      idMedico: medico.id,
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.tertiary,
              ),
              child: const Text('Agendar'),
            ),
            titleTextStyle: const TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          );
        },
      ),
    );
  }
}
