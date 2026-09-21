import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/favoritos_provider.dart';
import '../widgets/exercicio_card.dart';

class FavoritosScreen extends StatelessWidget {
  const FavoritosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Favoritos'),
      ),
      body: Consumer<FavoritosProvider>(
        builder: (context, favoritosProvider, child) {
          if (favoritosProvider.favoritos.isEmpty) {
            return const Center(
              child: Text(
                'Nenhum item favoritado.',
                style: TextStyle(color: Colors.white70, fontSize: 18),
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(10),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.8,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: favoritosProvider.favoritos.length,
            itemBuilder: (context, index) {
              final exercicio = favoritosProvider.favoritos[index];
              return ExercicioCard(exercicio: exercicio);
            },
          );
        },
      ),
    );
  }
}