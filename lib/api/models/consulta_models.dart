import 'package:health_med_app/api/models/medico_models.dart';

class ConsultaViewModel {
  String id;
  DateTime horario;
  String status;
  String? justificativaCancelamento;
  double valor;
  MedicoViewModel medico;

  ConsultaViewModel({
    required this.id,
    required this.horario,
    required this.status,
    this.justificativaCancelamento,
    required this.valor,
    required this.medico,
  });

  factory ConsultaViewModel.fromJson(Map<String, dynamic> json) {
    return ConsultaViewModel(
      id: json['id'],
      horario: DateTime.parse(json['horario']),
      status: json['status'],
      justificativaCancelamento: json['justificativaCancelamento'],
      valor: (json['valor'] as num).toDouble(),
      medico: MedicoViewModel.fromJson(json['medico']),
    );
  }
}

class AgendarConsultaInputModel {
  String pacienteId;
  String medicoId;
  DateTime horario;

  AgendarConsultaInputModel({
    required this.pacienteId,
    required this.medicoId,
    required this.horario,
  });

  String toJson() {
    return '''
      {
        "pacienteId": "$pacienteId",
        "medicoId": "$medicoId",
        "horario": "${horario.toIso8601String().replaceFirst('Z', '')}"
      }
    ''';
  }
}
