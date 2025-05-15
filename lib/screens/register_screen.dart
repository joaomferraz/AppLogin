// lib/screens/register_screen.dart
import 'package:flutter/material.dart';
import '../widgets/login_text_form_field.dart';
import '../database/user_dao.dart';
import '../models/user_model.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();

  void _register() async {
    if (_formKey.currentState!.validate()) {
      final existingUser = await UserDao.getUserByEmail(_emailController.text);
      if (existingUser != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('E-mail já cadastrado')),
        );
        return;
      }
      final newUser = UserModel(
        email: _emailController.text,
        password: _senhaController.text,
      );
      await UserDao.insertUser(newUser);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Usuário registrado com sucesso!')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registrar Usuário')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              LoginTextFormField(
                controller: _emailController,
                label: 'E-mail',
                obscure: false,
                validator: (value) {
                  if (value == null || !value.contains('@')) {
                    return 'Informe um e-mail válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              LoginTextFormField(
                controller: _senhaController,
                label: 'Senha',
                obscure: true,
                validator: (value) {
                  if (value == null || value.length < 4) {
                    return 'A senha deve ter pelo menos 4 caracteres';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _register,
                child: const Text('Registrar'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
