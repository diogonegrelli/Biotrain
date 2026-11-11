import 'package:flutter/material.dart';
import '../providers/catalogo_provider.dart';
import 'package:provider/provider.dart';
import 'package:somativo/widgets/exercicio_card.dart';
import 'favoritos_screen.dart';
import 'executados_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen.dart';

class CatalogoScreen extends StatefulWidget {
  const CatalogoScreen({super.key});

  @override
  State<CatalogoScreen> createState() => _CatalogoScreenState();
}

class _CatalogoScreenState extends State<CatalogoScreen> {
  final TextEditingController _buscaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
    Provider.of<CatalogoProvider>(context, listen: false).carregarExercicios();
  });
  }

  @override
  void dispose() {
    _buscaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catálogo de Exercícios'),
        actions: [
          Semantics(
            label: 'Favoritos',
            button: true,
            child: IconButton(
              icon: const Icon(Icons.favorite),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FavoritosScreen()),
                );
              },
            ),
          ),
          Semantics(
            label: 'Exercícios Concluídos',
            button: true,
            child: IconButton(
              icon: const Icon(Icons.task_alt),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ExecutadosScreen()),
                );
              },
            ),
          ),
          Semantics(
            label: 'Sair',
            button: true,
            child: IconButton(
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
          ),    
        ],
      ),
      body: Column(
        children: [
          TextField(
            controller: _buscaController,
            decoration: const InputDecoration(
              labelText: 'Buscar Exercício',
              prefixIcon: Icon(Icons.search),
            ),
            onSubmitted: (value) {
              Provider.of<CatalogoProvider>(context, listen: false).buscarNaApi(value);
            },
            onChanged: (value) {
              if (value.isEmpty) {
                Provider.of<CatalogoProvider>(context, listen: false).atualizarBusca(value);
              }
            },
          ),
          Expanded(
            child: Consumer<CatalogoProvider>(
              builder: (context, catalogoProvider, child) {
                if (catalogoProvider.erro) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.wifi_off, size: 48, color: Colors.redAccent),
                        const SizedBox(height: 16),
                        const Text(
                          'Erro de conexão com a API.',
                          style: TextStyle(color: Colors.redAccent),
                        ),
                        ElevatedButton(
                          onPressed: () => catalogoProvider.carregarExercicios(),
                          child: const Text('Tentar novamente'),
                        )
                      ],
                    ),
                  );
                }

                if (catalogoProvider.exercicios.isEmpty && catalogoProvider.carregando) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (catalogoProvider.exercicios.isEmpty) {
                  return const Center(
                    child: Text('Nenhum exercício encontrado.'),
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
                      return Center(
                        child: Semantics(
                          label: 'Carregar Mais',
                          button: true,
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
                            child: catalogoProvider.isCarregandoMais 
                                ? const CircularProgressIndicator(color: Colors.white) 
                                : const Text('Carregar Mais'),
                          ),
                        ),
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