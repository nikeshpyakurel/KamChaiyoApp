import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kamchaiyo/features/auth/presentation/view/login_view.dart';
import 'package:kamchaiyo/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:kamchaiyo/features/home/presentation/view/home_view.dart';
import 'package:lottie/lottie.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthViewModel, AuthState>(
      listener: (context, state) {
        // Wait for the auth check to complete before navigating.
        // The initial AuthCheckRequested event is dispatched from main.dart.
        if (!state.isLoading) {
          Future.delayed(const Duration(seconds: 3), () {
            if (state.isAuthenticated) {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeView()));
            } else {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const LoginView()));
            }
          });
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset('assets/animations/splash_screen.json', width: 300, height: 300),
              const SizedBox(height: 24),
              const Text('KamChaiyo', style: TextStyle(fontFamily: 'Philosopher Bold', fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text('Portal for Recruiters & Job Seekers', style: TextStyle(fontSize: 16, color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }
}