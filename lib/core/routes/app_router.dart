import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../presentation/pages/auth/login_page.dart';
import '../../presentation/pages/auth/auth_callback_page.dart';
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
  static const String login = '/login';
  static const String authCallback = '/auth/callback';
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

  // Auth state listener
  static final _AuthStateNotifier authStateNotifier = _AuthStateNotifier();
  
  static void init() {
    Supabase.instance.client.auth.onAuthStateChange.listen((authState) {
      final AuthChangeEvent event = authState.event;
      debugPrint('Auth state changed: $event');
      // Force update the router when auth state changes
      authStateNotifier.forceUpdate();
    });
  }

  static final GoRouter router = GoRouter(
    initialLocation: login,
    redirect: (context, state) {
      final session = Supabase.instance.client.auth.currentSession;
      final isLoggedIn = session != null;
      final currentLocation = state.matchedLocation;
      final isLoginRoute = currentLocation == login;
      final isAuthCallbackRoute = currentLocation == authCallback;
      
      // Allow access to auth callback page (OAuth redirect)
      if (isAuthCallbackRoute) {
        return null; // Allow access
      }
      
      // If user is logged in and trying to access login, redirect to home
      if (isLoggedIn && isLoginRoute) {
        return home;
      }
      
      // If user is not logged in and trying to access protected routes, redirect to login
      if (!isLoggedIn && !isLoginRoute) {
        return login;
      }
      
      return null; // No redirect needed
    },
    refreshListenable: authStateNotifier,
    routes: [
      GoRoute(
        path: login,
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: authCallback,
        name: 'authCallback',
        builder: (context, state) => const AuthCallbackPage(),
      ),
      GoRoute(
        path: onboarding,
        name: 'onboarding',
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

/// Helper class to listen to auth state changes for GoRouter
class _AuthStateNotifier extends ChangeNotifier {
  void update() {
    notifyListeners();
  }
  
  // Force a refresh when auth state changes
  void forceUpdate() {
    notifyListeners();
  }
}
