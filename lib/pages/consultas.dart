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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _restClient.obterEspecialidades(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) return const Erro();

          return buildPagina(snapshot.data);
        },
      ),
    );
  }

  Padding buildPagina(List<EspecialidadeViewModel>? especialidades) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          buildTitulo(),
          if (especialidades != null && especialidades.isNotEmpty)
            buildDropDownMedicos(especialidades),
          if (_medicos != null && _medicos!.isNotEmpty)
            buildListaMedicos()
          else
            const Center(child: Text('Nenhum médico encontrado.')),
        ],
      ),
    );
  }

  Text buildTitulo() {
    return const Text(
      'Agendar consulta?',
      style: TextStyle(
        fontSize: 18,
      ),
      textAlign: TextAlign.center,
    );
  }

  Padding buildDropDownMedicos(List<EspecialidadeViewModel> especialidades) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: DropdownMenu<String>(
        initialSelection: _especialidadeSelecionadaId ?? "",
        onSelected: (String? value) {
          if (value != null) {
            _restClient.obterMedicos(value).then((medicos) {
              setState(() {
                _especialidadeSelecionadaId = value;
                _medicos = medicos;
              });
            });
          }
        },
        width: double.infinity,
        hintText: 'Selecione uma especialidade',
        dropdownMenuEntries: [
          DropdownMenuEntry<String>(
            value: "",
            label: "Todas",
            leadingIcon: Icon(
              Icons.medical_services,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
          ...especialidades.map(
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
    );
  }

  Expanded buildListaMedicos() {
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
              '${medico.especialidade?.nome} \n'
              'R\$ ${medico.valorConsulta.toStringAsFixed(2)}\n',
            ),
            trailing: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AgendarConsulta(
                      medico: medico.nome,
                    ),
                  ),
                );
              },
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
