import '../models/exam_model.dart';
import '../models/exam_paper_model.dart';

class ExamService {
  static final ExamService _instance = ExamService._internal();
  factory ExamService() => _instance;
  ExamService._internal();

  // Get all 4 quarterly exams
  List<ExamModel> getAllExams() {
    final now = DateTime.now();
    
    return [
      ExamModel(
        id: 'exam_1',
        title: 'Exam 1 - Q1 2025',
        description: 'January - March 2025',
        releaseDate: DateTime(2025, 1, 1),
        endDate: DateTime(2025, 3, 31),
        status: _getExamStatus(DateTime(2025, 1, 1), DateTime(2025, 3, 31), now),
        prelimsQuestions: 100,
        mainsQuestions: 4,
        prelimsDuration: 120, // 2 hours
        mainsDuration: 180, // 3 hours
        prelimsMarks: 200,
        mainsMarks: 250,
        hasPrelims: true,
        hasMains: true,
        userScore: 72.5, // Mock completed score
        completedAt: DateTime(2025, 1, 15),
      ),
      ExamModel(
        id: 'exam_2',
        title: 'Exam 2 - Q2 2025',
        description: 'April - June 2025',
        releaseDate: DateTime(2025, 4, 1),
        endDate: DateTime(2025, 6, 30),
        status: _getExamStatus(DateTime(2025, 4, 1), DateTime(2025, 6, 30), now),
        prelimsQuestions: 100,
        mainsQuestions: 4,
        prelimsDuration: 120,
        mainsDuration: 180,
        prelimsMarks: 200,
        mainsMarks: 250,
        hasPrelims: true,
        hasMains: true,
      ),
      ExamModel(
        id: 'exam_3',
        title: 'Exam 3 - Q3 2025',
        description: 'July - September 2025',
        releaseDate: DateTime(2025, 7, 1),
        endDate: DateTime(2025, 9, 30),
        status: _getExamStatus(DateTime(2025, 7, 1), DateTime(2025, 9, 30), now),
        prelimsQuestions: 100,
        mainsQuestions: 4,
        prelimsDuration: 120,
        mainsDuration: 180,
        prelimsMarks: 200,
        mainsMarks: 250,
        hasPrelims: true,
        hasMains: true,
      ),
      ExamModel(
        id: 'exam_4',
        title: 'Exam 4 - Q4 2025',
        description: 'October - December 2025',
        releaseDate: DateTime(2025, 10, 1),
        endDate: DateTime(2025, 12, 31),
        status: _getExamStatus(DateTime(2025, 10, 1), DateTime(2025, 12, 31), now),
        prelimsQuestions: 100,
        mainsQuestions: 4,
        prelimsDuration: 120,
        mainsDuration: 180,
        prelimsMarks: 200,
        mainsMarks: 250,
        hasPrelims: true,
        hasMains: true,
      ),
    ];
  }

  // Get Prelims exams only
  List<ExamModel> getPrelimsExams() {
    return getAllExams().where((exam) => exam.hasPrelims).toList();
  }

  // Get Mains exams only
  List<ExamModel> getMainsExams() {
    return getAllExams().where((exam) => exam.hasMains).toList();
  }

  // Get available exams (not locked)
  List<ExamModel> getAvailableExams() {
    return getAllExams().where((exam) => exam.status == ExamStatus.available).toList();
  }

  // Get next exam release date
  DateTime? getNextExamReleaseDate() {
    final now = DateTime.now();
    final exams = getAllExams();
    
    for (var exam in exams) {
      if (exam.releaseDate.isAfter(now)) {
        return exam.releaseDate;
      }
    }
    return null;
  }

  // Get days until next exam
  int getDaysUntilNextExam() {
    final nextRelease = getNextExamReleaseDate();
    if (nextRelease == null) return 0;
    
    final now = DateTime.now();
    return nextRelease.difference(now).inDays;
  }

  // Get current quarter
  String getCurrentQuarter() {
    final now = DateTime.now();
    final month = now.month;
    
    if (month >= 1 && month <= 3) return 'Q1 (Jan-Mar)';
    if (month >= 4 && month <= 6) return 'Q2 (Apr-Jun)';
    if (month >= 7 && month <= 9) return 'Q3 (Jul-Sep)';
    return 'Q4 (Oct-Dec)';
  }

  // Get user progress
  Map<String, dynamic> getUserProgress() {
    final exams = getAllExams();
    final completed = exams.where((exam) => exam.status == ExamStatus.completed).length;
    final available = exams.where((exam) => exam.status == ExamStatus.available).length;
    final locked = exams.where((exam) => exam.status == ExamStatus.locked).length;
    
    return {
      'total': exams.length,
      'completed': completed,
      'available': available,
      'locked': locked,
      'completionRate': (completed / exams.length * 100).round(),
    };
  }

  // Get papers for a specific exam
  List<ExamPaperModel> getExamPapers(String examId) {
    switch (examId) {
      case 'exam_1':
        return _getExam1Papers();
      case 'exam_2':
        return _getExam2Papers();
      case 'exam_3':
        return _getExam3Papers();
      case 'exam_4':
        return _getExam4Papers();
      default:
        return [];
    }
  }

  // Get Prelims papers for an exam
  List<ExamPaperModel> getPrelimsPapers(String examId) {
    return getExamPapers(examId).where((paper) => paper.type == PaperType.prelims).toList();
  }

  // Get Mains papers for an exam
  List<ExamPaperModel> getMainsPapers(String examId) {
    return getExamPapers(examId).where((paper) => paper.type == PaperType.mains).toList();
  }

  // Exam 1 Papers (Q1 2025)
  List<ExamPaperModel> _getExam1Papers() {
    return [
      ExamPaperModel(
        id: 'exam_1_paper_1',
        examId: 'exam_1',
        type: PaperType.prelims,
        title: 'General Studies Paper I',
        description: 'Current Affairs, History, Geography, Polity, Economy, Environment, Science',
        duration: 120, // 2 hours
        totalQuestions: 100,
        totalMarks: 200,
        subjects: ['Current Affairs', 'History', 'Geography', 'Polity', 'Economy', 'Environment', 'Science'],
        isCompleted: true,
        userScore: 75.0,
        completedAt: DateTime(2025, 1, 15),
      ),
      ExamPaperModel(
        id: 'exam_1_paper_2',
        examId: 'exam_1',
        type: PaperType.prelims,
        title: 'CSAT Paper II',
        description: 'Comprehension, Reasoning, Maths, Decision Making',
        duration: 120, // 2 hours
        totalQuestions: 80,
        totalMarks: 200,
        subjects: ['Comprehension', 'Reasoning', 'Mathematics', 'Decision Making'],
        isCompleted: false,
      ),
      ExamPaperModel(
        id: 'exam_1_mains_1',
        examId: 'exam_1',
        type: PaperType.mains,
        title: 'GS Paper I',
        description: 'Indian Heritage & Culture, History, Geography',
        duration: 180, // 3 hours
        totalQuestions: 4,
        totalMarks: 250,
        subjects: ['Indian Heritage & Culture', 'History', 'Geography'],
        isCompleted: false,
      ),
      ExamPaperModel(
        id: 'exam_1_mains_2',
        examId: 'exam_1',
        type: PaperType.mains,
        title: 'GS Paper II',
        description: 'Polity, Governance, International Relations',
        duration: 180, // 3 hours
        totalQuestions: 4,
        totalMarks: 250,
        subjects: ['Polity', 'Governance', 'International Relations'],
        isCompleted: false,
      ),
    ];
  }

  // Exam 2 Papers (Q2 2025)
  List<ExamPaperModel> _getExam2Papers() {
    return [
      ExamPaperModel(
        id: 'exam_2_paper_1',
        examId: 'exam_2',
        type: PaperType.prelims,
        title: 'General Studies Paper I',
        description: 'Current Affairs, History, Geography, Polity, Economy, Environment, Science',
        duration: 120,
        totalQuestions: 100,
        totalMarks: 200,
        subjects: ['Current Affairs', 'History', 'Geography', 'Polity', 'Economy', 'Environment', 'Science'],
        isCompleted: false,
      ),
      ExamPaperModel(
        id: 'exam_2_paper_2',
        examId: 'exam_2',
        type: PaperType.prelims,
        title: 'CSAT Paper II',
        description: 'Comprehension, Reasoning, Maths, Decision Making',
        duration: 120,
        totalQuestions: 80,
        totalMarks: 200,
        subjects: ['Comprehension', 'Reasoning', 'Mathematics', 'Decision Making'],
        isCompleted: false,
      ),
      ExamPaperModel(
        id: 'exam_2_mains_1',
        examId: 'exam_2',
        type: PaperType.mains,
        title: 'GS Paper III',
        description: 'Economy, Science, Technology, Environment, Disaster Management',
        duration: 180,
        totalQuestions: 4,
        totalMarks: 250,
        subjects: ['Economy', 'Science', 'Technology', 'Environment', 'Disaster Management'],
        isCompleted: false,
      ),
      ExamPaperModel(
        id: 'exam_2_mains_2',
        examId: 'exam_2',
        type: PaperType.mains,
        title: 'GS Paper IV',
        description: 'Ethics, Integrity, Aptitude',
        duration: 180,
        totalQuestions: 4,
        totalMarks: 250,
        subjects: ['Ethics', 'Integrity', 'Aptitude'],
        isCompleted: false,
      ),
    ];
  }

  // Exam 3 Papers (Q3 2025)
  List<ExamPaperModel> _getExam3Papers() {
    return [
      ExamPaperModel(
        id: 'exam_3_paper_1',
        examId: 'exam_3',
        type: PaperType.prelims,
        title: 'General Studies Paper I',
        description: 'Current Affairs, History, Geography, Polity, Economy, Environment, Science',
        duration: 120,
        totalQuestions: 100,
        totalMarks: 200,
        subjects: ['Current Affairs', 'History', 'Geography', 'Polity', 'Economy', 'Environment', 'Science'],
        isCompleted: false,
      ),
      ExamPaperModel(
        id: 'exam_3_paper_2',
        examId: 'exam_3',
        type: PaperType.prelims,
        title: 'CSAT Paper II',
        description: 'Comprehension, Reasoning, Maths, Decision Making',
        duration: 120,
        totalQuestions: 80,
        totalMarks: 200,
        subjects: ['Comprehension', 'Reasoning', 'Mathematics', 'Decision Making'],
        isCompleted: false,
      ),
      ExamPaperModel(
        id: 'exam_3_mains_1',
        examId: 'exam_3',
        type: PaperType.mains,
        title: 'Essay Paper',
        description: 'Essay writing on various topics',
        duration: 180,
        totalQuestions: 2,
        totalMarks: 250,
        subjects: ['Essay Writing'],
        isCompleted: false,
      ),
      ExamPaperModel(
        id: 'exam_3_mains_2',
        examId: 'exam_3',
        type: PaperType.mains,
        title: 'Optional Paper I',
        description: 'Optional subject paper',
        duration: 180,
        totalQuestions: 4,
        totalMarks: 250,
        subjects: ['Optional Subject'],
        isCompleted: false,
      ),
    ];
  }

  // Exam 4 Papers (Q4 2025)
  List<ExamPaperModel> _getExam4Papers() {
    return [
      ExamPaperModel(
        id: 'exam_4_paper_1',
        examId: 'exam_4',
        type: PaperType.prelims,
        title: 'General Studies Paper I',
        description: 'Current Affairs, History, Geography, Polity, Economy, Environment, Science',
        duration: 120,
        totalQuestions: 100,
        totalMarks: 200,
        subjects: ['Current Affairs', 'History', 'Geography', 'Polity', 'Economy', 'Environment', 'Science'],
        isCompleted: false,
      ),
      ExamPaperModel(
        id: 'exam_4_paper_2',
        examId: 'exam_4',
        type: PaperType.prelims,
        title: 'CSAT Paper II',
        description: 'Comprehension, Reasoning, Maths, Decision Making',
        duration: 120,
        totalQuestions: 80,
        totalMarks: 200,
        subjects: ['Comprehension', 'Reasoning', 'Mathematics', 'Decision Making'],
        isCompleted: false,
      ),
      ExamPaperModel(
        id: 'exam_4_mains_1',
        examId: 'exam_4',
        type: PaperType.mains,
        title: 'Optional Paper II',
        description: 'Optional subject paper',
        duration: 180,
        totalQuestions: 4,
        totalMarks: 250,
        subjects: ['Optional Subject'],
        isCompleted: false,
      ),
      ExamPaperModel(
        id: 'exam_4_mains_2',
        examId: 'exam_4',
        type: PaperType.mains,
        title: 'Language Papers',
        description: 'Indian Language and English',
        duration: 180,
        totalQuestions: 4,
        totalMarks: 300,
        subjects: ['Indian Language', 'English'],
        isCompleted: false,
      ),
    ];
  }

  ExamStatus _getExamStatus(DateTime releaseDate, DateTime endDate, DateTime now) {
    if (now.isBefore(releaseDate)) {
      return ExamStatus.locked;
    } else if (now.isAfter(endDate)) {
      return ExamStatus.expired;
    } else {
      return ExamStatus.available;
    }
  }
}
