enum TestStatus { pending, completed, retry }

class TestModel {
  final String id;
  final String subjectId;
  final String? chapterId; // nullable because full-length tests don't have chapter_id
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
    this.chapterId,
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
    // Handle both frontend format and backend API format (snake_case)
    final statusStr = json['status'] ?? 'pending';
    TestStatus status;
    
    // Map backend status to TestStatus enum
    switch (statusStr.toString().toLowerCase()) {
      case 'completed':
        status = TestStatus.completed;
        break;
      case 'retry':
      case 'in_progress':
        status = TestStatus.retry;
        break;
      default:
        status = TestStatus.pending;
    }

    return TestModel(
      id: json['id'] ?? '',
      subjectId: json['subject_id'] ?? json['subjectId'] ?? '',
      chapterId: json['chapter_id'] ?? json['chapterId'],
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      duration: json['duration_minutes'] ?? json['duration'] ?? 60,
      totalQuestions: json['total_questions'] ?? json['totalQuestions'] ?? 0,
      status: status,
      score: (json['marks_obtained'] ?? json['percentage'] ?? json['score'])?.toDouble(),
      completedAt: json['submitted_at'] ?? json['completedAt'],
      canRetake: json['canRetake'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'subjectId': subjectId,
      'chapterId': chapterId,
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
