import '../models/chapter_model.dart';
import '../models/test_model.dart';
import '../models/question_model.dart';
import '../models/mains_question_model.dart';

class PolityContentService {
  static final PolityContentService _instance = PolityContentService._internal();
  factory PolityContentService() => _instance;
  PolityContentService._internal();

  // Polity Chapters (10 comprehensive chapters)
  List<ChapterModel> getPolityChapters() {
    return [
      ChapterModel(
        id: 'ch1',
        subjectId: 'polity',
        title: 'Constitution of India',
        description: 'Historical background, making of the Constitution, salient features',
        order: 1,
        totalQuestions: 25,
        isCompleted: false,
      ),
      ChapterModel(
        id: 'ch2',
        subjectId: 'polity',
        title: 'Preamble',
        description: 'Philosophy of the Constitution, key words and concepts',
        order: 2,
        totalQuestions: 25,
        isCompleted: false,
      ),
      ChapterModel(
        id: 'ch3',
        subjectId: 'polity',
        title: 'Fundamental Rights',
        description: 'Articles 12-35, Right to Equality, Freedom, Constitutional Remedies',
        order: 3,
        totalQuestions: 25,
        isCompleted: true,
        accuracy: 75.0,
      ),
      ChapterModel(
        id: 'ch4',
        subjectId: 'polity',
        title: 'Directive Principles',
        description: 'DPSPs, Fundamental Duties, relationship with FRs',
        order: 4,
        totalQuestions: 25,
        isCompleted: true,
        accuracy: 68.0,
      ),
      ChapterModel(
        id: 'ch5',
        subjectId: 'polity',
        title: 'Parliamentary System',
        description: 'Lok Sabha, Rajya Sabha, Parliamentary procedures',
        order: 5,
        totalQuestions: 25,
        isCompleted: false,
      ),
      ChapterModel(
        id: 'ch6',
        subjectId: 'polity',
        title: 'Judiciary System',
        description: 'Supreme Court, High Courts, Judicial Review, PIL',
        order: 6,
        totalQuestions: 25,
        isCompleted: false,
      ),
      ChapterModel(
        id: 'ch7',
        subjectId: 'polity',
        title: 'Constitutional Amendments',
        description: 'Amendment procedure, important amendments',
        order: 7,
        totalQuestions: 25,
        isCompleted: false,
      ),
      ChapterModel(
        id: 'ch8',
        subjectId: 'polity',
        title: 'Federal System',
        description: 'Centre-State relations, 7th Schedule, Finance Commission',
        order: 8,
        totalQuestions: 25,
        isCompleted: false,
      ),
      ChapterModel(
        id: 'ch9',
        subjectId: 'polity',
        title: 'Local Government',
        description: 'Panchayati Raj, Municipalities, 73rd and 74th Amendments',
        order: 9,
        totalQuestions: 25,
        isCompleted: false,
      ),
      ChapterModel(
        id: 'ch10',
        subjectId: 'polity',
        title: 'Constitutional Bodies',
        description: 'Election Commission, UPSC, CAG, Finance Commission',
        order: 10,
        totalQuestions: 25,
        isCompleted: false,
      ),
    ];
  }

  // Chapter-wise Mini Tests
  List<TestModel> getChapterTests() {
    final chapters = getPolityChapters();
    return chapters.map((chapter) {
      return TestModel(
        id: 'test_${chapter.id}',
        subjectId: 'polity',
        title: '${chapter.title} - Mini Test',
        description: chapter.description,
        duration: 30, // 30 minutes for mini tests
        totalQuestions: chapter.totalQuestions,
        status: chapter.isCompleted ? TestStatus.completed : TestStatus.pending,
        score: chapter.accuracy,
        completedAt: chapter.isCompleted ? '2025-01-15' : null,
        canRetake: true,
      );
    }).toList();
  }

  // Full-length Polity Mock Test
  TestModel getFullLengthTest() {
    return TestModel(
      id: 'polity_full_test',
      subjectId: 'polity',
      title: 'Polity Full-Length Mock Test',
      description: 'Complete Polity test covering all chapters (100 questions)',
      duration: 120, // 2 hours
      totalQuestions: 100,
      status: TestStatus.pending,
      canRetake: true,
    );
  }

  // Mains Descriptive Questions
  List<MainsQuestionModel> getMainsQuestions() {
    return [
      MainsQuestionModel(
        id: 'mains_1',
        subjectId: 'polity',
        question: 'Discuss the significance of the Preamble to the Indian Constitution. How does it reflect the philosophy of the Constitution?',
        hint: 'Consider the key words in the Preamble and their constitutional implications',
        wordLimit: 200,
        topic: 'Preamble',
        marks: 10,
        sampleAnswer: 'The Preamble is the soul of the Constitution...',
      ),
      MainsQuestionModel(
        id: 'mains_2',
        subjectId: 'polity',
        question: 'Analyze the relationship between Fundamental Rights and Directive Principles of State Policy. How has the Supreme Court interpreted this relationship?',
        hint: 'Refer to cases like Minerva Mills, Kesavananda Bharati',
        wordLimit: 250,
        topic: 'Fundamental Rights',
        marks: 15,
      ),
      MainsQuestionModel(
        id: 'mains_3',
        subjectId: 'polity',
        question: 'Examine the role of the Supreme Court as the guardian of the Constitution. Discuss with reference to recent judgments.',
        hint: 'Consider judicial review, constitutional interpretation, and recent cases',
        wordLimit: 300,
        topic: 'Judiciary',
        marks: 20,
      ),
    ];
  }

  // Get questions for a specific chapter
  List<QuestionModel> getQuestionsForChapter(String chapterId) {
    final chapterQuestions = _getChapterQuestions();
    return chapterQuestions[chapterId] ?? [];
  }

  // Get questions for full-length test
  List<QuestionModel> getFullLengthTestQuestions() {
    return _getFullLengthTestQuestions();
  }

  // Chapter-wise questions database
  Map<String, List<QuestionModel>> _getChapterQuestions() {
    return {
      'ch1': _getConstitutionQuestions(),
      'ch2': _getPreambleQuestions(),
      'ch3': _getFundamentalRightsQuestions(),
      'ch4': _getDPSPQuestions(),
      'ch5': _getParliamentaryQuestions(),
      'ch6': _getJudiciaryQuestions(),
      'ch7': _getAmendmentQuestions(),
      'ch8': _getFederalQuestions(),
      'ch9': _getLocalGovernmentQuestions(),
      'ch10': _getConstitutionalBodiesQuestions(),
    };
  }

  // Sample questions for each chapter (showing structure)
  List<QuestionModel> _getConstitutionQuestions() {
    return [
      QuestionModel(
        id: 'q1_ch1',
        testId: 'test_ch1',
        question: 'Who was the Chairman of the Drafting Committee of the Constituent Assembly?',
        options: [
          'Dr. B.R. Ambedkar',
          'Jawaharlal Nehru',
          'Dr. Rajendra Prasad',
          'Sardar Vallabhbhai Patel',
        ],
        correctAnswerIndex: 0,
        explanation: 'Dr. B.R. Ambedkar was the Chairman of the Drafting Committee.',
        topic: 'Constitution Making',
      ),
      QuestionModel(
        id: 'q2_ch1',
        testId: 'test_ch1',
        question: 'The Constitution of India was adopted on:',
        options: [
          '26th January 1950',
          '26th November 1949',
          '15th August 1947',
          '2nd October 1949',
        ],
        correctAnswerIndex: 1,
        explanation: 'The Constitution was adopted on 26th November 1949.',
        topic: 'Constitution Making',
      ),
      // Add more questions...
    ];
  }

  List<QuestionModel> _getPreambleQuestions() {
    return [
      QuestionModel(
        id: 'q1_ch2',
        testId: 'test_ch2',
        question: 'Which of the following words was added to the Preamble by the 42nd Amendment?',
        options: [
          'Socialist',
          'Secular',
          'Both Socialist and Secular',
          'None of the above',
        ],
        correctAnswerIndex: 2,
        explanation: 'Both Socialist and Secular were added by the 42nd Amendment.',
        topic: 'Preamble',
      ),
      // Add more questions...
    ];
  }

  List<QuestionModel> _getFundamentalRightsQuestions() {
    return [
      QuestionModel(
        id: 'q1_ch3',
        testId: 'test_ch3',
        question: 'Article 14 of the Constitution deals with:',
        options: [
          'Right to Equality',
          'Right to Freedom',
          'Right against Exploitation',
          'Right to Constitutional Remedies',
        ],
        correctAnswerIndex: 0,
        explanation: 'Article 14 deals with Right to Equality.',
        topic: 'Fundamental Rights',
      ),
      // Add more questions...
    ];
  }

  List<QuestionModel> _getDPSPQuestions() {
    return [
      QuestionModel(
        id: 'q1_ch4',
        testId: 'test_ch4',
        question: 'Directive Principles of State Policy are:',
        options: [
          'Justiciable',
          'Non-justiciable',
          'Partially justiciable',
          'None of the above',
        ],
        correctAnswerIndex: 1,
        explanation: 'DPSPs are non-justiciable in nature.',
        topic: 'Directive Principles',
      ),
      // Add more questions...
    ];
  }

  List<QuestionModel> _getParliamentaryQuestions() {
    return [
      QuestionModel(
        id: 'q1_ch5',
        testId: 'test_ch5',
        question: 'The maximum strength of Lok Sabha is:',
        options: [
          '540',
          '545',
          '550',
          '552',
        ],
        correctAnswerIndex: 2,
        explanation: 'The maximum strength of Lok Sabha is 550.',
        topic: 'Parliament',
      ),
      // Add more questions...
    ];
  }

  List<QuestionModel> _getJudiciaryQuestions() {
    return [
      QuestionModel(
        id: 'q1_ch6',
        testId: 'test_ch6',
        question: 'Who is the guardian of the Constitution of India?',
        options: [
          'Parliament',
          'Supreme Court',
          'President',
          'Prime Minister',
        ],
        correctAnswerIndex: 1,
        explanation: 'The Supreme Court is the guardian of the Constitution.',
        topic: 'Judiciary',
      ),
      // Add more questions...
    ];
  }

  List<QuestionModel> _getAmendmentQuestions() {
    return [
      QuestionModel(
        id: 'q1_ch7',
        testId: 'test_ch7',
        question: 'Which amendment is known as the "Mini Constitution"?',
        options: [
          '42nd Amendment',
          '44th Amendment',
          '73rd Amendment',
          '74th Amendment',
        ],
        correctAnswerIndex: 0,
        explanation: 'The 42nd Amendment is known as the Mini Constitution.',
        topic: 'Constitutional Amendments',
      ),
      // Add more questions...
    ];
  }

  List<QuestionModel> _getFederalQuestions() {
    return [
      QuestionModel(
        id: 'q1_ch8',
        testId: 'test_ch8',
        question: 'The 7th Schedule of the Constitution deals with:',
        options: [
          'Fundamental Rights',
          'Union, State and Concurrent Lists',
          'Directive Principles',
          'Emergency Provisions',
        ],
        correctAnswerIndex: 1,
        explanation: 'The 7th Schedule deals with Union, State and Concurrent Lists.',
        topic: 'Federal System',
      ),
      // Add more questions...
    ];
  }

  List<QuestionModel> _getLocalGovernmentQuestions() {
    return [
      QuestionModel(
        id: 'q1_ch9',
        testId: 'test_ch9',
        question: 'The 73rd Constitutional Amendment deals with:',
        options: [
          'Municipalities',
          'Panchayati Raj',
          'Cooperative Societies',
          'Tribal Areas',
        ],
        correctAnswerIndex: 1,
        explanation: 'The 73rd Amendment deals with Panchayati Raj.',
        topic: 'Local Government',
      ),
      // Add more questions...
    ];
  }

  List<QuestionModel> _getConstitutionalBodiesQuestions() {
    return [
      QuestionModel(
        id: 'q1_ch10',
        testId: 'test_ch10',
        question: 'The Comptroller and Auditor General of India is appointed by:',
        options: [
          'President',
          'Prime Minister',
          'Parliament',
          'Supreme Court',
        ],
        correctAnswerIndex: 0,
        explanation: 'The CAG is appointed by the President.',
        topic: 'Constitutional Bodies',
      ),
      // Add more questions...
    ];
  }

  List<QuestionModel> _getFullLengthTestQuestions() {
    // This would contain 100 questions covering all chapters
    // For now, returning a sample structure
    return [
      QuestionModel(
        id: 'q1_full',
        testId: 'polity_full_test',
        question: 'Who was the Chairman of the Drafting Committee of the Constituent Assembly?',
        options: [
          'Dr. B.R. Ambedkar',
          'Jawaharlal Nehru',
          'Dr. Rajendra Prasad',
          'Sardar Vallabhbhai Patel',
        ],
        correctAnswerIndex: 0,
        explanation: 'Dr. B.R. Ambedkar was the Chairman of the Drafting Committee.',
        topic: 'Constitution Making',
      ),
      // Add 99 more questions covering all topics...
    ];
  }
}
