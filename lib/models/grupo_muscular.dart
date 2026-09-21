class GrupoMuscular {
  static const Map<int, String> dicionario = {
    1: 'Peitoral',
    2: 'Costas',
    3: 'Quadríceps',
    4: 'Posterior de Coxa',
    5: 'Ombros',
    6: 'Bíceps',
    7: 'Tríceps',
    8: 'Abdômen',
    9: 'Panturrilhas',
    10: 'Glúteos'
  };

  static String obterNomes(List<int> ids) {
    return ids.map((id) => dicionario[id] ?? 'Desconhecido').join(', ');
  }
}