import 'package:flutter/material.dart';
import 'package:somativo/models/exercicio.dart';
import 'package:somativo/services/api_service.dart';

class CatalogoProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  String? _proximaUrl;
  final List<Exercicio> _exercicios = [];
  List<Exercicio> _buscarExercicios = [];
  
  bool _isCarregando = false;
  bool _isCarregandoMais = false;
  bool _temErro = false;
  String _mensagemErro = '';

  List<Exercicio> get exercicios => _exercicios;
  List<Exercicio> get buscarExercicios => _buscarExercicios;
  bool get isCarregando => _isCarregando;
  bool get isCarregandoMais => _isCarregandoMais;
  bool get temErro => _temErro;
  String get mensagemErro => _mensagemErro;

  Future<void> carregarExercicios() async {
    if (_isCarregando || _isCarregandoMais || (_proximaUrl == null && _exercicios.isNotEmpty)) return;

    if (_exercicios.isEmpty) {
      _isCarregando = true;
    } else {
      _isCarregandoMais = true;
    }
    
    _temErro = false;
    notifyListeners(); 

    try {
      final dataResult = await _apiService.getExercicios(nextUrl: _proximaUrl);

      _exercicios.addAll(dataResult['exercicios'] as List<Exercicio>);
      _proximaUrl = dataResult['nextUrl'] as String?;
      _buscarExercicios = List.from(_exercicios);

    } catch (e) {
      _temErro = true;
      _mensagemErro = 'Erro ao carregar exercícios.';
    } finally {
      _isCarregando = false;
      _isCarregandoMais = false;
      notifyListeners();
    }
  }

  Future<void> buscarNaApi(String query) async {
    if (query.isEmpty) {
      atualizarBusca('');
      return;
    }

    _isCarregando = true;
    _temErro = false;
    notifyListeners();

    try {
      final resultados = await _apiService.buscarExercicios(query);
      _buscarExercicios = resultados;
    } catch (e) {
      _temErro = true;
      _mensagemErro = 'Erro ao buscar exercícios.';
    } finally {
      _isCarregando = false;
      notifyListeners();
    }
  }

  void atualizarBusca(String textoDigitado) {
    if (textoDigitado.isEmpty) {
      _buscarExercicios = List.from(_exercicios);
      _temErro = false;
      notifyListeners(); 
    }
  }
}