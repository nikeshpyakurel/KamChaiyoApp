import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kamchaiyo/features/auth/presentation/view/login_view.dart';
import 'package:kamchaiyo/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:kamchaiyo/features/profile/presentation/view/profile_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthViewModel>().state.user;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(icon: const Icon(Icons.person), tooltip: 'Profile', onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfileView()))),
          IconButton(icon: const Icon(Icons.logout), tooltip: 'Logout', onPressed: () {
            context.read<AuthViewModel>().add(LogoutRequested());
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const LoginView()), (route) => false);
          }),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Hello, ${user?.fullName.split(' ')[0] ?? 'User'}!', style: const TextStyle(fontFamily: 'Philosopher Bold', fontSize: 28)),
              Text('You are logged in as a ${user?.role ?? 'user'}.'),            ],
          ),
        ),
      ),
    );
  }
}