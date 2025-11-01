import 'api_service.dart';

/// API service for test-related endpoints
class TestApiService extends ApiService {
  /// Get all tests (with optional filters)
  Future<List<dynamic>> getTests({
    String? subjectId,
    String? chapterId,
    int skip = 0,
    int limit = 100,
    String? search,
    bool featured = false,
  }) async {
    final queryParams = <String, String>{
      'skip': skip.toString(),
      'limit': limit.toString(),
    };
    
    if (subjectId != null) queryParams['subject_id'] = subjectId;
    if (chapterId != null) queryParams['chapter_id'] = chapterId;
    if (search != null && search.isNotEmpty) queryParams['search'] = search;
    if (featured) queryParams['featured'] = 'true';

    final response = await get('/tests', queryParams: queryParams);
    final responseData = extractData(response);
    
    // Handle paginated response or direct list
    if (responseData is Map && responseData.containsKey('items')) {
      return responseData['items'] as List;
    } else if (responseData is List) {
      return responseData;
    }
    return [];
  }

  /// Get a single test by ID
  Future<Map<String, dynamic>> getTest(String testId) async {
    final response = await get('/tests/$testId');
    return extractData(response);
  }

  /// Get questions for a test
  Future<List<dynamic>> getTestQuestions(String testId) async {
    try {
      final response = await get('/tests/$testId/questions');
      final data = extractData(response);
      
      if (data is List) {
        return data;
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  /// Start a test
  Future<Map<String, dynamic>> startTest(String testId) async {
    final response = await post('/tests/$testId/start', {});
    return extractData(response);
  }

  /// Submit a test
  Future<Map<String, dynamic>> submitTest(
    String testId,
    Map<String, dynamic> responses,
  ) async {
    final response = await post(
      '/tests/$testId/submit',
      {'responses': responses},
    );
    return extractData(response);
  }

  /// Get test results
  Future<Map<String, dynamic>> getTestResults(String testId) async {
    final response = await get('/tests/$testId/results');
    return extractData(response);
  }

  /// Get user's test attempts
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

