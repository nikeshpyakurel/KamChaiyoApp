import 'dart:async';
import 'package:flutter/material.dart';
import 'package:kamchaiyo/view/on_boarding_screen.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const OnboardingScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/animations/splash_screen.json',
              width: 300,
              height: 300,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 24),
            const Text(
              'KamChaiyo',
              style: TextStyle(
                fontFamily: 'Philosopher Bold',
                fontSize: 28,
                letterSpacing: 1.2,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Portal for Recruiters & Job Seekers',
              style: TextStyle(
                fontFamily: 'Nunito Regular',
                fontSize: 16,
                letterSpacing: 1.2,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
