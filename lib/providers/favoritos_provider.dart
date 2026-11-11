import 'package:flutter/material.dart';
import '../models/item.dart';
import '../services/storage_service.dart'; 

class FavoritosProvider extends ChangeNotifier {
  List<Item> _favoritos = [];
  List<Item> get favoritos => _favoritos;

  final StorageService _storageService = StorageService();

  FavoritosProvider() {
    _carregarFavoritos();
  }

  bool isFavorito(Item item) {
    return _favoritos.any((e) => e.id == item.id);
  }

  void alternarFavorito(Item item) {
    if (isFavorito(item)) {
      _favoritos.removeWhere((e) => e.id == item.id);
    } else {
      _favoritos.add(item);
    }
    
    notifyListeners();
    
    _storageService.salvarFavoritos(_favoritos);
  }
 
  Future<void> _carregarFavoritos() async {
    _favoritos = await _storageService.carregarFavoritos();
    
    notifyListeners();
  }
}