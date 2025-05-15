// lib/screens/welcome_feature_screen.dart
import 'package:flutter/material.dart';
import '../models/user_model.dart';

class WelcomeFeatureScreen extends StatelessWidget {
  final UserModel user;

  const WelcomeFeatureScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Boas Vindas'),
      ),
      body: Center(
        child: Text(
          'Olá ${user.email}, seja bem vindo ao app demonstrativo!',
          style: Theme.of(context).textTheme.headlineSmall,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
