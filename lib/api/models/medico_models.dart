import 'package:health_med_app/api/models/disponibilidade_models.dart';
import 'package:health_med_app/api/models/especialidade_models.dart';

class MedicoViewModel {
  String id;
  String nome;
  String email;
  String crm;
  double valorConsulta;
  EspecialidadeViewModel especialidade;
  List<DisponibilidadeViewModel>? disponibilidade;

  MedicoViewModel({
    required this.id,
    required this.nome,
    required this.email,
    required this.crm,
    required this.valorConsulta,
    required this.especialidade,
    this.disponibilidade,
  });

  MedicoViewModel.fromJson(Map<String, dynamic> json)
      : id = json['id'] ?? '',
        nome = json['nome'] ?? '',
        email = json['email'] ?? '',
        crm = json['crm'] ?? '',
        valorConsulta = (json['valorConsulta'] as num?)?.toDouble() ?? 0.0,
        especialidade = EspecialidadeViewModel.fromJson(
          json['especialidade'],
        ),
        disponibilidade = json['disponibilidade'] != null
            ? (json['disponibilidade'] as List)
                .map((disponibilidade) =>
                    DisponibilidadeViewModel.fromJson(disponibilidade))
                .toList()
            : null;
}
