import 'package:go_router/go_router.dart';
import '../../presentation/pages/onboarding/onboarding_page.dart';
import '../../presentation/pages/home/home_page.dart';
import '../../presentation/pages/subject/subject_page.dart';
import '../../presentation/pages/test/test_page.dart';
import '../../presentation/pages/result/result_page.dart';
import '../../presentation/pages/analytics/analytics_page.dart';
import '../../presentation/pages/profile/profile_page.dart';
import '../../presentation/pages/mains/mains_page.dart';
import '../../presentation/pages/feedback/feedback_page.dart';
import '../../presentation/pages/tests/tests_page.dart';
import '../../presentation/pages/exam_detail/exam_detail_page.dart';

class AppRouter {
  static const String onboarding = '/onboarding';
  static const String home = '/';
  static const String subject = '/subject';
  static const String test = '/test';
  static const String result = '/result';
  static const String analytics = '/analytics';
  static const String profile = '/profile';
  static const String mains = '/mains';
  static const String feedback = '/feedback';
  static const String tests = '/tests';
  static const String exam = '/exam';

  static final GoRouter router = GoRouter(
    initialLocation: onboarding,
    routes: [
      GoRoute(
        path: onboarding,
        builder: (context, state) => const OnboardingPage(),
      ),
      GoRoute(
        path: home,
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '$subject/:subjectId',
        builder: (context, state) {
          final subjectId = state.pathParameters['subjectId']!;
          return SubjectPage(subjectId: subjectId);
        },
      ),
      GoRoute(
        path: '$test/:testId',
        builder: (context, state) {
          final testId = state.pathParameters['testId']!;
          return TestPage(testId: testId);
        },
      ),
      GoRoute(
        path: '$result/:testId',
        builder: (context, state) {
          final testId = state.pathParameters['testId']!;
          return ResultPage(testId: testId);
        },
      ),
      GoRoute(
        path: analytics,
        builder: (context, state) => const AnalyticsPage(),
      ),
      GoRoute(
        path: profile,
        builder: (context, state) => const ProfilePage(),
      ),
      GoRoute(
        path: mains,
        builder: (context, state) => const MainsPage(),
      ),
      GoRoute(
        path: '$feedback/:testId',
        builder: (context, state) {
          final testId = state.pathParameters['testId']!;
          final testTitle = state.uri.queryParameters['title'] ?? 'Test';
          return FeedbackPage(testId: testId, testTitle: testTitle);
        },
      ),
      GoRoute(
        path: tests,
        builder: (context, state) => const TestsPage(),
      ),
      GoRoute(
        path: '$exam/:examId',
        builder: (context, state) {
          final examId = state.pathParameters['examId']!;
          return ExamDetailPage(examId: examId);
        },
      ),
    ],
  );
}
