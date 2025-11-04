import 'api_service.dart';

/// API service for exam-related endpoints
class ExamApiService extends ApiService {
  /// Get all exams
  Future<List<dynamic>> getExams({
    String? examType,
    int? year,
    int skip = 0,
    int limit = 100,
    String? search,
    bool featured = false,
  }) async {
    final queryParams = <String, String>{
      'skip': skip.toString(),
      'limit': limit.toString(),
    };
    
    if (examType != null) queryParams['exam_type'] = examType;
    if (year != null) queryParams['year'] = year.toString();
    if (search != null && search.isNotEmpty) queryParams['search'] = search;
    if (featured) queryParams['featured'] = 'true';

    final response = await get('/exams', queryParams: queryParams);
    final data = extractData(response);
    
    if (data is List) {
      return data;
    }
    return [];
  }

  /// Get a single exam by ID
  Future<Map<String, dynamic>> getExam(String examId) async {
    final response = await get('/exams/$examId');
    return extractData(response);
  }

  /// Get exam papers for an exam
  Future<List<dynamic>> getExamPapers(String examId) async {
    final response = await get('/exams/$examId/papers');
    final data = extractData(response);
    
    if (data is List) {
      return data;
    }
    return [];
  }

  /// Start an exam paper
  Future<Map<String, dynamic>> startExamPaper(
    String examId,
    String paperId,
  ) async {
    final response = await post(
      '/exams/$examId/papers/$paperId/start',
      {},
    );
    return extractData(response);
  }

  /// Submit an exam paper
  Future<Map<String, dynamic>> submitExamPaper(
    String examId,
    String paperId,
    Map<String, dynamic> responses,
  ) async {
    final response = await post(
      '/exams/$examId/papers/$paperId/submit',
      {'responses': responses},
    );
    return extractData(response);
  }

  /// Get exam results
  Future<List<dynamic>> getExamResults(String examId) async {
    final response = await get('/exams/$examId/results');
    final data = extractData(response);
    
    if (data is List) {
      return data;
    }
    return [];
  }
}

