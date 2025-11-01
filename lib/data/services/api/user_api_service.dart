import 'api_service.dart';

/// API service for user-related endpoints
class UserApiService extends ApiService {
  /// Get current user profile
  /// Note: This requires authentication - will work once auth is implemented
  Future<Map<String, dynamic>> getCurrentUser() async {
    try {
      final response = await get('/users/profile');
      return extractData(response);
    } catch (e) {
      // For now, return null if not authenticated
      rethrow;
    }
  }

  /// Get user progress
  Future<List<dynamic>> getUserProgress() async {
    try {
      final response = await get('/users/progress');
      final data = extractData(response);
      
      if (data is List) {
        return data;
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  /// Get user statistics
  Future<Map<String, dynamic>> getUserStats() async {
    try {
      final response = await get('/users/stats');
      return extractData(response);
    } catch (e) {
      rethrow;
    }
  }

  /// Get user attempts
  Future<List<dynamic>> getUserAttempts({
    int skip = 0,
    int limit = 100,
  }) async {
    final queryParams = <String, String>{
      'skip': skip.toString(),
      'limit': limit.toString(),
    };

    final response = await get(
      '/users/attempts',
      queryParams: queryParams,
    );
    final data = extractData(response);
    
    if (data is List) {
      return data;
    }
    return [];
  }
}

