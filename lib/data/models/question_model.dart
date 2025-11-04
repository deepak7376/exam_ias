class QuestionModel {
  final String id;
  final String testId;
  final String question;
  final String questionType;
  final List<String> options;
  final int correctAnswerIndex;
  final String? explanation;
  final String? topic;

  QuestionModel({
    required this.id,
    required this.testId,
    required this.question,
    required this.questionType,
    required this.options,
    required this.correctAnswerIndex,
    this.explanation,
    this.topic,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    // Handle both frontend format and backend API format
    // Backend uses question_text, options (JSONB), correct_answer (JSONB)
    final questionText = json['question_text'] ?? json['question'] ?? '';
    
    // Handle options - can be List or JSONB object
    List<String> options = [];
    if (json['options'] != null) {
      if (json['options'] is List) {
        options = List<String>.from(json['options']);
      } else if (json['options'] is Map) {
        // If it's a map like {A: "option1", B: "option2"}, convert to list
        final optionsMap = json['options'] as Map<String, dynamic>;
        options = optionsMap.values.map((e) => e.toString()).toList();
      }
    }
    
    // Handle correct_answer - can be int, string, or JSONB
    int correctIndex = 0;
    if (json['correct_answer'] != null) {
      if (json['correct_answer'] is int) {
        correctIndex = json['correct_answer'];
      } else if (json['correct_answer'] is String) {
        // Try to parse as index
        final answerStr = json['correct_answer'].toString().toUpperCase();
        if (answerStr == 'A' || answerStr == '0') correctIndex = 0;
        else if (answerStr == 'B' || answerStr == '1') correctIndex = 1;
        else if (answerStr == 'C' || answerStr == '2') correctIndex = 2;
        else if (answerStr == 'D' || answerStr == '3') correctIndex = 3;
      } else if (json['correct_answer'] is Map) {
        // If it's a JSONB object, try to extract index
        final correctMap = json['correct_answer'] as Map<String, dynamic>;
        if (correctMap.containsKey('index')) {
          correctIndex = correctMap['index'] as int;
        }
      }
    } else if (json['correctAnswerIndex'] != null) {
      correctIndex = json['correctAnswerIndex'] as int;
    }

    return QuestionModel(
      id: json['id'] ?? '',
      testId: json['test_id'] ?? json['testId'] ?? '',
      question: questionText,
      options: options,
      questionType: json['question_type'] ?? json['questionType'] ?? 'mcq_single',
      correctAnswerIndex: correctIndex,
      explanation: json['solution_explanation'] ?? json['explanation'],
      topic: json['topic'] ?? json['chapter_id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'testId': testId,
      'question': question,
      'options': options,
      'correctAnswerIndex': correctAnswerIndex,
      'explanation': explanation,
      'topic': topic,
    };
  }
}
