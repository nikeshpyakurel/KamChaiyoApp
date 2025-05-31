import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Greeting
            Row(
              children: [
                const CircleAvatar(
                  radius: 32,
                  backgroundImage: AssetImage('assets/images/user.jpg'),

                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Hello, Harke!',style: TextStyle(
                fontFamily: 'Philosopher Bold',
                fontSize: 28,
                letterSpacing: 1.2,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),),
                    Text('Ready to find your next job?', style: TextStyle(fontSize: 14, color: Colors.grey)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
      
            // Search Bar
            TextField(
              decoration: InputDecoration(
                hintText: 'Search for jobs...',
                
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: const Color(0xFFF3F6FD),
              ),
            ),
            const SizedBox(height: 24),
      
            // Stats Cards
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _statCard('Applied Jobs', '12', Icons.work),
                _statCard('Tasks', '5', Icons.check_circle),
                _statCard('CVs', '3', Icons.description),
              ],
            ),
            const SizedBox(height: 24),
      
            // Reminder/Tip Banner
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFE8EDFB),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: const [
                  Icon(Icons.info_outline, size: 40, color: Color(0xFF7F98F3)),
                  SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      'Update your CV regularly to increase your chances of getting hired!',
                      style: TextStyle(
                fontFamily: 'Nunito Regular',
                fontSize: 16,
                letterSpacing: 1.2,
                
              ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
      
            // Quick Actions
            const Text(
              'Quick Actions',
              style: TextStyle(
                fontFamily: 'Nunito Regular',
                fontSize: 18,
                letterSpacing: 1.2,
                fontWeight: FontWeight.w600
                
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _dashboardButton(Icons.work, 'Jobs'),
                _dashboardButton(Icons.upload_file, 'Upload CV'),
                _dashboardButton(Icons.check, 'Tasks'),
                _dashboardButton(Icons.person, 'Profile'),
              ],
            ),
            const SizedBox(height: 24),
      
            // Latest Jobs
            const Text(
              'Latest Jobs',
              style: TextStyle(
                fontFamily: 'Nunito Regular',
                fontSize: 18,
                letterSpacing: 1.2,
                fontWeight: FontWeight.w600
                
              ),
            ),
            const SizedBox(height: 12),
            _jobTile('Flutter Developer', 'Digital Pravidhi Pvt. Ltd', 'Remote'),
            _jobTile('UI/UX Designer', 'Motion Lab Agency', 'On-site'),
          ],
        ),
      ),
    );
  }

  Widget _statCard(String title, String count, IconData icon) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFEDF0FC),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: const Color(0xFF7F98F3), size: 28),
            const SizedBox(height: 8),
            Text(count, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text(title, style: TextStyle(
                fontFamily: 'Nunito Regular',
                fontSize: 12,
                letterSpacing: 1.2,
                fontWeight: FontWeight.w600
                
              ),),
          ],
        ),
      ),
    );
  }

  Widget _dashboardButton(IconData icon, String label) {
    return Column(
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: const Color(0xFF7F98F3),
          child: Icon(icon, color: Colors.white, size: 24),
        ),
        const SizedBox(height: 8),
        Text(label, style: TextStyle(
                fontFamily: 'Nunito Regular',
                fontSize: 14,
                letterSpacing: 1.2,
                fontWeight: FontWeight.w400
                
              ),),
      ],
    );
  }

  Widget _jobTile(String title, String company, String location) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE3E7F7)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.work_outline, color: Color(0xFF7F98F3)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(
                fontFamily: 'Philosopher Bold',
                fontSize: 16,
                letterSpacing: 1.2,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),),
                Text('$company • $location', style: TextStyle(
                fontFamily: 'Nunito Regular',
                fontSize: 14,
                letterSpacing: 1,
              ),),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        ],
      ),
    );
  }
}
