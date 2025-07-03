import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kamchaiyo/features/admin/presentation/view_model/admin_bloc.dart';

class ManageUsersView extends StatelessWidget {
  const ManageUsersView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminBloc, AdminState>(
      builder: (context, state) {
        if (state.status == AdminStatus.loading && state.users.isEmpty) return const Center(child: CircularProgressIndicator());
        if (state.status == AdminStatus.failure) return Center(child: Text('Error: ${state.error}'));
        if (state.users.isEmpty) return const Center(child: Text('No users found.'));
        
        return RefreshIndicator(
          onRefresh: () async { context.read<AdminBloc>().add(AdminDataFetched()); },
          child: ListView.builder(
            itemCount: state.users.length,
            itemBuilder: (context, index) {
              final user = state.users[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: ListTile(
                  leading: CircleAvatar(child: Text(user.fullName[0].toUpperCase())),
                  title: Text(user.fullName, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(user.email),
                  trailing: Chip(label: Text(user.role), backgroundColor: _getRoleColor(user.role), labelStyle: const TextStyle(color: Colors.white)),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Color _getRoleColor(String role) {
    switch (role) {
      case 'admin': return Colors.red.shade400;
      case 'recruiter': return Colors.blue.shade400;
      default: return Colors.green.shade400;
    }
  }
}