import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kamchaiyo/common/snake_bar.dart';
import 'package:kamchaiyo/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:lottie/lottie.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});
  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _hidePassword = true;
  String _selectedRole = 'job_seeker';

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _signup() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthViewModel>().add(SignupRequested(fullName: _fullNameController.text.trim(), email: _emailController.text.trim(), phone: _phoneController.text.trim(), password: _passwordController.text.trim(), role: _selectedRole));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create Account")),
      body: BlocListener<AuthViewModel, AuthState>(
        listener: (context, state) {
          if (state.signupSuccess) {
            showSnackBar(context: context, content: "Account created! Please login.", color: Colors.green);
            Navigator.pop(context);
          } else if (state.error != null) {
            showSnackBar(context: context, content: state.error!, color: Colors.red);
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const Text("I am a...", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  SegmentedButton<String>(
                    segments: const [ButtonSegment<String>(value: 'job_seeker', label: Text('Job Seeker'), icon: Icon(Icons.person_search)), ButtonSegment<String>(value: 'recruiter', label: Text('Recruiter'), icon: Icon(Icons.business_center))],
                    selected: {_selectedRole},
                    onSelectionChanged: (newSelection) => setState(() => _selectedRole = newSelection.first),
                  ),
                  const SizedBox(height: 24),
                  TextFormField(controller: _fullNameController, decoration: const InputDecoration(labelText: "Full Name", prefixIcon: Icon(Icons.person)), validator: (v) => (v!.isEmpty) ? 'Enter your full name' : null),
                  const SizedBox(height: 16),
                  TextFormField(controller: _emailController, keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(labelText: "Email", prefixIcon: Icon(Icons.email)), validator: (v) => (v!.isEmpty || !v.contains('@')) ? 'Enter a valid email' : null),
                  const SizedBox(height: 16),
                  TextFormField(controller: _phoneController, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: "Phone Number", prefixIcon: Icon(Icons.phone)), validator: (v) => (v!.length < 10) ? 'Enter a valid 10-digit number' : null),
                  const SizedBox(height: 16),
                  TextFormField(controller: _passwordController, obscureText: _hidePassword, decoration: InputDecoration(labelText: "Password", prefixIcon: const Icon(Icons.lock), suffixIcon: IconButton(icon: Icon(_hidePassword ? Icons.visibility_off : Icons.visibility), onPressed: () => setState(() => _hidePassword = !_hidePassword))), validator: (v) => (v!.length < 6) ? 'Password must be 6 characters' : null),
                  const SizedBox(height: 16),
                  TextFormField(controller: _confirmPasswordController, obscureText: true, decoration: const InputDecoration(labelText: "Confirm Password", prefixIcon: Icon(Icons.lock_outline)), validator: (v) => (v != _passwordController.text) ? 'Passwords do not match' : null),
                  const SizedBox(height: 24),
                  BlocBuilder<AuthViewModel, AuthState>(
                    builder: (context, state) {
                      if (state.isLoading && !state.signupSuccess) { return const Center(child: CircularProgressIndicator()); }
                      return SizedBox(width: double.infinity, child: ElevatedButton(onPressed: _signup, child: const Text("Sign Up")));
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}