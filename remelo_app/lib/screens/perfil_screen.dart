import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

import '../services/auth_service.dart'; // ✅ Asegúrate de que este archivo existe
import 'login_screen.dart';

class PerfilScreen extends StatefulWidget {
  const PerfilScreen({super.key});

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  String nombre = '';
  String correo = '';
  File? _fotoPerfil;

  @override
  void initState() {
    super.initState();
    cargarDatosUsuario();
  }

  Future<void> cargarDatosUsuario() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      nombre = prefs.getString('user_name') ?? '';
      correo = prefs.getString('user_email') ?? 'correo@remelo.com';
    });
  }

  Future<void> _guardarCambios() async {
    bool ok = await AuthService.actualizarPerfil(nombre, correo);

    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Datos actualizados en el servidor')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error al actualizar datos')),
      );
    }
  }

  Future<void> _seleccionarImagen() async {
    final picker = ImagePicker();
    final imagen = await picker.pickImage(source: ImageSource.gallery);
    if (imagen != null) {
      setState(() {
        _fotoPerfil = File(imagen.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const SizedBox(height: 40),
          GestureDetector(
            onTap: _seleccionarImagen,
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Colors.white24,
              backgroundImage:
                  _fotoPerfil != null ? FileImage(_fotoPerfil!) : null,
              child: _fotoPerfil == null
                  ? const Icon(Icons.person, size: 50, color: Colors.white)
                  : null,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Toca la imagen para cambiarla',
            style: TextStyle(color: Colors.white54, fontSize: 12),
          ),
          const SizedBox(height: 30),

          // Campo editable: Nombre
          TextFormField(
            initialValue: nombre,
            onChanged: (value) => nombre = value,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              labelText: 'Nombre',
              labelStyle: TextStyle(color: Colors.white54),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white38),
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Campo editable: Correo
          TextFormField(
            initialValue: correo,
            onChanged: (value) => correo = value,
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              labelText: 'Correo',
              labelStyle: TextStyle(color: Colors.white54),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white38),
              ),
            ),
          ),
          const SizedBox(height: 30),

          // Botón Guardar cambios
          ElevatedButton.icon(
            onPressed: _guardarCambios,
            icon: const Icon(Icons.save),
            label: const Text('Guardar cambios'),
          ),
          const SizedBox(height: 20),

          ListTile(
            leading: const Icon(Icons.edit, color: Colors.white),
            title: const Text('Editar perfil',
                style: TextStyle(color: Colors.white)),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.lock, color: Colors.white),
            title: const Text('Cambiar contraseña',
                style: TextStyle(color: Colors.white)),
            onTap: () {},
          ),
          const Divider(color: Colors.white24),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Cerrar sesión',
                style: TextStyle(color: Colors.red)),
            onTap: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.clear();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}
