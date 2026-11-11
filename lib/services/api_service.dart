import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:translator/translator.dart'; // Import do tradutor do Google
import '../models/item.dart';

class ApiService {
  static const String _baseUrl =
      'https://wger.de/api/v2/exerciseinfo/?language=2&limit=10&offset=0';

  final GoogleTranslator _translator = GoogleTranslator();

  Future<Map<String, dynamic>> getExercicios({String? nextUrl}) async {
    final url = Uri.parse(nextUrl ?? _baseUrl);
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List resultados = data['results'] ?? [];

      final List<Item> itens = [];

      for (var itemJson in resultados) {
        final int id = itemJson['id'] ?? 0;
        
        final String nomeIngles = itemJson['name'] ?? 'Unknown Exercise';
        // Remove as tags HTML que a Wger manda na descrição
        final String descInglesRaw = itemJson['description'] ?? 'No description';
        final String descIngles = descInglesRaw.replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), '');

        // 2. Traduz em tempo real para Português usando o Google Tradutor
        final transNome = await _translator.translate(nomeIngles, from: 'en', to: 'pt');
        final transDesc = await _translator.translate(descIngles, from: 'en', to: 'pt');

        // Tratamento de imagem da Wger (pega a primeira imagem, se houver)
        String imagemUrl = '';
        if (itemJson['images'] != null && (itemJson['images'] as List).isNotEmpty) {
          imagemUrl = itemJson['images'][0]['image'] ?? '';
        }

        itens.add(Item(
          id: id,
          nome: transNome.text,
          descricao: transDesc.text.isNotEmpty ? transDesc.text : 'Sem descrição detalhada.',
          urlimagem: imagemUrl,
        ));
      }

      return {
        'exercicios': itens,
        'nextUrl': data['next'], // A Wger já devolve a URL da próxima página pronta
      };
    } else {
      throw Exception('Falha ao carregar a API de exercícios.');
    }
  }

  Future<List<Item>> buscarExercicios(String query) async {
    // Como a API é em inglês, traduzimos o termo digitado (ex: "Agachamento") para inglês ("Squat")
    final termoIngles = await _translator.translate(query, from: 'pt', to: 'en');
    
    final url = Uri.parse(
        'https://wger.de/api/v2/exerciseinfo/?language=2&limit=10&name=${termoIngles.text}');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List resultados = data['results'] ?? [];

      final List<Item> itens = [];

      for (var itemJson in resultados) {
        final int id = itemJson['id'] ?? 0;
        
        final String nomeIngles = itemJson['name'] ?? 'Unknown Exercise';
        final String descInglesRaw = itemJson['description'] ?? 'No description';
        final String descIngles = descInglesRaw.replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), '');

        final transNome = await _translator.translate(nomeIngles, from: 'en', to: 'pt');
        final transDesc = await _translator.translate(descIngles, from: 'en', to: 'pt');

        String imagemUrl = '';
        if (itemJson['images'] != null && (itemJson['images'] as List).isNotEmpty) {
          imagemUrl = itemJson['images'][0]['image'] ?? '';
        }

        itens.add(Item(
          id: id,
          nome: transNome.text,
          descricao: transDesc.text,
          urlimagem: imagemUrl,
        ));
      }

      return itens;
    } else {
      throw Exception('Falha ao buscar exercícios.');
    }
  }
}