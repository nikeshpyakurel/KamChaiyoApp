import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kamchaiyo/features/auth/presentation/view/login_view.dart';
import 'package:kamchaiyo/features/auth/presentation/view_model/auth_view_model.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthViewModel>().state.user;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () {
              context.read<AuthViewModel>().add(LogoutRequested());
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const LoginView()), (route) => false);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const CircleAvatar(radius: 32, backgroundImage: AssetImage('assets/images/user.jpg')),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Hello, ${user?.fullName.split(' ')[0] ?? 'User'}!', style: const TextStyle(fontFamily: 'Philosopher Bold', fontSize: 28, fontWeight: FontWeight.bold)),
                      const Text('Ready to find your next job?', style: TextStyle(fontSize: 14, color: Colors.grey)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),
              TextField(decoration: InputDecoration(hintText: 'Search for jobs...', prefixIcon: const Icon(Icons.search), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)), filled: true, fillColor: const Color(0xFFF3F6FD))),
              const SizedBox(height: 24),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [_statCard('Applied Jobs', '12', Icons.work), _statCard('Tasks', '5', Icons.check_circle), _statCard('CVs', '3', Icons.description)]),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: const Color(0xFFE8EDFB), borderRadius: BorderRadius.circular(16)),
                child: const Row(
                  children: [
                    Icon(Icons.info_outline, size: 40, color: Color(0xFF7F98F3)),
                    SizedBox(width: 16),
                    Expanded(child: Text('Update your CV regularly to increase your chances!', style: TextStyle(fontFamily: 'Nunito Regular', fontSize: 16))),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text('Quick Actions', style: TextStyle(fontFamily: 'Nunito Bold', fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [_dashboardButton(Icons.work, 'Jobs'), _dashboardButton(Icons.upload_file, 'Upload CV'), _dashboardButton(Icons.check, 'Tasks'), _dashboardButton(Icons.person, 'Profile')]),
              const SizedBox(height: 24),
              const Text('Latest Jobs', style: TextStyle(fontFamily: 'Nunito Bold', fontSize: 18, fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),
              _jobTile('Flutter Developer', 'Digital Pravidhi', 'Remote'),
              _jobTile('UI/UX Designer', 'Motion Lab', 'On-site'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statCard(String title, String count, IconData icon) => Expanded(child: Container(margin: const EdgeInsets.symmetric(horizontal: 4), padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: const Color(0xFFEDF0FC), borderRadius: BorderRadius.circular(12)), child: Column(children: [Icon(icon, color: const Color(0xFF7F98F3), size: 28), const SizedBox(height: 8), Text(count, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)), Text(title, style: const TextStyle(fontSize: 12))])));
  Widget _dashboardButton(IconData icon, String label) => Column(children: [CircleAvatar(radius: 28, backgroundColor: const Color(0xFF7F98F3), child: Icon(icon, color: Colors.white, size: 24)), const SizedBox(height: 8), Text(label, style: const TextStyle(fontSize: 14))]);
  Widget _jobTile(String title, String company, String location) => Container(margin: const EdgeInsets.symmetric(vertical: 6), padding: const EdgeInsets.all(12), decoration: BoxDecoration(border: Border.all(color: const Color(0xFFE3E7F7)), borderRadius: BorderRadius.circular(12)), child: Row(children: [const Icon(Icons.work_outline, color: Color(0xFF7F98F3)), const SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontFamily: 'Philosopher Bold', fontSize: 16, fontWeight: FontWeight.bold)), Text('$company • $location', style: const TextStyle(fontSize: 14))])), const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey)]));
}