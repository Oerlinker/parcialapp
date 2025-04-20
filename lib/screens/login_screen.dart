import 'package:flutter/material.dart';
      import 'package:provider/provider.dart';
      import '../providers/auth_provider.dart';

      class LoginScreen extends StatefulWidget {
        const LoginScreen({Key? key}) : super(key: key);

        @override
        State<LoginScreen> createState() => _LoginScreenState();
      }

      class _LoginScreenState extends State<LoginScreen> {
        final _userCtrl = TextEditingController();
        final _passCtrl = TextEditingController();
        bool _loading = false;
        String? _error;

        @override
        Widget build(BuildContext context) {
          return Scaffold(
            appBar: AppBar(title: const Text('Iniciar sesión')),
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                    controller: _userCtrl,
                    decoration: const InputDecoration(labelText: 'Correo'),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _passCtrl,
                    decoration: const InputDecoration(labelText: 'Contraseña'),
                    obscureText: true,
                  ),
                  if (_error != null) ...[
                    const SizedBox(height: 12),
                    Text(_error!, style: const TextStyle(color: Colors.red)),
                  ],
                  const SizedBox(height: 24),
                  _loading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: () async {
                            setState(() {
                              _loading = true;
                              _error = null;
                            });
                            try {
                              final success = await context.read<AuthProvider>().login(
                                _userCtrl.text.trim(),
                                _passCtrl.text.trim(),
                              );
                              if (success && context.mounted) {

                                Navigator.pushReplacementNamed(context, 'main');
                              } else if (context.mounted) {
                                setState(() {
                                  _error = 'Error al iniciar sesión';
                                  _loading = false;
                                });
                              }
                            } catch (e) {
                              if (context.mounted) {
                                setState(() {
                                  _error = e.toString();
                                  _loading = false;
                                });
                              }
                            }
                          },
                          child: const Text('Iniciar sesión'),
                        ),
                ],
              ),
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton(
                    child: const Text('¿Olvidaste tu contraseña?'),
                    onPressed: () {

                      Navigator.pushNamed(context, 'password-reset');
                    },
                  ),
                  TextButton(
                    child: const Text('¿No tienes cuenta? Regístrate'),
                    onPressed: () {
                      Navigator.pushNamed(context, 'register');
                    },
                  ),
                ],
              ),
            ),
          );
        }
      }