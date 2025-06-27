import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Importando SharedPreferences
import '../onboarding/onboarding_screen.dart';
import 'login_screen.dart';

class SplashAnimated extends StatefulWidget {
  const SplashAnimated({super.key});

  @override
  State<SplashAnimated> createState() => _SplashAnimatedState();
}

class _SplashAnimatedState extends State<SplashAnimated> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);
    _controller.forward();

    //_clearFirstRunFlag();

    _checkFirstRun();
  }

  Future<void> _clearFirstRunFlag() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('isFirstRun'); // Remove a chave para simular a primeira execução
}

  // Função que verifica se é a primeira vez que o usuário abre o aplicativo
  Future<void> _checkFirstRun() async {
    final prefs = await SharedPreferences.getInstance();
    bool isFirstRun = prefs.getBool('isFirstRun') ?? true;

    if (isFirstRun) {
      // Se for a primeira execução, exibe o OnboardingScreen
      await prefs.setBool('isFirstRun', false); // Marca como já executado
      Timer(const Duration(seconds: 3), () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const OnboardingScreen()),
        );
      });
    } else {
      // Se não for a primeira execução, vai diretamente para a HomeScreen ou LoginScreen
      Timer(const Duration(seconds: 3), () {
        Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FadeTransition(
          opacity: _animation,
          child: Image.asset(
            'assets/logo.png',
            width: 150,
            height: 150,
          ),
        ),
      ),
    );
  }
}
