import 'package:flutter/material.dart';
import '../models/exercicio.dart';
import '../models/grupo_muscular.dart';

class DetalhesItemScreen extends StatelessWidget {
  final Exercicio exercicio;

  const DetalhesItemScreen({super.key, required this.exercicio});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(exercicio.nome),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.cyanAccent, width: 2),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Image.network(
                    exercicio.urlimagem,
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
              const SizedBox(height: 24),
              const Text(
                'Grupos Musculares Trabalhados:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.cyanAccent,
                ),
              ),
              const SizedBox(height: 12),
              Chip(
                label: Text(
                  GrupoMuscular.obterNomes(exercicio.idGrupoMuscular),
                  style: const TextStyle(
                    color: Color(0xFF0A192F),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                backgroundColor: Colors.cyanAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                side: BorderSide.none,
              )
            ],
          ),
        ),
      ),
    );
  }
}