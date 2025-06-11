import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/pedidos_screen.dart'; // ✅ Importación añadida
import 'theme/remelo_theme.dart';

void main() {
  runApp(const RemeloApp());
}

class RemeloApp extends StatelessWidget {
  const RemeloApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Remelo',
      theme: RemeloTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: '/', // Ruta inicial
      routes: {
        '/': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
        '/pedidos': (context) => const PedidosScreen(), // ✅ Nueva ruta
      },
    );
  }
}
