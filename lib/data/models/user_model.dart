class UserModel {
  final String id;
  final String name;
  final String email;
  final String memberSince;
  final double overallProgress;
  final double averageAccuracy;
  final double timePerQuestion;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.memberSince,
    required this.overallProgress,
    required this.averageAccuracy,
    required this.timePerQuestion,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      memberSince: json['memberSince'],
      overallProgress: json['overallProgress'].toDouble(),
      averageAccuracy: json['averageAccuracy'].toDouble(),
      timePerQuestion: json['timePerQuestion'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'memberSince': memberSince,
      'overallProgress': overallProgress,
      'averageAccuracy': averageAccuracy,
      'timePerQuestion': timePerQuestion,
    };
  }
}
