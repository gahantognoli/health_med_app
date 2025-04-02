class ConsultaViewModel {
  DateTime horario;
  String status;
  String? justificativaCancelamento;
  double valor;

  ConsultaViewModel({
    required this.horario,
    required this.status,
    this.justificativaCancelamento,
    required this.valor,
  });

  factory ConsultaViewModel.fromJson(Map<String, dynamic> json) {
    return ConsultaViewModel(
      horario: DateTime.parse(json['horario']),
      status: json['status'],
      justificativaCancelamento: json['justificativaCancelamento'],
      valor: (json['valor'] as num).toDouble(),
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
