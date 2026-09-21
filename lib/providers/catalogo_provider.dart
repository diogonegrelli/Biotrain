import 'package:flutter/material.dart';
import 'package:somativo/models/exercicio.dart';
import 'package:somativo/services/api_service.dart';

class CatalogoProvider extends ChangeNotifier {
 
  final ApiService _apiService = ApiService();

  final String urlPage1 = 'https://gist.githubusercontent.com/diogonegrelli/5571c157e577a5be32de2aa069379a30/raw/d72e619bf5753e034fe93c11de716ecf4d4a614a/treino_page1.json';
  
  String? _proximaUrl;

  final List<Exercicio> _exercicios = [];
  
  List<Exercicio> get exercicios => _exercicios;
  String _busca = '';

  void atualizarBusca(String textoDigitado) {
    _busca = textoDigitado;
    print('Provider recebeu o texto: $_busca');
    print('A lista filtrada tem: ${exercicios.length} itens.');
    notifyListeners(); 
  }

  List<Exercicio> get buscarExercicios {
    if (_busca.isEmpty) {
      return _exercicios;
    }
    return _exercicios.where((exercicio) {
      return exercicio.nome.toLowerCase().contains(_busca.toLowerCase());
    }).toList();
  }
  CatalogoProvider() {
    _proximaUrl = urlPage1;
  }

  Future<void> carregarExercicios() async {
    if (_proximaUrl == null) return; 

    try {
      final dataResult = await _apiService.buscarExercicios(_proximaUrl!);

      _exercicios.addAll(dataResult['exercicios']);

      _proximaUrl = dataResult['next'];

      notifyListeners(); 
      
    } catch (e) {
      print('Erro de conexão: $e');
    }
  }
}