import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../data/services/mock_data_service.dart';
import '../../../data/services/subject_content_service.dart';
import '../../../data/models/user_model.dart';
import '../../../data/models/subject_model.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final MockDataService _mockDataService = MockDataService();
  final SubjectContentService _subjectContentService = SubjectContentService();
  late UserModel _user;
  late List<SubjectModel> _subjects;
  late Map<String, dynamic> _overallProgress;
  late List<Map<String, dynamic>> _recommendations;
  int _currentIndex = 0;
  int _selectedSubjectIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    _user = _mockDataService.getCurrentUser();
    _subjects = _subjectContentService.getAllSubjectsWithContent();
    _overallProgress = _subjectContentService.getOverallProgress();
    _recommendations = _subjectContentService.getSmartRecommendations();
    _loadCurrentSubjectContent();
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
    return Scaffold(
      backgroundColor: AppColors.background,
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
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary,
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'IAS Test Series 🏛️',
                    style: AppTextStyles.headline.copyWith(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '👤 Hi, ${_user.name}',
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.notifications_outlined,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildOverallProgressCard(),
          const SizedBox(height: 16),
          _buildSubjectSelector(),
        ],
      ),
    );
  }

  Widget _buildOverallProgressCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Overall Progress',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: Colors.white70,
                  ),
                ),
                Text(
                  '${_overallProgress['overallProgress'].toInt()}% 📈',
                  style: AppTextStyles.headlineSmall.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              Text(
                '${_overallProgress['completedChapters']}/${_overallProgress['totalChapters']}',
                style: AppTextStyles.bodySmall.copyWith(
                  color: Colors.white70,
                ),
              ),
              Text(
                'Chapters',
                style: AppTextStyles.bodySmall.copyWith(
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectSelector() {
    return Container(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _subjects.length,
        itemBuilder: (context, index) {
          final subject = _subjects[index];
          final isSelected = index == _selectedSubjectIndex;
          final subjectProgress = _subjectContentService.getSubjectProgress(subject.id);
          
          return GestureDetector(
            onTap: () => _onSubjectChanged(index),
            child: Container(
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? Colors.white : Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: isSelected ? Colors.white : Colors.white.withOpacity(0.5),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    subject.icon,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    subject.name,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: isSelected ? AppColors.primary : Colors.white,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                  if (subjectProgress['isAvailable']) ...[
                    const SizedBox(width: 8),
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.success : Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
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
          _buildCrossSubjectOverview(),
          const SizedBox(height: 24),
          _buildCurrentSubjectContent(),
          const SizedBox(height: 24),
          _buildSmartRecommendations(),
          const SizedBox(height: 24),
          _buildQuickActions(),
        ],
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
    final subjectProgress = _subjectContentService.getSubjectProgress(currentSubject.id);
    
    if (!subjectProgress['isAvailable']) {
      return _buildComingSoonCard(currentSubject);
    }
    
    return _buildSubjectModuleCard(currentSubject, subjectProgress);
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
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.quiz, size: 64, color: AppColors.primary),
          const SizedBox(height: 16),
          Text(
            'Real Exam Experience',
            style: AppTextStyles.headlineSmall.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Take full-length Prelims and Mains mock tests',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => context.go('/tests'),
            icon: const Icon(Icons.arrow_forward),
            label: const Text('Go to Tests'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
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

  Widget _buildBottomNavigation() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      onTap: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.textSecondary,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.quiz),
          label: 'Tests',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.analytics),
          label: 'Analytics',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }
}