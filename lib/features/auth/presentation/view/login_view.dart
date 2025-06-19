import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kamchaiyo/app/constant/theme_constant.dart';
import 'package:kamchaiyo/core/common/snackbar/my_snackbar.dart';
import 'package:kamchaiyo/features/auth/presentation/view/register_view.dart';
import 'package:kamchaiyo/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:kamchaiyo/features/home/presentation/view/home_view.dart';
import 'package:lottie/lottie.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _hidePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthViewModel>().add(LoginRequested(email: _emailController.text.trim(), password: _passwordController.text.trim()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthViewModel, AuthState>(
        listener: (context, state) {
          if (state.isAuthenticated) {
            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const HomeView()), (route) => false);
          } else if (state.error != null) {
            showSnackBar(context: context, message: state.error!, color: Colors.red);
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Lottie.asset('assets/animations/login_screen.json', width: 220, height: 220, fit: BoxFit.contain),
                  const SizedBox(height: 16),
                  const Text("Welcome to KamChaiyo!", style: TextStyle(fontFamily: 'Philosopher Bold', fontSize: 28, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text("Login to continue", style: TextStyle(fontFamily: 'Nunito Regular', fontSize: 16, color: Colors.grey)),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(labelText: "Email", prefixIcon: Icon(Icons.email)),
                    validator: (v) => (v == null || v.isEmpty) ? 'Please enter email' : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _hidePassword,
                    decoration: InputDecoration(
                      labelText: "Password",
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(icon: Icon(_hidePassword ? Icons.visibility_off : Icons.visibility), onPressed: () => setState(() => _hidePassword = !_hidePassword)),
                    ),
                    validator: (v) => (v == null || v.length < 6) ? 'Password must be 6 characters' : null,
                  ),
                  const SizedBox(height: 24),
                  BlocBuilder<AuthViewModel, AuthState>(
                    builder: (context, state) {
                      if (state.isLoading && !state.isAuthenticated) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return SizedBox(width: double.infinity, child: ElevatedButton(onPressed: _login, child: const Text("Login")));
                    },
                  ),
                  const SizedBox(height: 24),
                  const Row(
                    children: [
                      Expanded(child: Divider()),
                      Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: Text("Or continue with")),
                      Expanded(child: Divider()),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [_socialButton(FontAwesomeIcons.google, Colors.red), const SizedBox(width: 16), _socialButton(FontAwesomeIcons.facebookF, Colors.blue), const SizedBox(width: 16), _socialButton(FontAwesomeIcons.apple, Colors.black)]),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account? "),
                      GestureDetector(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterView())), child: const Text("Sign Up", style: TextStyle(color: ThemeConstant.primaryColor, fontWeight: FontWeight.bold))),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _socialButton(IconData icon, Color color) => GestureDetector(onTap: () {}, child: CircleAvatar(radius: 24, backgroundColor: color.withAlpha(25), child: Icon(icon, color: color, size: 20)));
}