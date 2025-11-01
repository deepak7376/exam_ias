import 'package:flutter/foundation.dart' show kIsWeb;

/// App Configuration Constants
class AppConfig {
  // Supabase Configuration
  // Get these from your Supabase Dashboard → Project Settings → API
  static const String supabaseUrl = 'https://ocavzxqubkefmuvbtyeo.supabase.co';
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9jYXZ6eHF1YmtlZm11dmJ0eWVvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjE0MjYzODUsImV4cCI6MjA3NzAwMjM4NX0.A8CtNYsn6sN3JPK895hjuod27S9l8VGSUaf2IjgESxw';
  
  // OAuth Redirect URLs
  // For Android (deep link)
  static const String androidRedirectUrl = 'com.example.exam_ias://login-callback';
  // For iOS (deep link)
  static const String iosRedirectUrl = 'com.example.examIas://login-callback';
  // For Web - dynamically get current origin
  static String get webRedirectUrl {
    if (kIsWeb) {
      // Use conditional import to get window.location for web
      // For web, this will be set dynamically by auth_service
      // Default fallback for web development
      return 'http://localhost:3000/auth/callback';
    }
    return '${supabaseUrl}/auth/v1/callback';
  }
  
  // App Information
  static const String appName = 'IAS Test Series';
  static const String appVersion = '1.0.0';
}

