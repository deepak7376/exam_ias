import 'api_service.dart';

/// API service for subject-related endpoints
class SubjectApiService extends ApiService {
  /// Get all subjects
  Future<List<dynamic>> getSubjects({
    int skip = 0,
    int limit = 100,
    String? search,
  }) async {
    final queryParams = <String, String>{
      'skip': skip.toString(),
      'limit': limit.toString(),
    };
    if (search != null && search.isNotEmpty) {
      queryParams['search'] = search;
    }

    final response = await get('/subjects', queryParams: queryParams);
    final data = extractData(response);
    
    // Handle both list and single object responses
    if (data is List) {
      return data;
    }
    return [];
  }

  /// Get a single subject by ID
  Future<Map<String, dynamic>> getSubject(String subjectId) async {
    final response = await get('/subjects/$subjectId');
    return extractData(response);
  }

  /// Get chapters for a subject
  Future<List<dynamic>> getSubjectChapters(
    String subjectId, {
    int skip = 0,
    int limit = 100,
  }) async {
    final queryParams = <String, String>{
      'skip': skip.toString(),
      'limit': limit.toString(),
    };

    final response = await get(
      '/subjects/$subjectId/chapters',
      queryParams: queryParams,
    );
    final data = extractData(response);
    
    if (data is List) {
      return data;
    }
    return [];
  }

  /// Get user progress for a subject
  Future<Map<String, dynamic>?> getSubjectProgress(String subjectId) async {
    try {
      final response = await get('/subjects/$subjectId/progress');
      final data = extractData(response);
      return data as Map<String, dynamic>?;
    } catch (e) {
      // Progress might not exist yet
      return null;
    }
  }
}

