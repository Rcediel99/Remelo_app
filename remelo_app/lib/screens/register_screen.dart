import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'home_screen.dart'; // o la pantalla a mostrar tras registrar

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  String nombre = '';
  String correo = '';
  String contrasena = '';
  String confirmar = '';

  bool _loading = false;

  void _registrarUsuario() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    final success = await AuthService.register(
      name: nombre,
      email: correo,
      password: contrasena,
      confirmPassword: confirmar,
    );

    setState(() => _loading = false);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Registro exitoso')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('❌ Error al registrar. Intenta nuevamente.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(title: const Text('Crear cuenta')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 30),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Nombre', labelStyle: TextStyle(color: Colors.white)),
                style: const TextStyle(color: Colors.white),
                onChanged: (value) => nombre = value,
                validator: (value) => value == null || value.isEmpty ? 'Ingresa tu nombre' : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Correo', labelStyle: TextStyle(color: Colors.white)),
                style: const TextStyle(color: Colors.white),
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) => correo = value,
                validator: (value) => value == null || !value.contains('@') ? 'Correo no válido' : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Contraseña', labelStyle: TextStyle(color: Colors.white)),
                style: const TextStyle(color: Colors.white),
                obscureText: true,
                onChanged: (value) => contrasena = value,
                validator: (value) => value == null || value.length < 6 ? 'Mínimo 6 caracteres' : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Confirmar contraseña', labelStyle: TextStyle(color: Colors.white)),
                style: const TextStyle(color: Colors.white),
                obscureText: true,
                onChanged: (value) => confirmar = value,
                validator: (value) =>
                    value != contrasena ? 'Las contraseñas no coinciden' : null,
              ),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                onPressed: _loading ? null : _registrarUsuario,
                icon: _loading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Icon(Icons.person_add),
                label: const Text('Registrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
