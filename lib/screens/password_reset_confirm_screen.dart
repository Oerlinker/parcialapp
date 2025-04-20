import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class PasswordResetConfirmScreen extends StatefulWidget {
  final String uid;
  final String token;

  const PasswordResetConfirmScreen({
    super.key,
    required this.uid,
    required this.token,
  });

  @override
  State<PasswordResetConfirmScreen> createState() =>
      _PasswordResetConfirmScreenState();
}

class _PasswordResetConfirmScreenState
    extends State<PasswordResetConfirmScreen> {
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Nueva contraseña')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _passCtrl,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Nueva contraseña'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _confirmCtrl,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Confirmar contraseña',
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed:
                  auth.loading
                      ? null
                      : () async {
                        final ok = await auth.confirmPasswordReset(
                          uid: widget.uid,
                          token: widget.token,
                          newPassword: _passCtrl.text.trim(),
                          confirmPassword: _confirmCtrl.text.trim(),
                        );
                        if (ok) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Contraseña restablecida con éxito',
                              ),
                            ),
                          );
                          Navigator.pushReplacementNamed(context, 'login');
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                auth.error ?? 'Error al restablecer',
                              ),
                            ),
                          );
                        }
                      },
              child:
                  auth.loading
                      ? const CircularProgressIndicator()
                      : const Text('Cambiar contraseña'),
            ),
          ],
        ),
      ),
    );
  }
}
