import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/exercicio.dart'; // Ajuste o caminho se necessário

class ApiService {
  static const String _baseUrl = 'https://wger.de/api/v2/exerciseinfo/?language=2';

  Future<Map<String, dynamic>> getExercicios({String? nextUrl}) async {
    final url = nextUrl != null ? Uri.parse(nextUrl) : Uri.parse(_baseUrl);
    
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      
      final List resultadosJson = data['results'];
      final List<Exercicio> exercicios = resultadosJson
          .map((json) => Exercicio.fromJson(json))
          .toList();

      return {
        'exercicios': exercicios,
        'nextUrl': data['next'],
      };
    } else {
      throw Exception('Falha ao carregar o catálogo de exercícios.');
    }
  }

  Future<List<Exercicio>> buscarExercicios(String query) async {
    final url = Uri.parse('$_baseUrl&name=$query');
    
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List resultadosJson = data['results'];
      
      return resultadosJson
          .map((json) => Exercicio.fromJson(json))
          .toList();
    } else {
      throw Exception('Falha ao buscar o exercício.');
    }
  }
}