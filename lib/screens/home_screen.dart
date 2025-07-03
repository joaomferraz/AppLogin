// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../theme/theme_controller.dart';
import 'add_recurring_event_screen.dart';
import 'edit_profile_screen.dart'; // Importa a nova tela
import 'login_screen.dart';
import 'welcome_feature_screen.dart';

// ✅ CONVERTIDO PARA STATEFULWIDGET
class HomeScreen extends StatefulWidget {
  final UserModel user;

  const HomeScreen({super.key, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // ✅ Variável de estado para o usuário
  late UserModel _currentUser;

  @override
  void initState() {
    super.initState();
    _currentUser = widget.user;
  }

  void _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('email_salvo');
    if (context.mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  void _irParaAgenda() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => WelcomeFeatureScreen(user: _currentUser)),
    );
  }

  void _irParaAddEventoRecorrente() async {
    await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const AddRecurringEventScreen()),
    );
  }

  // ✅ NOVA FUNÇÃO PARA NAVEGAR E ATUALIZAR O PERFIL
  void _irParaPerfil() async {
    final result = await Navigator.push<UserModel>(
      context,
      MaterialPageRoute(
        builder: (_) => EditProfileScreen(user: _currentUser),
      ),
    );

    // Se a tela de edição retornou um usuário atualizado,
    // atualizamos o estado para refletir a mudança na UI.
    if (result != null) {
      setState(() {
        _currentUser = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
            onPressed: _logout,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ✅ WIDGET DE SAUDAÇÃO AGORA É CLICÁVEL
            InkWell(
              onTap: _irParaPerfil,
              customBorder: const CircleBorder(),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: theme.colorScheme.primary,
                      child: Text(
                        _currentUser.name.isNotEmpty ? _currentUser.name[0].toUpperCase() : 'U',
                        style: TextStyle(fontSize: 50, color: theme.colorScheme.onPrimary),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Bem-vindo, ${_currentUser.name}!',
                      style: theme.textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _FeatureButton(
                  label: 'Agenda',
                  icon: Icons.calendar_month,
                  onTap: _irParaAgenda,
                ),
                _FeatureButton(
                  label: 'Novo Evento Recorrente',
                  icon: Icons.add_task,
                  onTap: _irParaAddEventoRecorrente,
                ),
              ],
            ),
            const Spacer(),
            const Text(
              'Versão 1.0.0',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _FeatureButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _FeatureButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: 140,
      height: 120,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.primaryContainer,
          foregroundColor: theme.colorScheme.onPrimaryContainer,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}