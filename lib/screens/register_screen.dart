// lib/screens/register_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nombreCtrl = TextEditingController();
  final _apellidoCtrl = TextEditingController();
  final _correoCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _pass2Ctrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Crear Cuenta')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _nombreCtrl, decoration: const InputDecoration(labelText: 'Nombre')),
            TextField(controller: _apellidoCtrl, decoration: const InputDecoration(labelText: 'Apellido')),
            TextField(controller: _correoCtrl, decoration: const InputDecoration(labelText: 'Correo electrónico')),
            TextField(controller: _passCtrl, decoration: const InputDecoration(labelText: 'Contraseña'), obscureText: true),
            TextField(controller: _pass2Ctrl, decoration: const InputDecoration(labelText: 'Confirmar contraseña'), obscureText: true),
            const SizedBox(height: 16),
            auth.loading
                ? const CircularProgressIndicator()
                : ElevatedButton(
              onPressed: () async {
                await auth.register(
                  nombre: _nombreCtrl.text,
                  apellido: _apellidoCtrl.text,
                  correo: _correoCtrl.text,
                  password: _passCtrl.text,
                  passwordConfirm: _pass2Ctrl.text,
                );
                if (auth.error == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Registro exitoso')),
                  );
                  Navigator.pop(context);
                }
              },
              child: const Text('Registrarse'),
            ),
            if (auth.error != null) ...[
              const SizedBox(height: 8),
              Text(auth.error!, style: const TextStyle(color: Colors.red)),
            ],
            TextButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, 'login');
              },
              child: const Text('¿Ya tienes cuenta? Inicia sesión'),
            ),
          ],
        ),
      ),
    );
  }
}

