class DailyQuizModel {
  final String id;
  final String title;
  final String description;
  final String? subjectId;
  final String? chapterId;
  final String testType;
  final int totalQuestions;
  final int totalMarks;
  final int durationMinutes;
  final int passingMarks;
  final bool negativeMarking;
  final bool isTimed;
  final String? instructions;
  final bool isPublished;
  final bool allowReview;
  final bool showCorrectAnswers;
  final bool showExplanation;
  final bool allowPause;
  final bool autoSubmit;
  final int? warningTime;
  final bool isFeatured;
  final int totalAttempts;
  final double averageScore;
  final double averageTime;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  DailyQuizModel({
    required this.id,
    required this.title,
    required this.description,
    this.subjectId,
    this.chapterId,
    required this.testType,
    required this.totalQuestions,
    required this.totalMarks,
    required this.durationMinutes,
    required this.passingMarks,
    required this.negativeMarking,
    required this.isTimed,
    this.instructions,
    required this.isPublished,
    required this.allowReview,
    required this.showCorrectAnswers,
    required this.showExplanation,
    required this.allowPause,
    required this.autoSubmit,
    this.warningTime,
    required this.isFeatured,
    required this.totalAttempts,
    required this.averageScore,
    required this.averageTime,
    this.createdAt,
    this.updatedAt,
  });

  factory DailyQuizModel.fromJson(Map<String, dynamic> json) {
    return DailyQuizModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      subjectId: json['subject_id'] as String?,
      chapterId: json['chapter_id'] as String?,
      testType: json['test_type'] as String? ?? 'daily',
      totalQuestions: json['total_questions'] as int? ?? 0,
      totalMarks: json['total_marks'] as int? ?? 0,
      durationMinutes: json['duration_minutes'] as int? ?? 0,
      passingMarks: json['passing_marks'] as int? ?? 0,
      negativeMarking: json['negative_marking'] as bool? ?? false,
      isTimed: json['is_timed'] as bool? ?? true,
      instructions: json['instructions'] as String?,
      isPublished: json['is_published'] as bool? ?? false,
      allowReview: json['allow_review'] as bool? ?? true,
      showCorrectAnswers: json['show_correct_answers'] as bool? ?? true,
      showExplanation: json['show_explanation'] as bool? ?? true,
      allowPause: json['allow_pause'] as bool? ?? false,
      autoSubmit: json['auto_submit'] as bool? ?? true,
      warningTime: json['warning_time'] as int?,
      isFeatured: json['is_featured'] as bool? ?? false,
      totalAttempts: json['total_attempts'] as int? ?? 0,
      averageScore: (json['average_score'] as num?)?.toDouble() ?? 0.0,
      averageTime: (json['average_time'] as num?)?.toDouble() ?? 0.0,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'subject_id': subjectId,
      'chapter_id': chapterId,
      'test_type': testType,
      'total_questions': totalQuestions,
      'total_marks': totalMarks,
      'duration_minutes': durationMinutes,
      'passing_marks': passingMarks,
      'negative_marking': negativeMarking,
      'is_timed': isTimed,
      'instructions': instructions,
      'is_published': isPublished,
      'allow_review': allowReview,
      'show_correct_answers': showCorrectAnswers,
      'show_explanation': showExplanation,
      'allow_pause': allowPause,
      'auto_submit': autoSubmit,
      'warning_time': warningTime,
      'is_featured': isFeatured,
      'total_attempts': totalAttempts,
      'average_score': averageScore,
      'average_time': averageTime,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}

