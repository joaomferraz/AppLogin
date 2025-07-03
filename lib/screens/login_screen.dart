// lib/screens/login_screen.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/login_text_form_field.dart';
import '../widgets/custom_card_widget.dart';
import '../theme/theme_controller.dart';
import '../database/user_dao.dart';
import 'register_screen.dart';
import 'forgot_password_screen.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  bool _lembrarUsuario = false;
  final ThemeController _themeController = ThemeController();

  @override
  void initState() {
    super.initState();
    _carregarEmailSalvo();
  }

  void _carregarEmailSalvo() async {
    final prefs = await SharedPreferences.getInstance();
    final emailSalvo = prefs.getString('email_salvo');
    if (emailSalvo != null) {
      final user = await UserDao.getUserByEmail(emailSalvo);
      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => HomeScreen(user: user)),
        );
      }
    }
  }

  void _login() async {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text;
      final senha = _senhaController.text;
      final user = await UserDao.getUserByEmail(email);

      if (user == null || user.password != senha) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Credenciais inválidas')),
        );
        return;
      }

      if (_lembrarUsuario) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('email_salvo', user.email);
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomeScreen(user: user)),
      );
    }
  }

  void _goToRegister() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const RegisterScreen()),
    );
  }

  void _goToForgotPassword() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ForgotPasswordScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tela de Login'),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: () => _themeController.toggleTheme(),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const CustomCardWidget(),
              const SizedBox(height: 16),
              LoginTextFormField(
                controller: _emailController,
                label: 'E-mail',
                obscure: false,
                validator: (value) {
                  if (value == null || value.isEmpty || !value.contains('@')) {
                    return 'Informe um e-mail válido';
                  }
                  return null;
                },
              ),
              LoginTextFormField(
                controller: _senhaController,
                label: 'Senha',
                obscure: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe sua senha';
                  }
                  return null;
                },
              ),
              CheckboxListTile(
                title: const Text('Lembrar usuário'),
                value: _lembrarUsuario,
                onChanged: (value) => setState(() => _lembrarUsuario = value ?? false),
              ),
              ElevatedButton(
                onPressed: _login,
                child: const Text('Entrar'),
              ),
              TextButton(
                onPressed: _goToRegister,
                child: const Text('Registrar-se'),
              ),
              TextButton(
                onPressed: _goToForgotPassword,
                child: const Text('Esqueci minha senha'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
