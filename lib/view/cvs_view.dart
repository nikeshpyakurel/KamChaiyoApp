import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CvsView extends StatefulWidget {
  const CvsView({super.key});

  @override
  State<CvsView> createState() => _CvsViewState();
}

class _CvsViewState extends State<CvsView> {
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
              "CVS Coming Soon..",
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