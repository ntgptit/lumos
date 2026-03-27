import 'package:flutter/material.dart';
import 'package:lumos/presentation/shared/screens/app_placeholder_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppPlaceholderScreen(
      title: 'Login',
      message: 'Login flow will be reconnected on the lower layers.',
    );
  }
}
