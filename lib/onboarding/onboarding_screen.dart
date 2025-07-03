// lib/onboarding/onboarding_screen.dart
import 'package:flutter/material.dart';
import '../screens/login_screen.dart';
import '../theme/theme_controller.dart';
import '../generated/l10n/app_localizations.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;
  final ThemeController _themeController = ThemeController();

  void _nextPage() {
    if (_currentPage < 2) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final texts = [loc.onboard1, loc.onboard2, loc.onboard3];
    final images = [
      'assets/onboard1.png',
      'assets/onboard2.png',
      'assets/onboard3.png'
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bem-vindo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: () => _themeController.toggleTheme(),
          ),
        ],
      ),
      body: PageView.builder(
        controller: _controller,
        itemCount: texts.length,
        onPageChanged: (index) => setState(() => _currentPage = index),
        itemBuilder: (_, index) {
          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Image.asset(
                    images[index],
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),

                const SizedBox(height: 30),
                Text(
                  texts[index],
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: _nextPage,
                  child: Text(index == texts.length - 1
                      ? loc.welcome
                      : 'Próximo'),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
