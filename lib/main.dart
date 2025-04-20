import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_links/app_links.dart';
import 'dart:async';

import 'providers/auth_provider.dart';
import 'providers/product_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/recommendation_provider.dart';

import 'screens/login_screen.dart';
import 'screens/main_screen.dart';
import 'screens/home_screen.dart';
import 'screens/product_list_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/password_reset_request_screen.dart';
import 'screens/password_reset_confirm_screen.dart';
import 'screens/register_screen.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => RecommendationProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final AppLinks _appLinks;
  bool _isLoading = true;
  bool _isAuthenticated = false;

  @override
  void initState() {
    super.initState();


    _appLinks = AppLinks();


    _appLinks.uriLinkStream.listen((Uri uri) {
      _handleUri(uri);
    });

    _checkInitialLink();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);


      await authProvider.checkAuthStatus();

      setState(() {
        _isAuthenticated = authProvider.isAuthenticated;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _checkInitialLink() async {
    try {
      final uri = await _appLinks.getInitialAppLink();
      if (uri != null) _handleUri(uri);
    } catch (e) {

    }
  }

  void _handleUri(Uri uri) {
    if (uri.pathSegments.length >= 4 &&
        uri.pathSegments[0] == 'api' &&
        uri.pathSegments[1] == 'reset-password-confirm') {
      final uid = uri.pathSegments[2];
      final token = uri.pathSegments[3];

      Navigator.of(navigatorKey.currentContext!).push(
        MaterialPageRoute(
          builder: (_) => PasswordResetConfirmScreen(uid: uid, token: token),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Smart Cart',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : (_isAuthenticated ? const MainScreen() : const LoginScreen()),
      routes: {
        'login': (_) => const LoginScreen(),
        'register': (_) => const RegisterScreen(),
        'main': (_) => const MainScreen(),
        'home': (_) => const HomeScreen(),
        'products': (_) => const ProductListScreen(),
        'cart': (_) => const CartScreen(),
        'profile': (_) => const ProfileScreen(),
        'password-reset': (_) => const PasswordResetRequestScreen(),
      },
    );
  }
}