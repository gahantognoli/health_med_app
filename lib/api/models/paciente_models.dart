class PacienteViewModel {
  String id;
  String nome;
  String email;

  PacienteViewModel({
    required this.id,
    required this.nome,
    required this.email,
  });

  factory PacienteViewModel.fromJson(Map<String, dynamic> json) {
    return PacienteViewModel(
      id: json['id'] as String,
      nome: json['nome'] as String,
      email: json['email'] as String,
    );
  }
}

class AtualizacaoPacienteInputModel {
  String nome;

  AtualizacaoPacienteInputModel({
    required this.nome,
  });

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
    };
  }
}