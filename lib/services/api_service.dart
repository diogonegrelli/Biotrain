import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/exercicio.dart';

class ApiService {


  Future<Map<String, dynamic>> buscarExercicios(String urlApi) async {
    final response = await http.get(Uri.parse(urlApi));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);

      final List<dynamic> resultadosBrutos = data['results'];
      List<Exercicio> listaExercicios = resultadosBrutos.map((json) {
        return Exercicio.fromJson(json);
      }).toList();

      return {
        'exercicios': listaExercicios,
        'next': data['next'],
      };
      
    } else {
      throw Exception('Falha ao carregar os exercícios');
    }
  }
}