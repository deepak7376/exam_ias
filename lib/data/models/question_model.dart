class QuestionModel {
  final String id;
  final String testId;
  final String question;
  final List<String> options;
  final int correctAnswerIndex;
  final String? explanation;
  final String? topic;

  QuestionModel({
    required this.id,
    required this.testId,
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
    this.explanation,
    this.topic,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      id: json['id'],
      testId: json['testId'],
      question: json['question'],
      options: List<String>.from(json['options']),
      correctAnswerIndex: json['correctAnswerIndex'],
      explanation: json['explanation'],
      topic: json['topic'],
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
