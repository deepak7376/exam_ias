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
    return SubjectModel(
      id: json['id'],
      name: json['name'],
      icon: json['icon'],
      totalTests: json['totalTests'],
      averageScore: json['averageScore'].toDouble(),
      completedTests: json['completedTests'],
      isAvailable: json['isAvailable'],
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
