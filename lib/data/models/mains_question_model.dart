class MainsQuestionModel {
  final String id;
  final String subjectId;
  final String question;
  final String? hint;
  final int wordLimit;
  final String? sampleAnswer;
  final String topic;
  final int marks;

  MainsQuestionModel({
    required this.id,
    required this.subjectId,
    required this.question,
    this.hint,
    required this.wordLimit,
    this.sampleAnswer,
    required this.topic,
    required this.marks,
  });

  factory MainsQuestionModel.fromJson(Map<String, dynamic> json) {
    return MainsQuestionModel(
      id: json['id'],
      subjectId: json['subjectId'],
      question: json['question'],
      hint: json['hint'],
      wordLimit: json['wordLimit'],
      sampleAnswer: json['sampleAnswer'],
      topic: json['topic'],
      marks: json['marks'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'subjectId': subjectId,
      'question': question,
      'hint': hint,
      'wordLimit': wordLimit,
      'sampleAnswer': sampleAnswer,
      'topic': topic,
      'marks': marks,
    };
  }
}
