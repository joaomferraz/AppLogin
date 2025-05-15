// lib/screens/splash_native.dart
import 'package:flutter/material.dart';
import 'splash_animated.dart';

class SplashNative extends StatefulWidget {
  const SplashNative({super.key});

  @override
  State<SplashNative> createState() => _SplashNativeState();
}

class _SplashNativeState extends State<SplashNative> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 100), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const SplashAnimated()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
    );
  }
}
