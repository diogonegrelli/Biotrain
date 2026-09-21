import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/exercicio.dart';

class StorageService {
  static const String _chaveFavoritos = 'favoritos_aluno';

  Future<void> salvarFavoritos(List<Exercicio> favoritos) async {
    final prefs = await SharedPreferences.getInstance();
    
    List<String> listaStrings = favoritos.map((exercicio) {
      return json.encode({
        'id': exercicio.id,
        'nome': exercicio.nome,
        'idGrupoMuscular': exercicio.idGrupoMuscular,
        'descricao': exercicio.descricao,
        'urlimagem': exercicio.urlimagem,
      });
    }).toList();

    await prefs.setStringList(_chaveFavoritos, listaStrings);
  }

  Future<List<Exercicio>> carregarFavoritos() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      List<String>? listaStrings = prefs.getStringList(_chaveFavoritos) ?? [];

      return listaStrings.map((texto) {
        final jsonMap = json.decode(texto);
        return Exercicio.fromJson(jsonMap);
      }).toList();
    } catch (e) {
      // ignore: avoid_print
      print('Erro ao carregar favoritos no StorageService: $e');
      return []; 
    }
  }
}