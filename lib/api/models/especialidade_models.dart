class EspecialidadeViewModel {
  final String id;
  final String nome;

  EspecialidadeViewModel({
    required this.id,
    required this.nome,
  });

  factory EspecialidadeViewModel.fromJson(Map<String, dynamic> json) {
    return EspecialidadeViewModel(
      id: json['id'] as String,
      nome: json['nome'] as String,
    );
  }
}