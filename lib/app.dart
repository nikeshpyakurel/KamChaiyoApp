import 'package:flutter/material.dart';
import 'package:kamchaiyo/theme/my_theme.dart';
import 'package:kamchaiyo/view/splash_Screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: getApplicationTheme(),
      home: const SplashScreen(),
    );
  }
}
