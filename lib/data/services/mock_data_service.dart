import '../models/user_model.dart';
import '../models/subject_model.dart';
import '../models/test_model.dart';
import '../models/question_model.dart';
import 'api/subject_api_service.dart';
import 'api/test_api_service.dart';
import 'api/question_api_service.dart';
import 'api/user_api_service.dart';

class MockDataService {
  static final MockDataService _instance = MockDataService._internal();
  factory MockDataService() => _instance;
  MockDataService._internal();

  // API Services
  final SubjectApiService _subjectApiService = SubjectApiService();
  final TestApiService _testApiService = TestApiService();
  final QuestionApiService _questionApiService = QuestionApiService();
  final UserApiService _userApiService = UserApiService();

  // Get User Data - tries API first, falls back to mock
  Future<UserModel> getCurrentUser() async {
    try {
      final userData = await _userApiService.getCurrentUser();
      // Convert backend format to UserModel
      final createdAt = userData['created_at'] != null 
          ? DateTime.parse(userData['created_at']).toString() 
          : 'Oct 2025';
      
      return UserModel(
        id: userData['id'] ?? '1',
        name: userData['name'] ?? 'User',
        email: userData['email'] ?? '',
        memberSince: createdAt,
        overallProgress: (userData['overall_progress'] ?? 0.0).toDouble(),
        averageAccuracy: (userData['average_accuracy'] ?? 0.0).toDouble(),
        timePerQuestion: (userData['time_per_question'] ?? 1.8).toDouble(),
      );
    } catch (e) {
      // Fallback to mock data if API fails
      return _getDummyUser();
    }
  }

  UserModel _getDummyUser() {
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

  // Get Subjects - tries API first, falls back to mock
  Future<List<SubjectModel>> getSubjects() async {
    try {
      final subjectsData = await _subjectApiService.getSubjects();
      return subjectsData
          .map((json) => SubjectModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      // Fallback to mock data if API fails
      return _getDummySubjects();
    }
  }

  List<SubjectModel> _getDummySubjects() {
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

  // Get Tests for Subject - tries API first, falls back to mock
  Future<List<TestModel>> getTestsForSubject(String subjectId) async {
    try {
      final testsData = await _testApiService.getTests(subjectId: subjectId);
      return testsData
          .map((json) => TestModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      // Fallback to mock data if API fails
      return _getDummyTestsForSubject(subjectId);
    }
  }

  List<TestModel> _getDummyTestsForSubject(String subjectId) {
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

  // Get Questions for Test - tries API first, falls back to mock
  Future<List<QuestionModel>> getQuestionsForTest(String testId) async {
    try {
      final questionsData = await _testApiService.getTestQuestions(testId);
      if (questionsData.isEmpty) {
        // Try alternative endpoint
        final altQuestions = await _questionApiService.getQuestions();
        return altQuestions
            .map((json) => QuestionModel.fromJson(json as Map<String, dynamic>))
            .toList();
      }
      return questionsData
          .map((json) => QuestionModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      // Fallback to mock data if API fails
      return _getDummyQuestionsForTest(testId);
    }
  }

  List<QuestionModel> _getDummyQuestionsForTest(String testId) {
    // Get test info to determine number of questions
    // Note: This is a synchronous fallback method, so we can't await async calls
    // For now, we'll just use default values or try to find test from cached data
    TestModel? test;
    // Since this is a fallback method and getSubjects/getTestsForSubject are now async,
    // we'll skip the async lookup and use default test info
    test = null;

    // Check for daily quiz
    final dailyQuiz = getDailyQuiz();
    int questionCount = 20;
    if (testId == dailyQuiz['id']) {
      questionCount = dailyQuiz['totalQuestions'] ?? 20;
    } else if (test != null) {
      questionCount = test.totalQuestions;
    }
    
    // Generate questions based on testId
    List<QuestionModel> questions = [];
    
    // Questions for test3 (Parliament System)
    if (testId == 'test3' || testId == 'polity_test_3') {
      return [
        QuestionModel(
          id: 'q1',
          testId: testId,
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
          testId: testId,
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
          testId: testId,
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
          testId: testId,
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
          testId: testId,
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

    // Generic questions for other tests
    final questionTemplates = [
      {
        'question': 'The Constitution of India was adopted on:',
        'options': ['15 August 1947', '26 January 1950', '26 November 1949', '2 October 1947'],
        'correct': 2,
        'explanation': 'The Constitution was adopted on 26 November 1949 and came into effect on 26 January 1950.',
        'topic': 'Constitution'
      },
      {
        'question': 'Who was the Chairman of the Drafting Committee of the Indian Constitution?',
        'options': ['Jawaharlal Nehru', 'B.R. Ambedkar', 'Rajendra Prasad', 'Sardar Patel'],
        'correct': 1,
        'explanation': 'Dr. B.R. Ambedkar was the Chairman of the Drafting Committee.',
        'topic': 'Constitution'
      },
      {
        'question': 'How many Fundamental Rights are guaranteed by the Indian Constitution?',
        'options': ['Five', 'Six', 'Seven', 'Eight'],
        'correct': 1,
        'explanation': 'Initially there were seven fundamental rights, but after the 44th Amendment, Property was removed, leaving six.',
        'topic': 'Fundamental Rights'
      },
      {
        'question': 'Article 21 of the Indian Constitution deals with:',
        'options': ['Right to Equality', 'Right to Freedom', 'Right to Life and Personal Liberty', 'Right against Exploitation'],
        'correct': 2,
        'explanation': 'Article 21 guarantees the Right to Life and Personal Liberty.',
        'topic': 'Fundamental Rights'
      },
      {
        'question': 'The President of India is elected by:',
        'options': ['Direct election', 'Indirect election by Electoral College', 'Parliament', 'State Legislatures'],
        'correct': 1,
        'explanation': 'The President is elected by an Electoral College consisting of elected members of both Houses of Parliament and State Legislatures.',
        'topic': 'Executive'
      },
      {
        'question': 'Who appoints the Prime Minister of India?',
        'options': ['President', 'People', 'Lok Sabha', 'Supreme Court'],
        'correct': 0,
        'explanation': 'The President appoints the Prime Minister, usually the leader of the majority party.',
        'topic': 'Executive'
      },
      {
        'question': 'The minimum age to be a member of Lok Sabha is:',
        'options': ['21 years', '25 years', '30 years', '35 years'],
        'correct': 1,
        'explanation': 'The minimum age to be a member of Lok Sabha is 25 years.',
        'topic': 'Parliament'
      },
      {
        'question': 'Who can dissolve the Lok Sabha?',
        'options': ['Prime Minister', 'President', 'Speaker', 'Chief Justice'],
        'correct': 1,
        'explanation': 'The President can dissolve the Lok Sabha on the advice of the Prime Minister.',
        'topic': 'Parliament'
      },
      {
        'question': 'The number of judges in the Supreme Court of India (excluding CJI) is:',
        'options': ['30', '33', '34', '35'],
        'correct': 2,
        'explanation': 'The Supreme Court can have up to 34 judges including the Chief Justice of India.',
        'topic': 'Judiciary'
      },
      {
        'question': 'Which article deals with the appointment of judges of the Supreme Court?',
        'options': ['Article 124', 'Article 125', 'Article 126', 'Article 127'],
        'correct': 0,
        'explanation': 'Article 124 deals with the establishment and constitution of the Supreme Court.',
        'topic': 'Judiciary'
      },
      {
        'question': 'The First Amendment to the Indian Constitution was made in:',
        'options': ['1950', '1951', '1952', '1953'],
        'correct': 1,
        'explanation': 'The First Amendment was made in 1951 to add restrictions on freedom of speech.',
        'topic': 'Amendments'
      },
      {
        'question': 'The 42nd Amendment is also known as:',
        'options': ['Mini Constitution', 'Emergency Amendment', 'Fundamental Rights Amendment', 'Basic Structure Amendment'],
        'correct': 0,
        'explanation': 'The 42nd Amendment is called the Mini Constitution as it made extensive changes.',
        'topic': 'Amendments'
      },
      {
        'question': 'How many schedules are there in the Indian Constitution?',
        'options': ['10', '12', '14', '16'],
        'correct': 1,
        'explanation': 'The Indian Constitution originally had 8 schedules, now it has 12 schedules.',
        'topic': 'Constitution'
      },
      {
        'question': 'The concept of Judicial Review is borrowed from:',
        'options': ['UK', 'USA', 'France', 'Canada'],
        'correct': 1,
        'explanation': 'The concept of Judicial Review is borrowed from the USA.',
        'topic': 'Judiciary'
      },
      {
        'question': 'Who can remove the President of India from office?',
        'options': ['Supreme Court', 'Parliament', 'Prime Minister', 'Lok Sabha'],
        'correct': 1,
        'explanation': 'The President can be removed by Parliament through impeachment.',
        'topic': 'Executive'
      },
      {
        'question': 'The Speaker of Lok Sabha is elected by:',
        'options': ['President', 'Members of Lok Sabha', 'Prime Minister', 'Chief Justice'],
        'correct': 1,
        'explanation': 'The Speaker is elected by the members of Lok Sabha.',
        'topic': 'Parliament'
      },
      {
        'question': 'Which Fundamental Right was removed by the 44th Amendment?',
        'options': ['Right to Property', 'Right to Education', 'Right to Information', 'Right to Work'],
        'correct': 0,
        'explanation': 'Right to Property was removed as a Fundamental Right and made a legal right by the 44th Amendment.',
        'topic': 'Fundamental Rights'
      },
      {
        'question': 'The Directive Principles of State Policy are borrowed from:',
        'options': ['USA', 'UK', 'Ireland', 'Canada'],
        'correct': 2,
        'explanation': 'Directive Principles are borrowed from the Irish Constitution.',
        'topic': 'Directive Principles'
      },
      {
        'question': 'Who is known as the Father of the Indian Constitution?',
        'options': ['Jawaharlal Nehru', 'B.R. Ambedkar', 'Mahatma Gandhi', 'Rajendra Prasad'],
        'correct': 1,
        'explanation': 'Dr. B.R. Ambedkar is known as the Father of the Indian Constitution.',
        'topic': 'Constitution'
      },
      {
        'question': 'The duration of a Rajya Sabha member is:',
        'options': ['5 years', '6 years', 'Permanent', '4 years'],
        'correct': 1,
        'explanation': 'Rajya Sabha is permanent, but members serve for 6 years with one-third retiring every 2 years.',
        'topic': 'Parliament'
      },
      {
        'question': 'Which article deals with Fundamental Duties?',
        'options': ['Article 50A', 'Article 51', 'Article 51A', 'Article 52'],
        'correct': 2,
        'explanation': 'Article 51A deals with Fundamental Duties, added by the 42nd Amendment.',
        'topic': 'Fundamental Duties'
      },
      {
        'question': 'The Emergency provisions in the Indian Constitution are borrowed from:',
        'options': ['USA', 'Germany', 'Canada', 'France'],
        'correct': 1,
        'explanation': 'Emergency provisions are borrowed from the Weimar Constitution of Germany.',
        'topic': 'Emergency'
      },
      {
        'question': 'How many types of emergencies are mentioned in the Indian Constitution?',
        'options': ['Two', 'Three', 'Four', 'Five'],
        'correct': 1,
        'explanation': 'Three types: National Emergency, State Emergency, and Financial Emergency.',
        'topic': 'Emergency'
      },
      {
        'question': 'The first Chief Justice of India was:',
        'options': ['H.J. Kania', 'M. Patanjali Sastri', 'B.K. Mukherjea', 'S.R. Das'],
        'correct': 0,
        'explanation': 'H.J. Kania was the first Chief Justice of India.',
        'topic': 'Judiciary'
      },
      {
        'question': 'Who was the first President of India?',
        'options': ['Rajendra Prasad', 'S. Radhakrishnan', 'Zakir Hussain', 'V.V. Giri'],
        'correct': 0,
        'explanation': 'Dr. Rajendra Prasad was the first President of India.',
        'topic': 'Executive'
      },
    ];

    // Generate questions for the requested test
    for (int i = 0; i < questionCount && i < questionTemplates.length; i++) {
      final template = questionTemplates[i % questionTemplates.length];
      questions.add(QuestionModel(
        id: 'q${i + 1}',
        testId: testId,
        question: template['question'] as String,
        options: List<String>.from(template['options'] as List),
        correctAnswerIndex: template['correct'] as int,
        explanation: template['explanation'] as String,
        topic: template['topic'] as String,
      ));
    }

    return questions;
  }

  // Mock AI Recommendation
  String getAIRecommendation(String testId) {
    if (testId == 'test3') {
      return "Your weak areas are: Parliamentary Committees and Constitutional Amendments. Focus on these topics for better performance.";
    }
    return "Keep practicing regularly to improve your performance.";
  }

  // Get Daily Quiz
  Map<String, dynamic> getDailyQuiz() {
    return {
      'id': 'daily_quiz_12',
      'dayNumber': 12,
      'title': 'Daily Quiz - Day 12',
      'totalQuestions': 50,
      'durationMinutes': 20,
      'topics': ['Fundamental Rights', 'Mughal Empire'],
      'isCompleted': false,
      'currentStreak': 12,
    };
  }

  // Get user rank
  int getCurrentRank() {
    return 1250; // Mock rank
  }
}
