import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kamchaiyo/app/service_locator/service_locator.dart';
import 'package:kamchaiyo/app_theme.dart';
import 'package:kamchaiyo/core/services/biometric_service.dart';
import 'package:local_auth/error_codes.dart' as auth_error;

import 'package:kamchaiyo/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:kamchaiyo/features/settings/presentation/view_model/settings_cubit.dart';
import 'package:kamchaiyo/features/settings/settings_injection_container.dart';
import 'package:kamchaiyo/features/splash/presentation/view/splash_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
    initSettingsInjection(sl); 

  await setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => sl<AuthViewModel>()..add(AuthCheckRequested()),
        ),
                BlocProvider(create: (_) => sl<SettingsCubit>()), 

      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'KamChaiyo',
        theme: AppTheme.getApplicationTheme(),
        // home: const SplashView(),
                home: const AuthGate(), 

      ),
    );
  }
}

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      _handleAppResume();
    }
  }

void _handleAppResume() async {
  final settingsState = context.read<SettingsCubit>().state;
  final authState = context.read<AuthViewModel>().state;

  if (settingsState.isBiometricEnabled && authState.isAuthenticated) {
    try {
      final isAuthenticated = await BiometricService.authenticate();
      if (!isAuthenticated) {
        context.read<AuthViewModel>().add(LogoutRequested());
      }
    } on PlatformException catch (e) {
      if (e.code == auth_error.notAvailable || e.code == auth_error.notEnrolled) {
        // Handle cases where biometrics are not set up or available
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Biometrics not set up on this device.")),
        );
      } else {
        // Handle other potential errors, or simply log out
        context.read<AuthViewModel>().add(LogoutRequested());
      }
    }
  }
  }

  @override
  Widget build(BuildContext context) {
    return const SplashView();
  }
}