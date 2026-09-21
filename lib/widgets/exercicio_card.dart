import 'package:flutter/material.dart';
import 'package:somativo/models/exercicio.dart';
import 'package:somativo/screens/detalhesitem_screen.dart';
import 'package:provider/provider.dart';
import '../providers/favoritos_provider.dart';

class ExercicioCard extends StatelessWidget {
  final Exercicio exercicio;

  const ExercicioCard({super.key, required this.exercicio});

   @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetalhesItemScreen(exercicio: exercicio),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF112240),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.cyanAccent, width: 1.5),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      exercicio.urlimagem,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.image_not_supported, color: Colors.cyanAccent, size: 50),
                    ),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: Consumer<FavoritosProvider>(
                        builder: (context, favoritosProvider, child) {
                          final isFavorito = favoritosProvider.isFavorito(exercicio);
                          return IconButton(
                            icon: Icon(
                              isFavorito ? Icons.favorite : Icons.favorite_border,
                              color: isFavorito ? Colors.red : Colors.cyanAccent,
                              size: 28,
                            ),
                            onPressed: () {
                              favoritosProvider.alternarFavorito(exercicio);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  exercicio.nome,
                  style: const TextStyle(
                    color: Colors.cyanAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}