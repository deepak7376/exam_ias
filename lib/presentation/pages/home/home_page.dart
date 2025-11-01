import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../data/services/mock_data_service.dart';
import '../../../data/services/subject_content_service.dart';
import '../../../data/services/exam_service.dart';
import '../../../data/models/user_model.dart';
import '../../../data/models/subject_model.dart';
import '../../../data/models/exam_model.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final MockDataService _mockDataService = MockDataService();
  final SubjectContentService _subjectContentService = SubjectContentService();
  final ExamService _examService = ExamService();
  late UserModel _user;
  late List<SubjectModel> _subjects;
  late Map<String, dynamic> _overallProgress;
  late List<Map<String, dynamic>> _recommendations;
  late Map<String, dynamic> _examProgress;
  late List<ExamModel> _exams;
  int _currentIndex = 0;
  int _selectedSubjectIndex = 0;

  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      _user = await _mockDataService.getCurrentUser();
      _subjects = await _subjectContentService.getAllSubjectsWithContent();
      _overallProgress = await _subjectContentService.getOverallProgress();
      _recommendations = await _subjectContentService.getSmartRecommendations();
      _examProgress = await _examService.getUserProgress();
      _exams = await _examService.getAllExams();
      _loadCurrentSubjectContent();
      
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = 'Failed to load data: $e';
      });
    }
  }

  void _loadCurrentSubjectContent() {
    // Load current subject content if needed
  }

  void _onSubjectChanged(int index) {
    setState(() {
      _selectedSubjectIndex = index;
      _loadCurrentSubjectContent();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Error: $_error', style: AppTextStyles.bodyMedium),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadData,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: _buildDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: _buildBody(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    // Split name for wireframe format "Hi Deepak, Yadav"
    final nameParts = _user.name.split(' ');
    final firstName = nameParts.isNotEmpty ? nameParts[0] : '';
    final lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.15), // Lighter header
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Builder(
                    builder: (context) => IconButton(
                      icon: const Icon(
                        Icons.menu,
                        color: AppColors.primary,
                        size: 28,
                      ),
                      onPressed: () => Scaffold.of(context).openDrawer(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'IAS Test Series',
                    style: AppTextStyles.headline.copyWith(
                      color: AppColors.primary,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.notifications_outlined,
                  color: AppColors.primary,
                  size: 22,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Hi $firstName, $lastName',
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Divider(height: 24, thickness: 1),
        ],
      ),
    );
  }

  Widget _buildOverallPerformanceCard() {
    final currentRank = _mockDataService.getCurrentRank();
    final completedTests = _overallProgress['completedTests'] ?? 0;
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Overall Performance',
            style: AppTextStyles.headlineSmall.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatItem('Progress', '${_overallProgress['overallProgress'].toInt()}%', Icons.trending_up),
              ),
              Expanded(
                child: _buildStatItem('Accuracy', '${_user.averageAccuracy.toInt()}%', Icons.gps_fixed),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildStatItem('Tests', '$completedTests', Icons.quiz),
              ),
              Expanded(
                child: _buildStatItem('Rank', '#$currentRank', Icons.emoji_events),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: AppColors.primary),
            const SizedBox(width: 4),
            Text(
              value,
              style: AppTextStyles.headlineSmall.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }


  Widget _buildBody() {
    switch (_currentIndex) {
      case 0:
        return _buildHomeContent();
      case 1:
        return _buildTestsContent();
      case 2:
        return _buildAnalyticsContent();
      case 3:
        return _buildProfileContent();
      default:
        return _buildHomeContent();
    }
  }

  Widget _buildHomeContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildOverallPerformanceCard(),
          const SizedBox(height: 20),
          _buildDailyQuizChallenge(),
          const SizedBox(height: 20),
          _buildBrowseSubjects(),
          const SizedBox(height: 20),
          _buildSmartRecommendations(),
          const SizedBox(height: 20),
          _buildQuickActions(),
        ],
      ),
    );
  }

  Widget _buildDailyQuizChallenge() {
    final dailyQuiz = _mockDataService.getDailyQuiz();
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Daily Quiz Challenge',
            style: AppTextStyles.headlineSmall.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Complete today test to maintain you steak',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.primary.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      dailyQuiz['title'],
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.warning.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '🔥 ${dailyQuiz['currentStreak']} days',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.warning,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '${dailyQuiz['totalQuestions']} quess. ${dailyQuiz['durationMinutes']} min',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Topics: ${(dailyQuiz['topics'] as List).join(' ')}',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () => context.go('/test/${dailyQuiz['id']}'),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'start Quiz',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBrowseSubjects() {
    final totalSubjects = 15; // Total subjects in UPSC prep
    final progressSubjects = 2; // Subjects in progress
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Browse Subjects',
            style: AppTextStyles.headlineSmall.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Complete subject for UPSC prep',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '$progressSubjects/$totalSubjects progess. Tests subject',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Navigate to subjects page or show subject selector
                _showSubjectSelector();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Start Learning'),
            ),
          ),
        ],
      ),
    );
  }

  void _showSubjectSelector() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Select Subject',
              style: AppTextStyles.headlineSmall.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ..._subjects.map((subject) {
              return ListTile(
                leading: Text(subject.icon, style: const TextStyle(fontSize: 24)),
                title: Text(subject.name),
                trailing: subject.isAvailable 
                    ? const Icon(Icons.check_circle, color: AppColors.success)
                    : const Icon(Icons.lock, color: AppColors.disabled),
                onTap: subject.isAvailable 
                    ? () {
                        Navigator.pop(context);
                        context.go('/subject/${subject.id}');
                      }
                    : null,
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildCrossSubjectOverview() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.dashboard, color: AppColors.primary, size: 24),
              const SizedBox(width: 8),
              Text(
                'Cross-Subject Overview',
                style: AppTextStyles.headlineSmall.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ..._overallProgress['subjectProgresses'].map<Widget>((progress) {
            final subject = _subjects.firstWhere((s) => s.id == progress['subjectId']);
            return _buildSubjectProgressItem(subject, progress);
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildSubjectProgressItem(SubjectModel subject, Map<String, dynamic> progress) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: progress['isAvailable'] 
            ? AppColors.primary.withOpacity(0.1) 
            : AppColors.disabled.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: progress['isAvailable'] 
              ? AppColors.primary.withOpacity(0.3) 
              : AppColors.disabled.withOpacity(0.3),
        ),
      ),
      child: Row(
        children: [
          Text(
            subject.icon,
            style: const TextStyle(fontSize: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  subject.name,
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                    color: progress['isAvailable'] ? AppColors.textPrimary : AppColors.textSecondary,
                  ),
                ),
                Text(
                  progress['isAvailable'] 
                      ? '${progress['completedChapters']}/${progress['totalChapters']} chapters'
                      : 'Coming Soon',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          if (progress['isAvailable']) ...[
            CircularProgressIndicator(
              value: progress['overallProgress'] / 100,
              strokeWidth: 3,
              color: AppColors.primary,
            ),
            const SizedBox(width: 8),
            Text(
              '${progress['overallProgress'].toInt()}%',
              style: AppTextStyles.bodySmall.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ] else
            const Icon(Icons.lock, color: AppColors.disabled, size: 20),
        ],
      ),
    );
  }

  Widget _buildCurrentSubjectContent() {
    final currentSubject = _subjects[_selectedSubjectIndex];
    // This will need to be wrapped in FutureBuilder or load async
    return FutureBuilder<Map<String, dynamic>>(
      future: _subjectContentService.getSubjectProgress(currentSubject.id),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final subjectProgress = snapshot.data!;
        
        if (!subjectProgress['isAvailable']) {
          return _buildComingSoonCard(currentSubject);
        }
        
        return _buildSubjectModuleCard(currentSubject, subjectProgress);
      },
    );
  }

  Widget _buildSubjectModuleCard(SubjectModel subject, Map<String, dynamic> progress) {
    final completedChapters = progress['completedChapters'];
    final totalChapters = progress['totalChapters'];
    final chapterProgress = progress['chapterProgress'];

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primaryLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(subject.icon, style: const TextStyle(fontSize: 32)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${subject.name} Module',
                      style: AppTextStyles.headline.copyWith(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Complete preparation for UPSC ${subject.name}',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildModuleStat('Chapters', '$completedChapters/$totalChapters', Colors.white),
              ),
              Expanded(
                child: _buildModuleStat('Progress', '${chapterProgress.toInt()}%', Colors.white),
              ),
              Expanded(
                child: _buildModuleStat('Tests', '${progress['totalTests']}', Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 20),
          LinearProgressIndicator(
            value: chapterProgress / 100,
            backgroundColor: Colors.white.withOpacity(0.3),
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            minHeight: 8,
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => context.go('/subject/${subject.id}'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Continue Learning'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModuleStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: AppTextStyles.headlineSmall.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: color.withOpacity(0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildComingSoonCard(SubjectModel subject) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.disabled.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Text(subject.icon, style: const TextStyle(fontSize: 48)),
          const SizedBox(height: 16),
          Text(
            '${subject.name} Module',
            style: AppTextStyles.headlineSmall.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Coming Soon!',
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.disabled.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.schedule, color: AppColors.disabled, size: 16),
                const SizedBox(width: 8),
                Text(
                  'Under Development',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.disabled,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSmartRecommendations() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.lightbulb, color: AppColors.warning, size: 24),
            const SizedBox(width: 8),
            Text(
              'Smart Recommendations',
              style: AppTextStyles.headlineSmall.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ..._recommendations.map((recommendation) => _buildRecommendationCard(recommendation)).toList(),
      ],
    );
  }

  Widget _buildRecommendationCard(Map<String, dynamic> recommendation) {
    Color priorityColor;
    IconData priorityIcon;
    
    switch (recommendation['priority']) {
      case 'high':
        priorityColor = AppColors.error;
        priorityIcon = Icons.priority_high;
        break;
      case 'medium':
        priorityColor = AppColors.warning;
        priorityIcon = Icons.info;
        break;
      default:
        priorityColor = AppColors.success;
        priorityIcon = Icons.check_circle;
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: priorityColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: priorityColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(priorityIcon, color: priorityColor, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  recommendation['title'],
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                    color: priorityColor,
                  ),
                ),
                Text(
                  recommendation['description'],
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              // Handle recommendation action
            },
            child: Text(
              recommendation['action'],
              style: AppTextStyles.bodySmall.copyWith(
                color: priorityColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: AppTextStyles.headlineSmall.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildQuickActionCard(
                'Continue Test',
                'Resume your last test',
                Icons.play_arrow,
                AppColors.primary,
                () => context.go('/test/polity_test_3'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildQuickActionCard(
                'Practice',
                'Quick practice session',
                Icons.psychology,
                AppColors.info,
                () => context.go('/subject/polity'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildQuickActionCard(
                'Review',
                'Review your progress',
                Icons.analytics,
                AppColors.success,
                () => context.go('/analytics'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildQuickActionCard(
                'Tests',
                'Take real exams',
                Icons.quiz,
                AppColors.warning,
                () => context.go('/tests'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActionCard(String title, String subtitle, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              title,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
            Text(
              subtitle,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTestsContent() {
    return RefreshIndicator(
      onRefresh: () async {
        // Future: Fetch from backend
        final examProgress = await _examService.getUserProgress();
        final exams = await _examService.getAllExams();
        setState(() {
          _examProgress = examProgress;
          _exams = exams;
        });
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildExamProgressOverview(),
            const SizedBox(height: 24),
            _buildExamsList(),
            const SizedBox(height: 24),
            _buildScheduleCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildExamProgressOverview() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primaryLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.analytics, color: Colors.white, size: 32),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Exam Progress',
                      style: AppTextStyles.headline.copyWith(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${_examProgress['completed']}/${_examProgress['total']} Exams Completed',
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildExamProgressStat('Completed', '${_examProgress['completed']}', Colors.white),
              ),
              Expanded(
                child: _buildExamProgressStat('Available', '${_examProgress['available']}', Colors.white),
              ),
              Expanded(
                child: _buildExamProgressStat('Locked', '${_examProgress['locked']}', Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: _examProgress['completionRate'] / 100,
            backgroundColor: Colors.white.withOpacity(0.3),
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            minHeight: 8,
          ),
        ],
      ),
    );
  }

  Widget _buildExamProgressStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: AppTextStyles.headlineSmall.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: color.withOpacity(0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildExamsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Available Exams',
          style: AppTextStyles.headlineSmall.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ..._exams.map((exam) => _buildExamCard(exam)).toList(),
      ],
    );
  }

  Widget _buildExamCard(ExamModel exam) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _getExamStatusColor(exam.status).withOpacity(0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: _getExamStatusColor(exam.status).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.quiz,
                  color: _getExamStatusColor(exam.status),
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exam.title,
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      exam.description,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              _buildExamStatusBadge(exam.status),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildExamInfo('🕐 ${_getTotalDuration(exam)}h Total'),
              const SizedBox(width: 16),
              _buildExamInfo('📊 ${_getTotalQuestions(exam)} Questions'),
              const SizedBox(width: 16),
              _buildExamInfo('🎯 ${_getTotalMarks(exam)} Marks'),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildExamInfo('📝 Prelims: 2 Papers'),
              const SizedBox(width: 16),
              _buildExamInfo('📝 Mains: 2 Papers'),
            ],
          ),
          if (exam.userScore != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.success.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.emoji_events, color: AppColors.success, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    'Your Score: ${exam.userScore!.toStringAsFixed(1)}%',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.success,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: _buildExamAction(exam),
          ),
        ],
      ),
    );
  }

  Widget _buildExamAction(ExamModel exam) {
    switch (exam.status) {
      case ExamStatus.available:
        return ElevatedButton(
          onPressed: () => _startExam(exam),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text('Start Exam'),
        );
      case ExamStatus.completed:
        return Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => _viewResults(exam),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  side: const BorderSide(color: AppColors.primary),
                ),
                child: const Text('View Results'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: () => _startExam(exam),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Retake'),
              ),
            ),
          ],
        );
      case ExamStatus.locked:
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.pending.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppColors.pending.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.lock, color: AppColors.pending, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    'Releases ${_formatDate(exam.releaseDate)}',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.pending,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                '${_getDaysUntilRelease(exam.releaseDate)} days remaining',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        );
      case ExamStatus.expired:
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.error.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppColors.error.withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.schedule, color: AppColors.error, size: 16),
              const SizedBox(width: 8),
              Text(
                'Exam Period Ended',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        );
    }
  }

  Future<Map<String, dynamic>> _loadScheduleData() async {
    final nextRelease = await _examService.getNextExamReleaseDate();
    final daysUntilNext = await _examService.getDaysUntilNextExam();
    final currentQuarter = _examService.getCurrentQuarter();
    return {
      'nextRelease': nextRelease,
      'daysUntilNext': daysUntilNext,
      'currentQuarter': currentQuarter,
    };
  }

  Widget _buildScheduleCard() {
    return FutureBuilder<Map<String, dynamic>>(
      future: _loadScheduleData(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        final data = snapshot.data!;
        final nextRelease = data['nextRelease'] as DateTime?;
        final daysUntilNext = data['daysUntilNext'] as int;
        final currentQuarter = data['currentQuarter'] as String;

        return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.warning.withOpacity(0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.schedule, color: AppColors.warning, size: 24),
              const SizedBox(width: 8),
              Text(
                'Exam Schedule',
                style: AppTextStyles.headlineSmall.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildScheduleItem('Current Quarter', currentQuarter),
              ),
              Expanded(
                child: _buildScheduleItem('Next Release', nextRelease != null ? _formatDate(nextRelease) : 'All Released'),
              ),
            ],
          ),
          if (daysUntilNext > 0) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.warning.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.warning.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.timer, color: AppColors.warning, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Next exam releases in $daysUntilNext days',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.warning,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
        );
      },
    );
  }

  Widget _buildScheduleItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Color _getExamStatusColor(ExamStatus status) {
    switch (status) {
      case ExamStatus.available:
        return AppColors.success;
      case ExamStatus.locked:
        return AppColors.pending;
      case ExamStatus.expired:
        return AppColors.error;
      case ExamStatus.completed:
        return AppColors.success;
    }
  }

  Widget _buildExamStatusBadge(ExamStatus status) {
    String text;
    Color color;

    switch (status) {
      case ExamStatus.available:
        text = 'Available';
        color = AppColors.success;
        break;
      case ExamStatus.locked:
        text = 'Locked';
        color = AppColors.pending;
        break;
      case ExamStatus.expired:
        text = 'Expired';
        color = AppColors.error;
        break;
      case ExamStatus.completed:
        text = 'Completed';
        color = AppColors.success;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        text,
        style: AppTextStyles.bodySmall.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildExamInfo(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: AppTextStyles.bodySmall.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  int _getTotalDuration(ExamModel exam) {
    return (exam.prelimsDuration + exam.mainsDuration) ~/ 60;
  }

  int _getTotalQuestions(ExamModel exam) {
    return exam.prelimsQuestions + exam.mainsQuestions;
  }

  int _getTotalMarks(ExamModel exam) {
    return exam.prelimsMarks + exam.mainsMarks;
  }

  String _formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }

  int _getDaysUntilRelease(DateTime releaseDate) {
    final now = DateTime.now();
    return releaseDate.difference(now).inDays;
  }

  void _startExam(ExamModel exam) {
    // Navigate to exam detail page
    context.go('/exam/${exam.id}');
  }

  void _viewResults(ExamModel exam) {
    // Navigate to results page
    context.go('/result/${exam.id}');
  }

  Widget _buildAnalyticsContent() {
    return const Center(
      child: Text('Analytics Page - Coming Soon'),
    );
  }

  Widget _buildProfileContent() {
    return const Center(
      child: Text('Profile Page - Coming Soon'),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: AppColors.cardBackground,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // Drawer Header
          Container(
            padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: AppColors.primary,
                  child: Text(
                    _user.name.substring(0, 1).toUpperCase(),
                    style: AppTextStyles.headlineSmall.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  _user.name,
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _user.email,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          
          // Navigation Items
          _buildDrawerItem(
            icon: Icons.home,
            title: 'Home',
            index: 0,
          ),
          _buildDrawerItem(
            icon: Icons.quiz,
            title: 'Tests',
            index: 1,
          ),
          _buildDrawerItem(
            icon: Icons.analytics,
            title: 'Analytics',
            index: 2,
          ),
          _buildDrawerItem(
            icon: Icons.person,
            title: 'Profile',
            index: 3,
          ),
          
          const Divider(),
          
          // Additional Menu Items
          ListTile(
            leading: const Icon(Icons.settings, color: AppColors.textSecondary),
            title: Text(
              'Settings',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              // Navigate to settings
            },
          ),
          ListTile(
            leading: const Icon(Icons.help_outline, color: AppColors.textSecondary),
            title: Text(
              'Help & Support',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              // Navigate to help
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: AppColors.error),
            title: Text(
              'Logout',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.error,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
              // Handle logout
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required int index,
  }) {
    final isSelected = _currentIndex == index;
    
    return ListTile(
      selected: isSelected,
      selectedTileColor: AppColors.primary.withOpacity(0.1),
      leading: Icon(
        icon,
        color: isSelected ? AppColors.primary : AppColors.textSecondary,
      ),
      title: Text(
        title,
        style: AppTextStyles.bodyMedium.copyWith(
          color: isSelected ? AppColors.primary : AppColors.textPrimary,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      onTap: () {
        Navigator.pop(context); // Close drawer
        setState(() {
          _currentIndex = index;
        });
      },
    );
  }
}