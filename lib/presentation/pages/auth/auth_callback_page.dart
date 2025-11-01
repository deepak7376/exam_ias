import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/routes/app_router.dart';
import '../../../core/constants/app_colors.dart';

/// Page to handle OAuth callback after Google Sign-In
/// This page is shown briefly while processing the auth callback
class AuthCallbackPage extends StatefulWidget {
  const AuthCallbackPage({super.key});

  @override
  State<AuthCallbackPage> createState() => _AuthCallbackPageState();
}

class _AuthCallbackPageState extends State<AuthCallbackPage> {
  bool _isProcessing = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _handleAuthCallback();
  }

  Future<void> _handleAuthCallback() async {
    try {
      // Wait a bit for Supabase to process the callback
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Check if user is authenticated
      final session = Supabase.instance.client.auth.currentSession;
      
      if (session != null) {
        // Successfully authenticated
        if (mounted) {
          setState(() {
            _isProcessing = false;
          });
          // Navigate to home page
          context.go(AppRouter.home);
        }
      } else {
        // No session found, might still be processing
        await Future.delayed(const Duration(seconds: 1));
        final newSession = Supabase.instance.client.auth.currentSession;
        
        if (newSession != null) {
          if (mounted) {
            setState(() {
              _isProcessing = false;
            });
            context.go(AppRouter.home);
          }
        } else {
          // Failed to authenticate
          if (mounted) {
            setState(() {
              _isProcessing = false;
              _error = 'Authentication failed. Please try again.';
            });
            
            // Navigate back to login after a delay
            Future.delayed(const Duration(seconds: 2), () {
              if (mounted) {
                context.go(AppRouter.login);
              }
            });
          }
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isProcessing = false;
          _error = 'Error: ${e.toString()}';
        });
        
        // Navigate back to login after a delay
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            context.go(AppRouter.login);
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isProcessing) ...[
              const CircularProgressIndicator(),
              const SizedBox(height: 24),
              Text(
                'Signing you in...',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
            ] else if (_error != null) ...[
              Icon(
                Icons.error_outline,
                size: 64,
                color: AppColors.error,
              ),
              const SizedBox(height: 24),
              Text(
                _error!,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.error,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Redirecting to login...',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textTertiary,
                    ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

