import 'package:flutter/material.dart';
import '../providers/catalogo_provider.dart';
import 'package:provider/provider.dart';
import 'package:somativo/widgets/exercicio_card.dart';
import 'package:somativo/providers/executados_provider.dart';

class ExecutadosScreen extends StatelessWidget {
  const ExecutadosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Exercícios Concluídos')),
      body: Consumer2<ExecutadosProvider, CatalogoProvider>(
        builder: (context, executados, catalogo, child) {
          final lista = catalogo.exercicios
              .where((e) => executados.isExecutado(e.id.toString()))
              .toList();

          if (lista.isEmpty) {
            return const Center(
              child: Text(
                'Nenhum exercício concluído.',
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
            itemCount: lista.length,
            itemBuilder: (context, index) => ExercicioCard(exercicio: lista[index]),
          );
        },
      ),
    );
  }
}