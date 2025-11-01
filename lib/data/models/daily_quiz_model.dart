class DailyQuizModel {
  final String id;
  final int dayNumber;
  final String title;
  final int totalQuestions;
  final int durationMinutes;
  final List<String> topics;
  final bool isCompleted;
  final int currentStreak;

  DailyQuizModel({
    required this.id,
    required this.dayNumber,
    required this.title,
    required this.totalQuestions,
    required this.durationMinutes,
    required this.topics,
    this.isCompleted = false,
    required this.currentStreak,
  });
}

