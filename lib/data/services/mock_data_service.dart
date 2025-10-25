import '../models/user_model.dart';
import '../models/subject_model.dart';
import '../models/test_model.dart';
import '../models/question_model.dart';

class MockDataService {
  static final MockDataService _instance = MockDataService._internal();
  factory MockDataService() => _instance;
  MockDataService._internal();

  // Mock User Data
  UserModel getCurrentUser() {
    return UserModel(
      id: '1',
      name: 'Deepak Yadav',
      email: 'deepak@example.com',
      memberSince: 'Oct 2025',
      overallProgress: 65.0,
      averageAccuracy: 71.0,
      timePerQuestion: 1.8,
    );
  }

  // Mock Subjects Data
  List<SubjectModel> getSubjects() {
    return [
      SubjectModel(
        id: 'polity',
        name: 'Polity',
        icon: '📘',
        totalTests: 5,
        averageScore: 72.0,
        completedTests: 3,
        isAvailable: true,
      ),
      SubjectModel(
        id: 'geography',
        name: 'Geography',
        icon: '🌏',
        totalTests: 0,
        averageScore: 0.0,
        completedTests: 0,
        isAvailable: false,
      ),
      SubjectModel(
        id: 'economy',
        name: 'Economy',
        icon: '📊',
        totalTests: 0,
        averageScore: 0.0,
        completedTests: 0,
        isAvailable: false,
      ),
    ];
  }

  // Mock Tests for Polity
  List<TestModel> getTestsForSubject(String subjectId) {
    if (subjectId == 'polity') {
      return [
        TestModel(
          id: 'test1',
          subjectId: 'polity',
          title: 'Indian Constitution',
          description: 'Fundamental concepts of Indian Constitution',
          duration: 60,
          totalQuestions: 20,
          status: TestStatus.completed,
          score: 75.0,
          completedAt: '2025-01-15',
          canRetake: true,
        ),
        TestModel(
          id: 'test2',
          subjectId: 'polity',
          title: 'Fundamental Rights',
          description: 'Articles 12-35 of Indian Constitution',
          duration: 60,
          totalQuestions: 25,
          status: TestStatus.retry,
          score: 65.0,
          completedAt: '2025-01-10',
          canRetake: true,
        ),
        TestModel(
          id: 'test3',
          subjectId: 'polity',
          title: 'Parliament System',
          description: 'Lok Sabha, Rajya Sabha and Parliamentary procedures',
          duration: 60,
          totalQuestions: 20,
          status: TestStatus.pending,
          canRetake: false,
        ),
        TestModel(
          id: 'test4',
          subjectId: 'polity',
          title: 'Constitutional Amendments',
          description: 'Important amendments and their significance',
          duration: 60,
          totalQuestions: 22,
          status: TestStatus.pending,
          canRetake: false,
        ),
        TestModel(
          id: 'test5',
          subjectId: 'polity',
          title: 'Judiciary System',
          description: 'Supreme Court, High Courts and Judicial Review',
          duration: 60,
          totalQuestions: 18,
          status: TestStatus.pending,
          canRetake: false,
        ),
      ];
    }
    return [];
  }

  // Mock Questions for Test 3 (Parliament System)
  List<QuestionModel> getQuestionsForTest(String testId) {
    if (testId == 'test3') {
      return [
        QuestionModel(
          id: 'q1',
          testId: 'test3',
          question: 'Who is the guardian of the Constitution of India?',
          options: [
            'Parliament',
            'Supreme Court',
            'President',
            'Prime Minister',
          ],
          correctAnswerIndex: 1,
          explanation: 'The Supreme Court is the guardian of the Constitution of India.',
          topic: 'Judiciary',
        ),
        QuestionModel(
          id: 'q2',
          testId: 'test3',
          question: 'What is the maximum strength of Lok Sabha?',
          options: [
            '540',
            '545',
            '550',
            '552',
          ],
          correctAnswerIndex: 2,
          explanation: 'The maximum strength of Lok Sabha is 550 (530 from states + 20 from Union Territories).',
          topic: 'Parliament',
        ),
        QuestionModel(
          id: 'q3',
          testId: 'test3',
          question: 'Who presides over the joint sitting of Parliament?',
          options: [
            'President',
            'Vice President',
            'Speaker of Lok Sabha',
            'Prime Minister',
          ],
          correctAnswerIndex: 2,
          explanation: 'The Speaker of Lok Sabha presides over the joint sitting of Parliament.',
          topic: 'Parliament',
        ),
        QuestionModel(
          id: 'q4',
          testId: 'test3',
          question: 'What is the tenure of Rajya Sabha?',
          options: [
            '5 years',
            '6 years',
            'Permanent',
            '3 years',
          ],
          correctAnswerIndex: 2,
          explanation: 'Rajya Sabha is a permanent house, with one-third of its members retiring every two years.',
          topic: 'Parliament',
        ),
        QuestionModel(
          id: 'q5',
          testId: 'test3',
          question: 'Which article deals with the composition of Parliament?',
          options: [
            'Article 79',
            'Article 80',
            'Article 81',
            'Article 82',
          ],
          correctAnswerIndex: 0,
          explanation: 'Article 79 deals with the composition of Parliament.',
          topic: 'Constitution',
        ),
      ];
    }
    return [];
  }

  // Mock AI Recommendation
  String getAIRecommendation(String testId) {
    if (testId == 'test3') {
      return "Your weak areas are: Parliamentary Committees and Constitutional Amendments. Focus on these topics for better performance.";
    }
    return "Keep practicing regularly to improve your performance.";
  }
}
