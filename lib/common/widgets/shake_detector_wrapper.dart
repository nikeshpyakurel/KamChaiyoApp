import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kamchaiyo/features/auth/presentation/view/login_view.dart';
import 'package:kamchaiyo/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:shake/shake.dart';

class ShakeDetectorWrapper extends StatefulWidget {
  final Widget child;
  const ShakeDetectorWrapper({super.key, required this.child});

  @override
  State<ShakeDetectorWrapper> createState() => _ShakeDetectorWrapperState();
}

class _ShakeDetectorWrapperState extends State<ShakeDetectorWrapper> {
  late ShakeDetector _detector;
  bool _isDialogShowing = false; // Guard to prevent multiple dialogs

  @override
  void initState() {
    super.initState();
    _detector = ShakeDetector.autoStart(
      // --- THIS IS THE FINAL, CORRECTED CODE ---
      // The callback now correctly accepts a `ShakeEvent` object.
      onPhoneShake: (ShakeEvent event) {
      // --- END OF CORRECTION ---

        final authState = context.read<AuthViewModel>().state;
        // Check if a user is logged in AND a dialog is not already showing
        if (authState.isAuthenticated && !_isDialogShowing) {
          setState(() {
            _isDialogShowing = true;
          });
          _showLogoutConfirmationDialog();
        }
      },
      shakeThresholdGravity: 1.5,
      // The `minimumShakeCount` parameter has been removed in recent versions of the package.
      // The detection is now based on the intensity and duration of the shake event itself.
    );
  }

  void _showLogoutConfirmationDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // User must tap a button to dismiss
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Confirm Logout'),
          content:
              const Text('Are you sure you want to log out from your account?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Logout'),
              onPressed: () {
                context.read<AuthViewModel>().add(LogoutRequested());
                Navigator.of(dialogContext).pop(); // Close the dialog
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginView()),
                  (route) => false,
                );
              },
            ),
          ],
        );
      },
    ).then((_) {
      // This `then` block executes after the dialog is closed.
      // We reset the guard flag here.
      if (mounted) {
        setState(() {
          _isDialogShowing = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _detector.stopListening();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}