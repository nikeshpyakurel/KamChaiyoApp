import 'package:flutter/material.dart';
import 'package:kamchaiyo/common/snake_bar.dart';
import 'package:lottie/lottie.dart';

class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({super.key});

  final TextEditingController _emailController = TextEditingController();

  void _sendResetLink(BuildContext context) {
    final email = _emailController.text.trim();
    if (email.isEmpty ||
        !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$').hasMatch(email)) {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text('Please enter a valid email')),
      // );
      showSnackBar(
        context: context,
        content: 'Please Enter a Valid Email',
        color: Colors.red,
      );
    } else {
      showSnackBar(
        context: context,
        content: 'Reset Link Sent to $email',
        color: Colors.green,
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Forgot Password")),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Lottie.asset(
                'assets/animations/forgot_screen.json',
                width: 300,
                height: 300,
                fit: BoxFit.contain,
              ),
            ),
            const Text(
              "Enter your email and we’ll send you a reset link.",
              style: TextStyle(
                fontFamily: 'Nunito Regular',
                fontSize: 16,
                letterSpacing: 1.2,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _sendResetLink(context),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Color.fromARGB(255, 127, 152, 243),
                  foregroundColor: Colors.white,
                ),
                child: const Text("Send Reset Link"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
