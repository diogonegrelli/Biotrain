import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/exercicio.dart';
import '../providers/favoritos_provider.dart';
import '../providers/executados_provider.dart';

class DetalhesItemScreen extends StatelessWidget {
  final Exercicio exercicio;

  const DetalhesItemScreen({super.key, required this.exercicio});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(exercicio.nome),
        actions: [
          Consumer<FavoritosProvider>(
            builder: (context, favoritosProvider, child) {
              final isFav = favoritosProvider.isFavorito(exercicio);
              return Semantics(
                label: isFav ? 'Remover dos favoritos' : 'Adicionar aos favoritos',
                button: true,
                child: IconButton(
                  icon: Icon(
                    isFav ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                  ),
                  onPressed: () {
                    favoritosProvider.alternarFavorito(exercicio);
                  },
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Semantics(
                image: true,
                label: 'Imagem demonstrativa do exercício',
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.cyanAccent, width: 2),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Image.network(
                      exercicio.imagemUrl ?? '',
                      height: 350,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => const SizedBox(
                        height: 350,
                        child: Center(
                          child: Icon(Icons.image_not_supported, color: Colors.cyanAccent, size: 50),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                exercicio.nome,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.cyanAccent,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                exercicio.descricao,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                  height: 1.5,
                ),
              ),
              
              const SizedBox(height: 32),
              Consumer<ExecutadosProvider>(
                builder: (context, executadosProvider, child) {
                  final isExecutado = executadosProvider.isExecutado(exercicio.id.toString());
                  return Semantics(
                    label: isExecutado ? 'Desmarcar como executado' : 'Marcar como executado',
                    button: true,
                    child: SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isExecutado ? Colors.greenAccent : Colors.cyanAccent,
                          foregroundColor: const Color(0xFF0A192F),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: Icon(
                          isExecutado ? Icons.check_circle : Icons.play_circle_fill,
                          size: 28,
                        ),
                        label: Text(
                          isExecutado ? 'Treino Executado' : 'Marcar como Executado',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () {
                          executadosProvider.alternarExecutado(exercicio.id.toString());
                        },
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}