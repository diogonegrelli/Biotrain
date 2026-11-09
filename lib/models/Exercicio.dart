class Exercicio {
  final int id;
  final String nome;
  final String descricao;
  final String? imagemUrl;

  Exercicio({
    required this.id,
    required this.nome,
    required this.descricao,
    this.imagemUrl,
  });

  factory Exercicio.fromJson(Map<String, dynamic> json) {
    if (json.containsKey('nome')) {
      return Exercicio(
        id: json['id'],
        nome: json['nome'] ?? 'Sem nome',
        descricao: json['descricao'] ?? '',
        imagemUrl: json['urlimagem'],
      );
    }

    final List translations = json['translations'] ?? [];
    final traducao = translations.firstWhere(
      (t) => t['language'] == 2,
      orElse: () => translations.isNotEmpty ? translations.first : null,
    );

    final List images = json['images'] ?? [];
    final String? imagem = images.isNotEmpty ? images.first['image'] : null;

    final String descricaoBruta = traducao?['description'] ?? '';
    final String descricao = descricaoBruta.replaceAll(RegExp(r'<[^>]*>'), '').trim();

    return Exercicio(
      id: json['id'],
      nome: traducao?['name'] ?? 'Sem nome',
      descricao: descricao,
      imagemUrl: imagem,
    );
  }
}