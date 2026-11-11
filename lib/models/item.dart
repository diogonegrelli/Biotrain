class Item {
  final int id;
  final String nome;
  final String descricao;
  final String urlimagem;

  Item({
    required this.id,
    required this.nome,
    required this.descricao,
    required this.urlimagem,
  });

  String get imagemUrl => urlimagem;

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'] ?? 0,
      nome: json['nome'] ?? 'Sem nome',
      descricao: json['descricao'] ?? 'Sem descrição',
      urlimagem: json['urlimagem'] ?? '',
    );
  }
}