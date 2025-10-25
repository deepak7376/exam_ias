enum ExamStatus { available, locked, expired, completed }

class ExamModel {
  final String id;
  final String title;
  final String description;
  final DateTime releaseDate;
  final DateTime endDate;
  final ExamStatus status;
  final int prelimsQuestions;
  final int mainsQuestions;
  final int prelimsDuration; // in minutes
  final int mainsDuration; // in minutes
  final int prelimsMarks;
  final int mainsMarks;
  final double? userScore;
  final DateTime? completedAt;
  final bool hasPrelims;
  final bool hasMains;

  ExamModel({
    required this.id,
    required this.title,
    required this.description,
    required this.releaseDate,
    required this.endDate,
    required this.status,
    required this.prelimsQuestions,
    required this.mainsQuestions,
    required this.prelimsDuration,
    required this.mainsDuration,
    required this.prelimsMarks,
    required this.mainsMarks,
    this.userScore,
    this.completedAt,
    required this.hasPrelims,
    required this.hasMains,
  });

  factory ExamModel.fromJson(Map<String, dynamic> json) {
    return ExamModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      releaseDate: DateTime.parse(json['releaseDate']),
      endDate: DateTime.parse(json['endDate']),
      status: ExamStatus.values.firstWhere(
        (e) => e.toString() == 'ExamStatus.${json['status']}',
        orElse: () => ExamStatus.locked,
      ),
      prelimsQuestions: json['prelimsQuestions'],
      mainsQuestions: json['mainsQuestions'],
      prelimsDuration: json['prelimsDuration'],
      mainsDuration: json['mainsDuration'],
      prelimsMarks: json['prelimsMarks'],
      mainsMarks: json['mainsMarks'],
      userScore: json['userScore']?.toDouble(),
      completedAt: json['completedAt'] != null ? DateTime.parse(json['completedAt']) : null,
      hasPrelims: json['hasPrelims'],
      hasMains: json['hasMains'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'releaseDate': releaseDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'status': status.toString().split('.').last,
      'prelimsQuestions': prelimsQuestions,
      'mainsQuestions': mainsQuestions,
      'prelimsDuration': prelimsDuration,
      'mainsDuration': mainsDuration,
      'prelimsMarks': prelimsMarks,
      'mainsMarks': mainsMarks,
      'userScore': userScore,
      'completedAt': completedAt?.toIso8601String(),
      'hasPrelims': hasPrelims,
      'hasMains': hasMains,
    };
  }
}
