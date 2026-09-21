import 'package:flutter/material.dart';
import '../models/exercicio.dart';
import '../services/storage_service.dart'; 

class FavoritosProvider extends ChangeNotifier {
  List<Exercicio> _favoritos = [];
  List<Exercicio> get favoritos => _favoritos;

  final StorageService _storageService = StorageService();

  FavoritosProvider() {
    _carregarFavoritos();
  }

  bool isFavorito(Exercicio exercicio) {
    return _favoritos.any((e) => e.id == exercicio.id);
  }

  void alternarFavorito(Exercicio exercicio) {
    if (isFavorito(exercicio)) {
      _favoritos.removeWhere((e) => e.id == exercicio.id);
    } else {
      _favoritos.add(exercicio);
    }
    
    notifyListeners();
    
    _storageService.salvarFavoritos(_favoritos);
  }
 
  Future<void> _carregarFavoritos() async {
    _favoritos = await _storageService.carregarFavoritos();
    
    notifyListeners();
  }
}