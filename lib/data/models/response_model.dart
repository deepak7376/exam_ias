class ResponseModel {
  final String id;
  final String testId;
  final String questionId;
  final int selectedAnswerIndex;
  final bool isCorrect;
  final bool isMarkedForReview;
  final DateTime answeredAt;

  ResponseModel({
    required this.id,
    required this.testId,
    required this.questionId,
    required this.selectedAnswerIndex,
    required this.isCorrect,
    required this.isMarkedForReview,
    required this.answeredAt,
  });

  factory ResponseModel.fromJson(Map<String, dynamic> json) {
    return ResponseModel(
      id: json['id'],
      testId: json['testId'],
      questionId: json['questionId'],
      selectedAnswerIndex: json['selectedAnswerIndex'],
      isCorrect: json['isCorrect'],
      isMarkedForReview: json['isMarkedForReview'],
      answeredAt: DateTime.parse(json['answeredAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'testId': testId,
      'questionId': questionId,
      'selectedAnswerIndex': selectedAnswerIndex,
      'isCorrect': isCorrect,
      'isMarkedForReview': isMarkedForReview,
      'answeredAt': answeredAt.toIso8601String(),
    };
  }
}
