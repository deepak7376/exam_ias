class FeedbackModel {
  final String id;
  final String testId;
  final String userId;
  final String difficulty; // Easy, Medium, Difficult
  final String contentQuality; // Poor, Fair, Good, Excellent
  final String userExperience; // Poor, Fair, Good, Excellent
  final String? comments;
  final DateTime submittedAt;

  FeedbackModel({
    required this.id,
    required this.testId,
    required this.userId,
    required this.difficulty,
    required this.contentQuality,
    required this.userExperience,
    this.comments,
    required this.submittedAt,
  });

  factory FeedbackModel.fromJson(Map<String, dynamic> json) {
    return FeedbackModel(
      id: json['id'],
      testId: json['testId'],
      userId: json['userId'],
      difficulty: json['difficulty'],
      contentQuality: json['contentQuality'],
      userExperience: json['userExperience'],
      comments: json['comments'],
      submittedAt: DateTime.parse(json['submittedAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'testId': testId,
      'userId': userId,
      'difficulty': difficulty,
      'contentQuality': contentQuality,
      'userExperience': userExperience,
      'comments': comments,
      'submittedAt': submittedAt.toIso8601String(),
    };
  }
}
