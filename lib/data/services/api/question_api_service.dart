import 'api_service.dart';

/// API service for question-related endpoints
class QuestionApiService extends ApiService {
  /// Get questions (with optional filters)
  Future<List<dynamic>> getQuestions({
    String? subjectId,
    String? chapterId,
    String? difficultyLevel,
    String? search,
    int skip = 0,
    int limit = 100,
  }) async {
    final queryParams = <String, String>{
      'skip': skip.toString(),
      'limit': limit.toString(),
    };
    
    if (subjectId != null) queryParams['subject_id'] = subjectId;
    if (chapterId != null) queryParams['chapter_id'] = chapterId;
    if (difficultyLevel != null) queryParams['difficulty_level'] = difficultyLevel;
    if (search != null && search.isNotEmpty) queryParams['search'] = search;

    final response = await get('/questions', queryParams: queryParams);
    final data = extractData(response);
    
    if (data is List) {
      return data;
    }
    return [];
  }

  /// Get a single question by ID
  Future<Map<String, dynamic>> getQuestion(String questionId) async {
    final response = await get('/questions/$questionId');
    return extractData(response);
  }

  /// Submit answer to a question
  Future<Map<String, dynamic>> submitAnswer(
    String questionId,
    Map<String, dynamic> answerData,
  ) async {
    final response = await post(
      '/questions/$questionId/answer',
      answerData,
    );
    return extractData(response);
  }
}

