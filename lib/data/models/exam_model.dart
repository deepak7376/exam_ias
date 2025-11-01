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
    // Handle both frontend format and backend API format
    final releaseDateStr = json['release_date'] ?? json['releaseDate'];
    final endDateStr = json['end_date'] ?? json['endDate'];
    
    ExamStatus status;
    final statusStr = (json['is_active'] == true) ? 'available' : (json['status'] ?? 'locked');
    switch (statusStr.toString().toLowerCase()) {
      case 'available':
      case 'active':
        status = ExamStatus.available;
        break;
      case 'completed':
        status = ExamStatus.completed;
        break;
      case 'expired':
        status = ExamStatus.expired;
        break;
      default:
        status = ExamStatus.locked;
    }

    // Get exam papers to determine prelims/mains
    final examType = json['exam_type'] ?? '';
    final hasPrelims = examType == 'prelims' || examType == 'both';
    final hasMains = examType == 'mains' || examType == 'both';

    return ExamModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      releaseDate: releaseDateStr != null ? DateTime.parse(releaseDateStr) : DateTime.now(),
      endDate: endDateStr != null ? DateTime.parse(endDateStr) : DateTime.now().add(Duration(days: 30)),
      status: status,
      prelimsQuestions: json['prelims_questions'] ?? json['prelimsQuestions'] ?? 0,
      mainsQuestions: json['mains_questions'] ?? json['mainsQuestions'] ?? 0,
      prelimsDuration: json['prelims_duration'] ?? json['prelimsDuration'] ?? 120,
      mainsDuration: json['mains_duration'] ?? json['mainsDuration'] ?? 180,
      prelimsMarks: json['prelims_marks'] ?? json['prelimsMarks'] ?? 0,
      mainsMarks: json['mains_marks'] ?? json['mainsMarks'] ?? 0,
      userScore: (json['user_score'] ?? json['userScore'])?.toDouble(),
      completedAt: (json['completed_at'] ?? json['completedAt']) != null 
          ? DateTime.parse(json['completed_at'] ?? json['completedAt']) 
          : null,
      hasPrelims: hasPrelims,
      hasMains: hasMains,
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
