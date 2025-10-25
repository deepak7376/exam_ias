enum PaperType { prelims, mains }

class ExamPaperModel {
  final String id;
  final String examId;
  final PaperType type;
  final String title;
  final String description;
  final int duration; // in minutes
  final int totalQuestions;
  final int totalMarks;
  final List<String> subjects;
  final bool isCompleted;
  final double? userScore;
  final DateTime? completedAt;

  ExamPaperModel({
    required this.id,
    required this.examId,
    required this.type,
    required this.title,
    required this.description,
    required this.duration,
    required this.totalQuestions,
    required this.totalMarks,
    required this.subjects,
    required this.isCompleted,
    this.userScore,
    this.completedAt,
  });

  factory ExamPaperModel.fromJson(Map<String, dynamic> json) {
    return ExamPaperModel(
      id: json['id'],
      examId: json['examId'],
      type: PaperType.values.firstWhere(
        (e) => e.toString() == 'PaperType.${json['type']}',
        orElse: () => PaperType.prelims,
      ),
      title: json['title'],
      description: json['description'],
      duration: json['duration'],
      totalQuestions: json['totalQuestions'],
      totalMarks: json['totalMarks'],
      subjects: List<String>.from(json['subjects']),
      isCompleted: json['isCompleted'],
      userScore: json['userScore']?.toDouble(),
      completedAt: json['completedAt'] != null ? DateTime.parse(json['completedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'examId': examId,
      'type': type.toString().split('.').last,
      'title': title,
      'description': description,
      'duration': duration,
      'totalQuestions': totalQuestions,
      'totalMarks': totalMarks,
      'subjects': subjects,
      'isCompleted': isCompleted,
      'userScore': userScore,
      'completedAt': completedAt?.toIso8601String(),
    };
  }
}
