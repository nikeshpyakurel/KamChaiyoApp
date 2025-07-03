import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kamchaiyo/features/admin/presentation/view/admin_dashboard_view.dart';
import 'package:kamchaiyo/features/auth/domain/entity/user_entity.dart';
import 'package:kamchaiyo/features/auth/presentation/view/login_view.dart';
import 'package:kamchaiyo/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:kamchaiyo/features/profile/presentation/view/profile_view.dart';
import 'package:kamchaiyo/features/recruiter_dashboard/presentation/view/recruiter_dashboard_view.dart';
import 'package:lottie/lottie.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthViewModel, AuthState>(
      listener: (context, state) {
        if (!state.isLoading) {
          Future.delayed(const Duration(seconds: 2), () {
            if (state.isAuthenticated && state.user != null) {
              _navigateToDashboard(context, state.user!);
            } else {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginView()),
                (route) => false,
              );
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
              const Text(
                'KamChaiyo',
                style: TextStyle(fontFamily: 'Philosopher Bold', fontSize: 28, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToDashboard(BuildContext context, UserEntity user) {
    final Widget dashboard;
    switch (user.role) {
      case 'admin':
        dashboard = const AdminDashboardView();
        break;
      case 'recruiter':
        dashboard = const RecruiterDashboardView();
        break;
      case 'job_seeker':
      default:
        dashboard = const ProfileView();
        break;
    }
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => dashboard),
      (route) => false,
    );
  }
}