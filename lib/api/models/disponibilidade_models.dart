class DisponibilidadeViewModel {
  final int diaSemana;
  final String diaSemanaDesc;
  final int horaInicio;
  final int horaFim;

  DisponibilidadeViewModel({
    required this.diaSemana,
    required this.diaSemanaDesc,
    required this.horaInicio,
    required this.horaFim,
  });

  factory DisponibilidadeViewModel.fromJson(Map<String, dynamic> json) {
    return DisponibilidadeViewModel(
      diaSemana: json['diaSemana'] as int,
      diaSemanaDesc: json['diaSemanaDesc'] as String,
      horaInicio: json['horaInicio'] as int,
      horaFim: json['horaFim'] as int,
    );
  }
}