import 'package:flutter/material.dart';
import '../models/item.dart';
import '../screens/detalhesitem_screen.dart';

class ExercicioCard extends StatelessWidget {
  final Item exercicio;

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
      child: Card(
        color: const Color(0xFF0A192F),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: const BorderSide(color: Colors.cyanAccent, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
                child: exercicio.urlimagem.isNotEmpty
                    ? Image.network(
                        exercicio.urlimagem,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => const Icon(
                          Icons.image_not_supported, 
                          size: 50, 
                          color: Colors.cyanAccent
                        ),
                      )
                    : const Icon(
                        Icons.image_not_supported, 
                        size: 50, 
                        color: Colors.cyanAccent
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                exercicio.nome,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}