class ChapterModel {
  final String id;
  final String subjectId;
  final String title;
  final String description;
  final int order;
  final int totalQuestions;
  final bool isCompleted;
  final double? accuracy;

  ChapterModel({
    required this.id,
    required this.subjectId,
    required this.title,
    required this.description,
    required this.order,
    required this.totalQuestions,
    required this.isCompleted,
    this.accuracy,
  });

  factory ChapterModel.fromJson(Map<String, dynamic> json) {
    return ChapterModel(
      id: json['id'],
      subjectId: json['subjectId'],
      title: json['title'],
      description: json['description'],
      order: json['order'],
      totalQuestions: json['totalQuestions'],
      isCompleted: json['isCompleted'],
      accuracy: json['accuracy']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'subjectId': subjectId,
      'title': title,
      'description': description,
      'order': order,
      'totalQuestions': totalQuestions,
      'isCompleted': isCompleted,
      'accuracy': accuracy,
    };
  }
}
