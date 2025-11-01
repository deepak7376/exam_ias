import 'dart:convert';
import 'package:http/http.dart' as http;

/// Base API service for making HTTP requests to the backend
class ApiService {
  // TODO: Update this with your actual backend URL
  // For local development, use: http://localhost:8000
  // For production, use your deployed backend URL
  static const String baseUrl = 'http://localhost:8000/api/v1';
  static const Duration timeout = Duration(seconds: 30);

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
  /// TODO: Add authentication token when auth is implemented
  Map<String, String> _getHeaders() {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      // TODO: Add Authorization header when auth is ready
      // 'Authorization': 'Bearer $token',
    };
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

