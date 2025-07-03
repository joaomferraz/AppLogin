// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../theme/theme_controller.dart';
import 'login_screen.dart';
import 'welcome_feature_screen.dart';
import 'add_recurring_event_screen.dart';

class HomeScreen extends StatelessWidget {
  final UserModel user;

  const HomeScreen({super.key, required this.user});

  void _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('email_salvo');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  void _irParaAgenda(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => WelcomeFeatureScreen(user: user)),
    );
  }

  void _irParaAddEventoRecorrente(BuildContext context) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const AddRecurringEventScreen()),
    );
    if (result == true) {
      // Recarregar eventos ou notificar algo, se necessário
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tela Principal'),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: () => ThemeController().toggleTheme(),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.deepPurple,
              child: Text(
                user.email[0].toUpperCase(),
                style: const TextStyle(fontSize: 40, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Bem-vindo, ${user.name}!',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            IconButton(
              icon: const Icon(
                Icons.calendar_today,
                size: 50,
                color: Colors.blue,
              ),
              onPressed: () => _irParaAgenda(context),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text('Evento Recorrente'),
        onPressed: () => _irParaAddEventoRecorrente(context),
      ),
    );
  }
}
