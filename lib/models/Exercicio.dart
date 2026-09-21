class Exercicio {
  final int id; 
  final String nome;
  final List<int> idGrupoMuscular;
  final String descricao;
  final String urlimagem;

  Exercicio({
    required this.id,
    required this.nome,
    required this.idGrupoMuscular,
    required this.descricao,
    required this.urlimagem,
  });

  factory Exercicio.fromJson(Map<String, dynamic> json) {
    return Exercicio(
      id: int.parse(json['id'].toString()),
      
      nome: json['nome'] ?? 'Sem nome',
      
      idGrupoMuscular: List<int>.from(json['idGrupoMuscular'] ?? json['grupos_musculares'] ?? []),
      
      descricao: json['descricao'] ?? 'Sem descrição',
      
      urlimagem: json['urlimagem'] ?? json['imagem_url'] ?? '', 
    );
  }
}