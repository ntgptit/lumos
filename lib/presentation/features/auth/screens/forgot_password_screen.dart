import 'package:flutter/material.dart';
import 'package:lumos/presentation/shared/screens/lumos_placeholder_screen.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const LumosPlaceholderScreen(
      title: 'Forgot Password',
      message: 'Password recovery flow has not been wired back yet.',
    );
  }
}
