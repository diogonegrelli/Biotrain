import 'package:flutter/material.dart';
import '../providers/catalogo_provider.dart';
import 'package:provider/provider.dart';
import 'package:somativo/widgets/exercicio_card.dart';
import 'favoritos_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen.dart';

class CatalogoScreen extends StatefulWidget {
  const CatalogoScreen({super.key});

  @override
  State<CatalogoScreen> createState() => _CatalogoScreenState();
}

class _CatalogoScreenState extends State<CatalogoScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<CatalogoProvider>(context, listen: false).carregarExercicios();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catálogo de Exercícios'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.favorite),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const FavoritosScreen()),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.logout, color: Colors.cyanAccent),
                  onPressed: () async {
                    final prefs = await SharedPreferences.getInstance();
                    
                    await prefs.setBool('isLogado', false);
                    
                    if (context.mounted) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginScreen()),
                      );
                    }
                  },
                ),    
              ],
      ),
      body: Column(
        children: [
          TextField(
            decoration: const InputDecoration(
              labelText: 'Buscar Exercício',
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: (value) {
              Provider.of<CatalogoProvider>(context, listen: false).atualizarBusca(value);
            },
          ),
          Expanded(
            child: Consumer<CatalogoProvider>(
              builder: (context, catalogoProvider, child) {
                if (catalogoProvider.exercicios.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return GridView.builder(
                  padding: const EdgeInsets.all(10),

                  itemCount: catalogoProvider.buscarExercicios.length + 1,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.75,
                  ),

                  itemBuilder: (context, index) {
                    if (index == catalogoProvider.buscarExercicios.length) {
                      // Último item: botão de carregar mais
                      return Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(8.0),
                            backgroundColor: const Color.fromARGB(255, 0, 15, 68),
                            textStyle: const TextStyle(color: Colors.white),

                        ),
                        onPressed: () {
                          catalogoProvider.carregarExercicios();
                          if (catalogoProvider.exercicios.length == catalogoProvider.buscarExercicios.length){
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Você visualizou todos os exercícios disponíveis.')),
                            );
                          }
                        },
                        child: const Text('Carregar Mais'),
                        )
                      );  
                    }

                    final exercicio = catalogoProvider.buscarExercicios[index];
                    return ExercicioCard(exercicio: exercicio);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  } 
}