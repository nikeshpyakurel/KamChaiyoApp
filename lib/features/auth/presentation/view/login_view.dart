import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kamchaiyo/app/constant/theme_constant.dart';
import 'package:kamchaiyo/common/snake_bar.dart';
import 'package:kamchaiyo/features/admin/presentation/view/admin_dashboard_view.dart';
import 'package:kamchaiyo/features/auth/presentation/view/register_view.dart';
import 'package:kamchaiyo/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:kamchaiyo/features/home/presentation/view/home_view.dart';
import 'package:kamchaiyo/features/recruiter_dashboard/presentation/view/recruiter_dashboard_view.dart';
import 'package:lottie/lottie.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthViewModel, AuthState>(
      listener: (context, state) {
        if (state.isAuthenticated && state.user != null) {
          switch (state.user!.role) {
            case 'admin':
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const AdminDashboardView()), (route) => false);
              break;
            case 'recruiter':
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const RecruiterDashboardView()), (route) => false);
              break;
            case 'student':
            default:
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const HomeView()), (route) => false);
              break;
          }
        } else if (state.error != null) {
          showSnackBar(context: context, content: state.error!, color: ThemeConstant.errorColor);
        }
      },
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            toolbarHeight: 0,
            bottom: const TabBar(
              labelColor: Colors.white,
              tabs: [
                Tab(text: "User", icon: Icon(Icons.people_alt_outlined,color: Colors.white,)),
                Tab(text: "Admin", icon: Icon(Icons.admin_panel_settings_outlined,color: Colors.white,)),
              ],
            ),
          ),
          body: const TabBarView(
            children: [
              _UserLoginForm(), 
              _AdminLoginForm(),  
            ],
          ),
        ),
      ),
    );
  }
}

class _AdminLoginForm extends StatefulWidget {
  const _AdminLoginForm();
  @override
  State<_AdminLoginForm> createState() => __AdminLoginFormState();
}

class __AdminLoginFormState extends State<_AdminLoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _login() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthViewModel>().add(LoginRequested(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
            role: 'admin',
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Lottie.asset('assets/animations/login_screen.json', height: 200),
            const Text("Admin Portal", style: TextStyle(fontFamily: 'Philosopher Bold', fontSize: 28)),
            const SizedBox(height: 24),
            TextFormField(controller: _emailController, decoration: const InputDecoration(labelText: "Admin Email", prefixIcon: Icon(Icons.email)), validator: (v) => (v!.isEmpty) ? 'Please enter email' : null),
            const SizedBox(height: 16),
            TextFormField(controller: _passwordController, obscureText: true, decoration: const InputDecoration(labelText: "Password", prefixIcon: Icon(Icons.lock)), validator: (v) => (v!.isEmpty) ? 'Please enter password' : null),
            const SizedBox(height: 24),
            BlocBuilder<AuthViewModel, AuthState>(
              builder: (context, state) {
                if (state.isLoading) return const CircularProgressIndicator();
                return SizedBox(width: double.infinity, child: ElevatedButton(onPressed: _login, child: const Text("Login as Admin")));
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _UserLoginForm extends StatefulWidget {
  const _UserLoginForm();
  @override
  State<_UserLoginForm> createState() => __UserLoginFormState();
}

class __UserLoginFormState extends State<_UserLoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _selectedRole = 'student';

  void _login() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthViewModel>().add(LoginRequested(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
            role: _selectedRole,
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            const SizedBox(height: 24),
            Lottie.asset('assets/animations/login_screen.json', height: 200),
            const Text("Welcome Back!", style: TextStyle(fontFamily: 'Philosopher Bold', fontSize: 28)),
            const SizedBox(height: 8),
            const Text("Login to continue your journey", style: TextStyle(fontSize: 16, color: Colors.grey)),
            const SizedBox(height: 24),
            SegmentedButton<String>(
              segments: const [ButtonSegment<String>(value: 'student', label: Text('Job Seeker'), icon: Icon(Icons.person_search)), ButtonSegment<String>(value: 'recruiter', label: Text('Recruiter'), icon: Icon(Icons.business_center))],
              selected: {_selectedRole},
              onSelectionChanged: (newSelection) => setState(() => _selectedRole = newSelection.first),
            ),
            const SizedBox(height: 24),
            TextFormField(controller: _emailController, decoration: const InputDecoration(labelText: "Email", prefixIcon: Icon(Icons.email)), validator: (v) => (v!.isEmpty) ? 'Please enter email' : null),
            const SizedBox(height: 16),
            TextFormField(controller: _passwordController, obscureText: true, decoration: const InputDecoration(labelText: "Password", prefixIcon: Icon(Icons.lock)), validator: (v) => (v!.isEmpty) ? 'Please enter password' : null),
            const SizedBox(height: 24),
            BlocBuilder<AuthViewModel, AuthState>(
              builder: (context, state) {
                if (state.isLoading) return const CircularProgressIndicator();
                return SizedBox(width: double.infinity, child: ElevatedButton(onPressed: _login, child: const Text("Login")));
              },
            ),
            const SizedBox(height: 24),
            const Row(children: [Expanded(child: Divider()), Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: Text("Or with")), Expanded(child: Divider())]),
            const SizedBox(height: 16),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [_socialButton(FontAwesomeIcons.google, Colors.red), const SizedBox(width: 16), _socialButton(FontAwesomeIcons.facebookF, Colors.blue)]),
            const SizedBox(height: 24),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [const Text("Don't have an account? "), GestureDetector(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RegisterView())), child: const Text("Sign Up", style: TextStyle(color: ThemeConstant.primaryColor, fontWeight: FontWeight.bold)))])
          ],
        ),
      ),
    );
  }

  Widget _socialButton(IconData icon, Color color) => CircleAvatar(radius: 24, backgroundColor: color.withAlpha(25), child: Icon(icon, color: color, size: 20));
}