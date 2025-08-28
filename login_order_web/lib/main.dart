import 'package:flutter/material.dart';
import 'pages/login_page.dart';
import 'pages/order_page.dart';
import 'services/auth_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isChecking = true;
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    final AuthService authService = AuthService();
    final bool logged = await authService.isLoggedIn();
    if (!mounted) return;
    setState(() {
      _isChecking = false;
      _isLoggedIn = logged;
    });
  }

  void _handleLoggedIn() {
    setState(() {
      _isLoggedIn = true;
    });
  }

  void _handleLoggedOut() {
    setState(() {
      _isLoggedIn = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login + Order (Web)',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: _isChecking
          ? const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            )
          : (_isLoggedIn
              ? OrderPage(onLogout: _handleLoggedOut)
              : LoginPage(onLoggedIn: _handleLoggedIn)),
    );
  }
}
