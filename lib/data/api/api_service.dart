import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/constants/app_config.dart';

/// Base API service for making HTTP requests to the backend
class ApiService {
  // Backend URL is configured in AppConfig
  // Automatically uses production URL for release builds
  // and localhost for debug builds
  static String get baseUrl => AppConfig.backendBaseUrl;
  static const Duration timeout = Duration(seconds: 30);
  
  /// Get Supabase client instance
  SupabaseClient get _supabase => Supabase.instance.client;
  
  /// Get current session token
  String? _getAuthToken() {
    final session = _supabase.auth.currentSession;
    return session?.accessToken;
  }

  /// Generic GET request
  Future<Map<String, dynamic>> get(
    String endpoint, {
    Map<String, String>? queryParams,
  }) async {
    try {
      Uri uri = Uri.parse('$baseUrl$endpoint');
      if (queryParams != null && queryParams.isNotEmpty) {
        uri = uri.replace(queryParameters: queryParams);
      }

      final response = await http
          .get(uri, headers: _getHeaders())
          .timeout(timeout);

      return _handleResponse(response);
    } catch (e) {
      throw ApiException('Network error: $e');
    }
  }

  /// Generic POST request
  Future<Map<String, dynamic>> post(
    String endpoint,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl$endpoint'),
            headers: _getHeaders(),
            body: json.encode(data),
          )
          .timeout(timeout);

      return _handleResponse(response);
    } catch (e) {
      throw ApiException('Network error: $e');
    }
  }

  /// Generic PUT request
  Future<Map<String, dynamic>> put(
    String endpoint,
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await http
          .put(
            Uri.parse('$baseUrl$endpoint'),
            headers: _getHeaders(),
            body: json.encode(data),
          )
          .timeout(timeout);

      return _handleResponse(response);
    } catch (e) {
      throw ApiException('Network error: $e');
    }
  }

  /// Generic DELETE request
  Future<Map<String, dynamic>> delete(String endpoint) async {
    try {
      final response = await http
          .delete(Uri.parse('$baseUrl$endpoint'), headers: _getHeaders())
          .timeout(timeout);

      return _handleResponse(response);
    } catch (e) {
      throw ApiException('Network error: $e');
    }
  }

  /// Get headers for requests
  /// Includes JWT bearer token from Supabase session
  Map<String, String> _getHeaders() {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    
    // Add Authorization header with JWT token if available
    final token = _getAuthToken();
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    
    return headers;
  }

  /// Handle HTTP response
  Map<String, dynamic> _handleResponse(http.Response response) {
    final statusCode = response.statusCode;

    if (statusCode >= 200 && statusCode < 300) {
      try {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        
        // Backend returns data in format: {success: bool, message: str, data: any}
        if (jsonResponse.containsKey('data')) {
          return jsonResponse;
        }
        
        return jsonResponse;
      } catch (e) {
        throw ApiException('Invalid JSON response: $e');
      }
    } else {
      String errorMessage = 'Request failed with status: $statusCode';
      try {
        final errorResponse = json.decode(response.body);
        if (errorResponse.containsKey('detail')) {
          errorMessage = errorResponse['detail'];
        } else if (errorResponse.containsKey('message')) {
          errorMessage = errorResponse['message'];
        }
      } catch (_) {
        // Use default error message
      }
      throw ApiException(errorMessage);
    }
  }

  /// Extract data from backend response
  /// Backend wraps all responses in: {success: bool, message: str, data: T}
  T extractData<T>(Map<String, dynamic> response) {
    if (response['success'] == true && response.containsKey('data')) {
      return response['data'] as T;
    }
    throw ApiException('Invalid response format or unsuccessful request');
  }
}

/// API Exception class
class ApiException implements Exception {
  final String message;
  ApiException(this.message);

  @override
  String toString() => 'ApiException: $message';
}

