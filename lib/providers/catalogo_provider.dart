import 'package:flutter/material.dart';
import 'package:somativo/models/item.dart';
import 'package:somativo/services/api_service.dart';

class CatalogoProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  String? _proximaUrl;
  final List<Item> _exercicios = [];
  List<Item> _buscarExercicios = [];
  
  bool _carregando = false;
  bool _carregandoMais = false;
  bool _erro = false;
  String _mensagemErro = '';

  List<Item> get exercicios => _exercicios;
  List<Item> get buscarExercicios => _buscarExercicios;
  bool get carregando => _carregando;
  bool get isCarregandoMais => _carregandoMais;
  bool get erro => _erro;
  String get mensagemErro => _mensagemErro;

  Future<void> carregarExercicios() async {
    if (_carregando || _carregandoMais || (_proximaUrl == null && _exercicios.isNotEmpty)) return;

    if (_exercicios.isEmpty) {
      _carregando = true;
    } else {
      _carregandoMais = true;
    }
    
    _erro = false;
    notifyListeners(); 

    try {
      final dataResult = await _apiService.getExercicios(nextUrl: _proximaUrl);

      _exercicios.addAll(dataResult['exercicios'] as List<Item>);
      _proximaUrl = dataResult['nextUrl'] as String?;
      _buscarExercicios = List.from(_exercicios);

    } catch (e) {
      _erro = true;
      _mensagemErro = 'Erro ao carregar exercícios.';
    } finally {
      _carregando = false;
      _carregandoMais = false;
      notifyListeners();
    }
  }

  Future<void> buscarNaApi(String query) async {
    if (query.isEmpty) {
      atualizarBusca('');
      return;
    }

    _carregando = true;
    _erro = false;
    notifyListeners();

    try {
      final List<Item> resultados = await _apiService.buscarExercicios(query);
      _buscarExercicios = resultados;
    } catch (e) {
      _erro = true;
      _mensagemErro = 'Erro ao buscar exercícios.';
    } finally {
      _carregando = false;
      notifyListeners();
    }
  }

  void atualizarBusca(String textoDigitado) {
    if (textoDigitado.isEmpty) {
      _buscarExercicios = List.from(_exercicios);
      _erro = false;
      notifyListeners(); 
    }
  }
}