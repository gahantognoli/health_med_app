import 'package:health_med_app/api/models/especialidade_models.dart';

class MedicoViewModel {
  String id;
  String nome;
  String email;
  String crm;
  double valorConsulta;
  EspecialidadeViewModel? especialidade;

  MedicoViewModel({
    required this.id,
    required this.nome,
    required this.email,
    required this.crm,
    required this.valorConsulta,
    required this.especialidade,
  });

  MedicoViewModel.fromJson(Map<String, dynamic> json)
      : id = json['id'] ?? '',
        nome = json['nome'] ?? '',
        email = json['email'] ?? '',
        crm = json['crm'] ?? '',
        valorConsulta = (json['valorConsulta'] as num?)?.toDouble() ?? 0.0,
        especialidade = json['especialidade'] != null
            ? EspecialidadeViewModel.fromJson(json['especialidade'])
            : null;
}
