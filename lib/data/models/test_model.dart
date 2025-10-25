enum TestStatus { pending, completed, retry }

class TestModel {
  final String id;
  final String subjectId;
  final String title;
  final String description;
  final int duration; // in minutes
  final int totalQuestions;
  final TestStatus status;
  final double? score;
  final String? completedAt;
  final bool canRetake;

  TestModel({
    required this.id,
    required this.subjectId,
    required this.title,
    required this.description,
    required this.duration,
    required this.totalQuestions,
    required this.status,
    this.score,
    this.completedAt,
    required this.canRetake,
  });

  factory TestModel.fromJson(Map<String, dynamic> json) {
    return TestModel(
      id: json['id'],
      subjectId: json['subjectId'],
      title: json['title'],
      description: json['description'],
      duration: json['duration'],
      totalQuestions: json['totalQuestions'],
      status: TestStatus.values.firstWhere(
        (e) => e.toString() == 'TestStatus.${json['status']}',
        orElse: () => TestStatus.pending,
      ),
      score: json['score']?.toDouble(),
      completedAt: json['completedAt'],
      canRetake: json['canRetake'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'subjectId': subjectId,
      'title': title,
      'description': description,
      'duration': duration,
      'totalQuestions': totalQuestions,
      'status': status.toString().split('.').last,
      'score': score,
      'completedAt': completedAt,
      'canRetake': canRetake,
    };
  }
}
