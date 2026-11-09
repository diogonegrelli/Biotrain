import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class ExecutadosProvider extends ChangeNotifier {
  List<String> _executadosIds = [];

  List<String> get executadosIds => _executadosIds;

  ExecutadosProvider() {
    _carregarExecutados();
  }

  Future<void> _carregarExecutados() async {
    final prefs = await SharedPreferences.getInstance();
    _executadosIds = prefs.getStringList('executados') ?? [];
    notifyListeners();
  }

  Future<void> toggleExecutado(String id) async {
    final prefs = await SharedPreferences.getInstance();
    if (_executadosIds.contains(id)) {
      _executadosIds.remove(id);
    } else {
      _executadosIds.add(id);
    }
    await prefs.setStringList('executados', _executadosIds);
    notifyListeners();
  }

  bool isExecutado(String id) {
    return _executadosIds.contains(id);
  }
}