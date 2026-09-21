import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/catalogo_provider.dart';
import 'providers/favoritos_provider.dart';
import 'screens/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:somativo/screens/catalogo_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
      
        ChangeNotifierProvider(
          create: (context) => CatalogoProvider(),
        ),
        
        ChangeNotifierProvider(
          create: (context) => FavoritosProvider(),
          lazy: false, 
        ),
      ],
      child: MaterialApp(
          title: 'BioTrain',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
          scaffoldBackgroundColor: const Color(0xFF0A192F),
            
          appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFF0A192F),
              foregroundColor: Colors.cyanAccent,
              elevation: 0,
            ),
            
          colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.cyanAccent,
              brightness: Brightness.dark,
            ),
          ),
          home: const AuthCheck(),


      ),
    );
  }
}





class AuthCheck extends StatefulWidget {
  const AuthCheck({super.key});

  @override
  State<AuthCheck> createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  @override
  void initState() {
    super.initState();
    _verificarLogin();
  }

  Future<void> _verificarLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final estaLogado = prefs.getBool('isLogado') ?? false;

    if (!mounted) return;

    if (estaLogado) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const CatalogoScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}