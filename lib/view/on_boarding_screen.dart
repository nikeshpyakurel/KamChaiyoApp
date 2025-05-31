import 'package:flutter/material.dart';
import 'package:kamchaiyo/view/login_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  bool isLastPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                isLastPage = index == 2;
              });
            },
            children: const [
              OnboardingPage(
                animationPath: 'assets/animations/splash_screen.json',
                title: 'Welcome to KamChaiyo!',
                subtitle: 'Find your next job or hire top talent with ease.',
              ),
              OnboardingPage(
                animationPath: 'assets/animations/dashboard_screen.json',
                title: 'Stay Organized',
                subtitle:
                    'Manage applications, job postings, and profiles in one place.',
              ),
              OnboardingPage(
                animationPath: 'assets/animations/login_screen.json',
                title: 'Achieve More',
                subtitle:
                    'Connect with opportunities and grow your career or business.',
              ),
            ],
          ),
          Positioned(
            top: 50,
            right: 20,
            child: Visibility(
              visible: !isLastPage,
              child: TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  );
                },
                child: const Text(
                  'Skip',
                  style: TextStyle(
                fontFamily: 'Nunito Regular',
                fontSize: 16,
                letterSpacing: 1.2,
                color: Color.fromARGB(255, 127, 152, 243),
              ),
                ),
              ),
            ),
          ),

          Positioned(
            bottom: 200,
            left: 0,
            right: 0,
            child: Center(
              child: SmoothPageIndicator(
                controller: _controller,
                count: 3,
                effect: WormEffect(
                  dotColor: Colors.grey.shade300,
                  activeDotColor: const Color.fromARGB(255, 127, 152, 243),
                  dotHeight: 12,
                  dotWidth: 12,
                ),
              ),
            ),
          ),

          Positioned(
            bottom: 100,
            left: 24,
            right: 24,
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (isLastPage) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                    );
                  } else {
                    _controller.nextPage(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 127, 152, 243),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  isLastPage ? "Get Started" : "Next",
                  style: TextStyle(
                fontFamily: 'Nunito Regular',
                fontSize: 16,
                letterSpacing: 1.2,
                color: Colors.white
              ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final String animationPath;
  final String title;
  final String subtitle;

  const OnboardingPage({
    super.key,
    required this.animationPath,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(animationPath, height: 280, fit: BoxFit.contain),
          const SizedBox(height: 32),
          Text(
            title,
            style: TextStyle(
                fontFamily: 'Philosopher Bold',
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            subtitle,
            style: TextStyle(
                fontFamily: 'Nunito Regular',
                fontSize: 16,
                color: Colors.grey,
              ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
