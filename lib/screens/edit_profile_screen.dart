import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../database/user_dao.dart';

class EditProfileScreen extends StatefulWidget {
  final UserModel user;

  const EditProfileScreen({super.key, required this.user});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final TextEditingController _nameController;
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) {
      return; // Se o formulário não for válido, não faz nada.
    }

    // Pega os novos valores
    final newName = _nameController.text;
    final newPassword = _passwordController.text;

    // Se o usuário não digitou uma nova senha, mantém a antiga.
    final finalPassword = newPassword.isNotEmpty ? newPassword : widget.user.password;

    final updatedUser = UserModel(
      id: widget.user.id,
      email: widget.user.email, // Email permanece o mesmo
      name: newName,
      password: finalPassword,
    );

    await UserDao.updateUser(updatedUser);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Perfil atualizado com sucesso!')),
      );
      // Retorna o objeto de usuário atualizado para a tela anterior
      Navigator.pop(context, updatedUser);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Perfil'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Campo de email (não editável)
              TextFormField(
                initialValue: widget.user.email,
                decoration: const InputDecoration(
                  labelText: 'Email (não pode ser alterado)',
                  border: OutlineInputBorder(),
                  filled: true,
                ),
                readOnly: true,
              ),
              const SizedBox(height: 16),
              // Campo de nome
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nome',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira seu nome.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Campo de senha
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Nova Senha (deixe em branco para não alterar)',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 16),
              // Campo de confirmação de senha
              TextFormField(
                controller: _confirmPasswordController,
                decoration: const InputDecoration(
                  labelText: 'Confirmar Nova Senha',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (value) {
                  if (value != _passwordController.text) {
                    return 'As senhas não correspondem.';
                  }
                  return null;
                },
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: _saveProfile,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Salvar Alterações'),
              )
            ],
          ),
        ),
      ),
    );
  }
}