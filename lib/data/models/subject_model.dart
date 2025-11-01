class SubjectModel {
  final String id;
  final String name;
  final String icon;
  final int totalTests;
  final double averageScore;
  final int completedTests;
  final bool isAvailable;

  SubjectModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.totalTests,
    required this.averageScore,
    required this.completedTests,
    required this.isAvailable,
  });

  factory SubjectModel.fromJson(Map<String, dynamic> json) {
    // Handle both frontend format and backend API format
    return SubjectModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      icon: json['icon'] ?? '📘',
      totalTests: json['total_tests'] ?? json['totalTests'] ?? 0,
      averageScore: (json['average_score'] ?? json['averageScore'] ?? 0.0).toDouble(),
      completedTests: json['completed_tests'] ?? json['completedTests'] ?? 0,
      isAvailable: json['is_available'] ?? json['isAvailable'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'totalTests': totalTests,
      'averageScore': averageScore,
      'completedTests': completedTests,
      'isAvailable': isAvailable,
    };
  }
}
