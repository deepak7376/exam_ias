import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart' show kIsWeb, debugPrint;
import 'dart:io' show Platform;
import '../core/constants/app_config.dart';

// Conditional import for web
import 'auth_service_web_stub.dart'
    if (dart.library.html) 'auth_service_web.dart' as web_utils;

/// Authentication Service using Supabase
class AuthService {
  final SupabaseClient _supabase = Supabase.instance.client;
  
  /// Get current user
  User? get currentUser => _supabase.auth.currentUser;
  
  /// Check if user is logged in
  bool get isLoggedIn => currentUser != null;
  
  /// Get current session
  Session? get session => _supabase.auth.currentSession;
  
  /// Sign in with Google
  Future<bool> signInWithGoogle() async {
    try {
      // Determine redirect URL based on platform
      // IMPORTANT: For web, redirectTo is where Supabase redirects AFTER processing OAuth
      // Google will redirect to Supabase callback, then Supabase redirects to redirectTo
      String? redirectUrl;
      LaunchMode launchMode;
      
      if (kIsWeb) {
        // For web, get current origin dynamically
        final origin = web_utils.getWebOrigin();
        redirectUrl = '$origin/auth/callback';
        launchMode = LaunchMode.inAppWebView; // For web, use same tab
      } else if (Platform.isAndroid) {
        // For Android, use deep link
        redirectUrl = AppConfig.androidRedirectUrl;
        launchMode = LaunchMode.externalApplication; // For mobile, use external browser
      } else if (Platform.isIOS) {
        // For iOS, use deep link
        redirectUrl = AppConfig.iosRedirectUrl;
        launchMode = LaunchMode.externalApplication; // For mobile, use external browser
      } else {
        // Fallback (shouldn't reach here)
        redirectUrl = '${AppConfig.supabaseUrl}/auth/v1/callback';
        launchMode = LaunchMode.externalApplication;
      }
      
      // Initiate OAuth flow
      // The redirectTo parameter tells Supabase where to redirect after OAuth completes
      // Google will redirect to: https://ocavzxqubkefmuvbtyeo.supabase.co/auth/v1/callback
      // Then Supabase will redirect to: redirectUrl (your app)
      final response = await _supabase.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: redirectUrl,
        authScreenLaunchMode: launchMode,
      );
      
      // The OAuth flow will:
      // - On web: Open in same tab, Google → Supabase → Your app
      // - On mobile: Open in external browser, Google → Supabase → Deep link → Your app
      return response;
    } catch (e) {
      throw Exception('Google Sign-In failed: $e');
    }
  }
  
  /// Sign out
  Future<void> signOut() async {
    try {
      // Clear the session
      final response = await _supabase.auth.signOut();
      // debugPrint('Sign out response: $response');
      
      // Verify sign out was successful
      if (_supabase.auth.currentSession != null) {
        // Force sign out if still has session
        await _supabase.auth.signOut();
      }
      
      debugPrint('User signed out successfully');
    } catch (e) {
      debugPrint('Sign out error: $e');
      // Try to force sign out anyway
      try {
        await _supabase.auth.signOut();
      } catch (_) {
        // Ignore secondary error
      }
      throw Exception('Sign out failed: $e');
    }
  }
  
  /// Listen to auth state changes
  Stream<AuthState> get authStateChanges => _supabase.auth.onAuthStateChange;
  
  /// Get user email
  String? get userEmail => currentUser?.email;
  
  /// Get user display name
  String? get userName => currentUser?.userMetadata?['full_name'] ?? 
                         currentUser?.userMetadata?['name'] ??
                         currentUser?.email?.split('@').first;
  
  /// Get user avatar URL
  String? get userAvatarUrl => currentUser?.userMetadata?['avatar_url'] ??
                              currentUser?.userMetadata?['picture'];
}

