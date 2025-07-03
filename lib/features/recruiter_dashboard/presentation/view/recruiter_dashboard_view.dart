import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kamchaiyo/features/auth/presentation/view/login_view.dart';
import 'package:kamchaiyo/features/auth/presentation/view_model/auth_view_model.dart';

class RecruiterDashboardView extends StatelessWidget {
  const RecruiterDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthViewModel>().state.user;
    return Scaffold(
      appBar: AppBar(
        title: Text("Recruiter Dashboard"),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              context.read<AuthViewModel>().add(LogoutRequested());
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const LoginView()), (route) => false);
            },
          ),
        ],
      ),
      body: Center(
        child: Text(
          "Welcome, Recruiter ${user?.fullName ?? ''}!",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}