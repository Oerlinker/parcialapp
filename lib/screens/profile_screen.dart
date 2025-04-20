import 'package:flutter/material.dart';
import 'package:parcialapp/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().userData;

    final nombre = user?['nombre'] ?? '';
    final apellido = user?['apellido'] ?? '';
    final correo = user?['correo'] ?? '';

    return Scaffold(
      appBar: AppBar(title: const Text('Mi Perfil')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CircleAvatar(
              radius: 40,
              child: Icon(Icons.person, size: 40),
            ),
            const SizedBox(height: 16),
            Text('Nombre: $nombre', style: Theme.of(context).textTheme.titleMedium),
            Text('Apellido: $apellido', style: Theme.of(context).textTheme.titleMedium),
            Text('Correo: $correo', style: Theme.of(context).textTheme.titleMedium),
            const Divider(height: 32),
            ElevatedButton.icon(
              icon: const Icon(Icons.logout),
              label: const Text('Cerrar sesión'),
              onPressed: () async {
                await context.read<AuthProvider>().logout();
                if (context.mounted) {
                  Navigator.of(context).pushReplacementNamed('login');
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
            )
          ],
        ),
      ),
    );
  }
}
