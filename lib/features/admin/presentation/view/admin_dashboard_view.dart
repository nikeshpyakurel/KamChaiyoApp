import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kamchaiyo/features/admin/presentation/view/chatbot_settings_view.dart';
import 'package:kamchaiyo/features/admin/presentation/view/manage_companies_view.dart';
import 'package:kamchaiyo/features/admin/presentation/view/manage_users_view.dart';
import 'package:kamchaiyo/features/admin/presentation/view_model/admin_bloc.dart';
import 'package:kamchaiyo/app/service_locator/service_locator.dart';
import 'package:kamchaiyo/features/auth/presentation/view/login_view.dart';
import 'package:kamchaiyo/features/auth/presentation/view_model/auth_view_model.dart';

class AdminDashboardView extends StatefulWidget {
  const AdminDashboardView({super.key});
  @override
  State<AdminDashboardView> createState() => _AdminDashboardViewState();
}

class _AdminDashboardViewState extends State<AdminDashboardView> {
  int _currentIndex = 0;
  final List<Widget> _screens = [const ManageUsersView(), const ManageCompaniesView(), const ChatbotSettingsView()];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<AdminBloc>()..add(AdminDataFetched()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Admin Panel'),
          actions: [IconButton(icon: const Icon(Icons.logout), onPressed: () {
              context.read<AuthViewModel>().add(LogoutRequested());
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const LoginView()), (route) => false);
          })],
        ),
        body: IndexedStack(index: _currentIndex, children: _screens),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.people_outline), label: 'Users'),
            BottomNavigationBarItem(icon: Icon(Icons.business_outlined), label: 'Companies'),
            BottomNavigationBarItem(icon: Icon(Icons.smart_toy_outlined), label: 'Chatbot'),
          ],
        ),
      ),
    );
  }
}