// lib/widgets/custom_card_widget.dart
import 'package:flutter/material.dart';

class CustomCardWidget extends StatelessWidget {
  const CustomCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.deepPurple.shade100,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: const [
            Icon(Icons.lock_outline, size: 40, color: Colors.deepPurple),
            SizedBox(height: 10),
            Text(
              'Bem-vindo à sua agenda!',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text('Por favor, autentique-se para continuar.')
          ],
        ),
      ),
    );
  }
}
