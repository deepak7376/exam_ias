import '../models/subject_model.dart';
import '../models/chapter_model.dart';
import '../models/test_model.dart';
import 'polity_content_service.dart';
import 'mock_data_service.dart';

class SubjectContentService {
  static final SubjectContentService _instance = SubjectContentService._internal();
  factory SubjectContentService() => _instance;
  SubjectContentService._internal();

  final PolityContentService _polityService = PolityContentService();
  final MockDataService _mockDataService = MockDataService();

  // Get all available subjects with their content
  List<SubjectModel> getAllSubjectsWithContent() {
    return _mockDataService.getSubjects();
  }

  // Get chapters for a specific subject
  List<ChapterModel> getSubjectChapters(String subjectId) {
    switch (subjectId) {
      case 'polity':
        return _polityService.getPolityChapters();
      case 'geography':
        return _getGeographyChapters();
      case 'economy':
        return _getEconomyChapters();
      default:
        return [];
    }
  }

  // Get tests for a specific subject
  List<TestModel> getSubjectTests(String subjectId) {
    switch (subjectId) {
      case 'polity':
        return _polityService.getChapterTests();
      case 'geography':
        return _getGeographyTests();
      case 'economy':
        return _getEconomyTests();
      default:
        return [];
    }
  }

  // Get subject progress
  Map<String, dynamic> getSubjectProgress(String subjectId) {
    final chapters = getSubjectChapters(subjectId);
    final tests = getSubjectTests(subjectId);
    
    final completedChapters = chapters.where((ch) => ch.isCompleted).length;
    final completedTests = tests.where((t) => t.status == TestStatus.completed).length;
    
    final chapterProgress = chapters.isNotEmpty ? (completedChapters / chapters.length) * 100 : 0.0;
    final testProgress = tests.isNotEmpty ? (completedTests / tests.length) * 100 : 0.0;
    
    return {
      'subjectId': subjectId,
      'totalChapters': chapters.length,
      'completedChapters': completedChapters,
      'chapterProgress': chapterProgress,
      'totalTests': tests.length,
      'completedTests': completedTests,
      'testProgress': testProgress,
      'overallProgress': (chapterProgress + testProgress) / 2,
      'isAvailable': subjectId == 'polity', // Only Polity is available for now
    };
  }

  // Get overall progress across all subjects
  Map<String, dynamic> getOverallProgress() {
    final subjects = getAllSubjectsWithContent();
    final subjectProgresses = subjects.map((subject) => getSubjectProgress(subject.id)).toList();
    
    final totalChapters = subjectProgresses.fold(0, (sum, progress) => sum + (progress['totalChapters'] as int));
    final completedChapters = subjectProgresses.fold(0, (sum, progress) => sum + (progress['completedChapters'] as int));
    final totalTests = subjectProgresses.fold(0, (sum, progress) => sum + (progress['totalTests'] as int));
    final completedTests = subjectProgresses.fold(0, (sum, progress) => sum + (progress['completedTests'] as int));
    
    final overallProgress = totalChapters > 0 ? (completedChapters / totalChapters) * 100 : 0.0;
    
    return {
      'totalSubjects': subjects.length,
      'availableSubjects': subjectProgresses.where((p) => p['isAvailable']).length,
      'totalChapters': totalChapters,
      'completedChapters': completedChapters,
      'totalTests': totalTests,
      'completedTests': completedTests,
      'overallProgress': overallProgress,
      'subjectProgresses': subjectProgresses,
    };
  }

  // Get smart recommendations based on progress
  List<Map<String, dynamic>> getSmartRecommendations() {
    final overallProgress = getOverallProgress();
    final recommendations = <Map<String, dynamic>>[];
    
    // Add recommendations based on progress
    if (overallProgress['overallProgress'] < 30) {
      recommendations.add({
        'type': 'motivation',
        'title': 'Start Your Journey! 🚀',
        'description': 'Begin with the Polity module to build a strong foundation',
        'action': 'Start Polity Module',
        'priority': 'high',
      });
    } else if (overallProgress['overallProgress'] < 70) {
      recommendations.add({
        'type': 'progress',
        'title': 'Great Progress! 📈',
        'description': 'You\'re doing well! Focus on completing more chapters',
        'action': 'Continue Learning',
        'priority': 'medium',
      });
    } else {
      recommendations.add({
        'type': 'achievement',
        'title': 'Excellent Work! 🏆',
        'description': 'You\'re almost there! Keep up the momentum',
        'action': 'Review & Practice',
        'priority': 'low',
      });
    }
    
    // Add subject-specific recommendations
    final polityProgress = getSubjectProgress('polity');
    if (polityProgress['chapterProgress'] < 50) {
      recommendations.add({
        'type': 'subject',
        'title': 'Polity Focus 📘',
        'description': 'Complete more Polity chapters to improve your score',
        'action': 'Continue Polity',
        'priority': 'high',
      });
    }
    
    return recommendations;
  }

  // Mock data for Geography
  List<ChapterModel> _getGeographyChapters() {
    return [
      ChapterModel(
        id: 'geo_1',
        subjectId: 'geography',
        order: 1,
        title: 'Physical Geography',
        description: 'Earth, Climate, Landforms',
        totalQuestions: 25,
        isCompleted: false,
      ),
      ChapterModel(
        id: 'geo_2',
        subjectId: 'geography',
        order: 2,
        title: 'Human Geography',
        description: 'Population, Settlements, Economic Activities',
        totalQuestions: 20,
        isCompleted: false,
      ),
      ChapterModel(
        id: 'geo_3',
        subjectId: 'geography',
        order: 3,
        title: 'Indian Geography',
        description: 'Physical Features, Climate, Resources',
        totalQuestions: 30,
        isCompleted: false,
      ),
    ];
  }

  // Mock data for Economy
  List<ChapterModel> _getEconomyChapters() {
    return [
      ChapterModel(
        id: 'econ_1',
        subjectId: 'economy',
        order: 1,
        title: 'Basic Concepts',
        description: 'GDP, Inflation, Monetary Policy',
        totalQuestions: 20,
        isCompleted: false,
      ),
      ChapterModel(
        id: 'econ_2',
        subjectId: 'economy',
        order: 2,
        title: 'Indian Economy',
        description: 'Planning, Budget, Banking',
        totalQuestions: 25,
        isCompleted: false,
      ),
      ChapterModel(
        id: 'econ_3',
        subjectId: 'economy',
        order: 3,
        title: 'International Trade',
        description: 'WTO, Balance of Payments, Forex',
        totalQuestions: 15,
        isCompleted: false,
      ),
    ];
  }

  // Mock tests for Geography
  List<TestModel> _getGeographyTests() {
    return [
      TestModel(
        id: 'geo_test_1',
        subjectId: 'geography',
        title: 'Physical Geography Test',
        description: 'Test your knowledge of physical geography',
        duration: 30,
        totalQuestions: 25,
        status: TestStatus.pending,
        canRetake: false,
      ),
      TestModel(
        id: 'geo_test_2',
        subjectId: 'geography',
        title: 'Human Geography Test',
        description: 'Test your knowledge of human geography',
        duration: 25,
        totalQuestions: 20,
        status: TestStatus.pending,
        canRetake: false,
      ),
    ];
  }

  // Mock tests for Economy
  List<TestModel> _getEconomyTests() {
    return [
      TestModel(
        id: 'econ_test_1',
        subjectId: 'economy',
        title: 'Basic Concepts Test',
        description: 'Test your knowledge of basic economic concepts',
        duration: 25,
        totalQuestions: 20,
        status: TestStatus.pending,
        canRetake: false,
      ),
      TestModel(
        id: 'econ_test_2',
        subjectId: 'economy',
        title: 'Indian Economy Test',
        description: 'Test your knowledge of Indian economy',
        duration: 30,
        totalQuestions: 25,
        status: TestStatus.pending,
        canRetake: false,
      ),
    ];
  }
}
