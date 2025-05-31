import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class JobView extends StatefulWidget {
  const JobView({super.key});

  @override
  State<JobView> createState() => _JobViewState();
}

class _JobViewState extends State<JobView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Dashboard",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            letterSpacing: 1,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
        backgroundColor: Color.fromARGB(255, 127, 152, 243),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/animations/dashboard_screen.json',
              width: 220,
              height: 220,
              fit: BoxFit.contain,
            ),
            Text(
              "Jobs Coming Soon..",
              style: TextStyle(
                fontSize: 18,
                letterSpacing: 1,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}