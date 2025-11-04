import 'package:flutter/foundation.dart' show kDebugMode, kIsWeb;

/// App Configuration Constants
class AppConfig {
  // Supabase Configuration
  // Get these from your Supabase Dashboard → Project Settings → API
  static const String supabaseUrl = 'https://ocavzxqubkefmuvbtyeo.supabase.co';
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im9jYXZ6eHF1YmtlZm11dmJ0eWVvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjE0MjYzODUsImV4cCI6MjA3NzAwMjM4NX0.A8CtNYsn6sN3JPK895hjuod27S9l8VGSUaf2IjgESxw';
  
  // Backend API Configuration
  // Production backend URL (Railway deployment)
  static const String productionBackendUrl = 'https://examiasbackend-production.up.railway.app/api/v1';
  // Local development backend URL
  static const String developmentBackendUrl = 'http://localhost:8000/api/v1';
  
  // Get backend URL based on build mode
  // Uses production URL for release builds, localhost for debug builds
  static String get backendBaseUrl {
    if (kDebugMode) {
      // Development mode - use localhost
      return developmentBackendUrl;
    } else {
      // Release mode (Play Store builds) - use production URL
      return productionBackendUrl;
    }
  }
  
  // OAuth Redirect URLs
  // For Android (deep link) - matches package name in build.gradle
  static const String androidRedirectUrl = 'com.iastestseries.iaspilot://login-callback';
  // For iOS (deep link)
  static const String iosRedirectUrl = 'com.iastestseries.iaspilot://login-callback';
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
  static const String appName = 'IASPilot';
  static const String appVersion = '1.0.0';
}

