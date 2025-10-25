import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../data/services/mock_data_service.dart';
import '../../../data/services/polity_content_service.dart';
import '../../../data/models/test_model.dart';
import '../../../data/models/chapter_model.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

class SubjectPage extends StatefulWidget {
  final String subjectId;

  const SubjectPage({super.key, required this.subjectId});

  @override
  State<SubjectPage> createState() => _SubjectPageState();
}

class _SubjectPageState extends State<SubjectPage> {
  final MockDataService _mockDataService = MockDataService();
  final PolityContentService _polityService = PolityContentService();
  late List<TestModel> _tests;
  late List<ChapterModel> _chapters;
  String _subjectName = '';

  @override
  void initState() {
    super.initState();
    _loadTests();
  }

  void _loadTests() {
    if (widget.subjectId == 'polity') {
      _tests = _polityService.getChapterTests();
      _tests.add(_polityService.getFullLengthTest());
      _chapters = _polityService.getPolityChapters();
    } else {
      _tests = _mockDataService.getTestsForSubject(widget.subjectId);
      _chapters = [];
    }
    _subjectName = _getSubjectName(widget.subjectId);
  }

  String _getSubjectName(String subjectId) {
    switch (subjectId) {
      case 'polity':
        return 'Polity';
      case 'geography':
        return 'Geography';
      case 'economy':
        return 'Economy';
      default:
        return 'Subject';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        title: Text('$_subjectName 📘'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSubjectStats(),
            const SizedBox(height: 24),
            _buildTestsList(),
          ],
        ),
      ),
    );
  }

  Widget _buildSubjectStats() {
    final completedTests = _tests.where((test) => test.status == TestStatus.completed).length;
    final averageScore = _tests
        .where((test) => test.score != null)
        .map((test) => test.score!)
        .fold(0.0, (sum, score) => sum + score) / 
        (_tests.where((test) => test.score != null).length);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
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
              Text(
                '${_tests.length} Tests',
                style: AppTextStyles.headlineSmall.copyWith(
                  color: AppColors.primary,
                ),
              ),
              const Spacer(),
              Text(
                'Avg Score: ${averageScore.toStringAsFixed(0)}%',
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.success,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Completed: $completedTests/${_tests.length} ✅',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTestsList() {
    if (widget.subjectId == 'polity') {
      return _buildPolityModule();
    } else {
      return _buildRegularTests();
    }
  }

  Widget _buildPolityModule() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildModuleOverview(),
        const SizedBox(height: 24),
        _buildChapterTests(),
        const SizedBox(height: 24),
        _buildFullLengthTest(),
        const SizedBox(height: 24),
        _buildMainsPractice(),
      ],
    );
  }

  Widget _buildModuleOverview() {
    final completedChapters = _chapters.where((ch) => ch.isCompleted).length;
    final totalChapters = _chapters.length;
    final progress = (completedChapters / totalChapters) * 100;

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
              const Text('📘', style: TextStyle(fontSize: 32)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Indian Polity Module',
                      style: AppTextStyles.headline.copyWith(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Complete preparation for UPSC Polity',
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
                child: _buildModuleStat('Progress', '${progress.toInt()}%', Colors.white),
              ),
              Expanded(
                child: _buildModuleStat('Tests', '${_tests.length}', Colors.white),
              ),
            ],
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

  Widget _buildChapterTests() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Chapter-wise Tests',
          style: AppTextStyles.headlineSmall.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _chapters.length,
          itemBuilder: (context, index) {
            final chapter = _chapters[index];
            return _buildChapterCard(chapter);
          },
        ),
      ],
    );
  }

  Widget _buildChapterCard(ChapterModel chapter) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: chapter.isCompleted ? AppColors.success : AppColors.lightGrey,
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
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: chapter.isCompleted ? AppColors.success : AppColors.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    '${chapter.order}',
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      chapter.title,
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      chapter.description,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              if (chapter.isCompleted)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Icon(Icons.check_circle, color: AppColors.success),
                    Text(
                      '${chapter.accuracy?.toInt()}%',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.success,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                )
              else
                const Icon(Icons.play_circle_outline, color: AppColors.primary),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildTestInfo('🕑 30 min'),
              const SizedBox(width: 16),
              _buildTestInfo('${chapter.totalQuestions} Qs'),
              const Spacer(),
              if (chapter.isCompleted)
                Text(
                  'Score: ${chapter.accuracy?.toStringAsFixed(0)}%',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.success,
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => context.go('/test/test_${chapter.id}'),
              style: ElevatedButton.styleFrom(
                backgroundColor: chapter.isCompleted ? AppColors.success : AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                chapter.isCompleted ? 'Retake Test' : 'Take Test',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFullLengthTest() {
    final fullTest = _tests.last; // Full length test is the last one
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Full-Length Mock Test',
          style: AppTextStyles.headlineSmall.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.primary,
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
                  const Icon(Icons.quiz, color: AppColors.primary, size: 32),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          fullTest.title,
                          style: AppTextStyles.bodyLarge.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          fullTest.description,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _buildTestInfo('🕑 ${fullTest.duration} min'),
                  const SizedBox(width: 16),
                  _buildTestInfo('${fullTest.totalQuestions} Qs'),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Mock Test',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => context.go('/test/${fullTest.id}'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Take Full Test'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMainsPractice() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Mains Practice',
          style: AppTextStyles.headlineSmall.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.info.withOpacity(0.3),
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
                  const Icon(Icons.edit_note, color: AppColors.info, size: 32),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Descriptive Questions',
                          style: AppTextStyles.bodyLarge.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Practice answer writing for UPSC Mains',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _buildTestInfo('📝 3 Questions'),
                  const SizedBox(width: 16),
                  _buildTestInfo('🤖 AI Evaluation'),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.info.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Mains',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.info,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => context.go('/mains'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.info,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Start Mains Practice'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRegularTests() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Available Tests',
          style: AppTextStyles.headlineSmall.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _tests.length,
          itemBuilder: (context, index) {
            final test = _tests[index];
            return _buildTestCard(test);
          },
        ),
      ],
    );
  }

  Widget _buildTestCard(TestModel test) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _getStatusColor(test.status).withOpacity(0.3),
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      test.title,
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      test.description,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              _buildStatusIcon(test.status),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildTestInfo('🕑 ${test.duration} min'),
              const SizedBox(width: 16),
              _buildTestInfo('${test.totalQuestions} Qs'),
              const Spacer(),
              if (test.score != null)
                Text(
                  'Score: ${test.score!.toStringAsFixed(0)}%',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.success,
                    fontWeight: FontWeight.w600,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          _buildStatusText(test),
          const SizedBox(height: 12),
          _buildActionButton(test),
        ],
      ),
    );
  }

  Widget _buildStatusIcon(TestStatus status) {
    IconData icon;
    Color color;
    
    switch (status) {
      case TestStatus.completed:
        icon = Icons.check_circle;
        color = AppColors.success;
        break;
      case TestStatus.retry:
        icon = Icons.refresh;
        color = AppColors.retry;
        break;
      case TestStatus.pending:
        icon = Icons.schedule;
        color = AppColors.pending;
        break;
    }

    return Icon(icon, color: color, size: 24);
  }

  Widget _buildTestInfo(String text) {
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

  Widget _buildStatusText(TestModel test) {
    String statusText;
    Color statusColor;
    
    switch (test.status) {
      case TestStatus.completed:
        statusText = 'Status: ✅ Completed';
        statusColor = AppColors.success;
        break;
      case TestStatus.retry:
        statusText = 'Status: 🔁 Retry Available';
        statusColor = AppColors.retry;
        break;
      case TestStatus.pending:
        statusText = 'Status: ⏳ Pending';
        statusColor = AppColors.pending;
        break;
    }

    return Text(
      statusText,
      style: AppTextStyles.bodyMedium.copyWith(
        color: statusColor,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildActionButton(TestModel test) {
    String buttonText;
    VoidCallback? onPressed;
    
    switch (test.status) {
      case TestStatus.completed:
        buttonText = 'View Result';
        onPressed = () => context.go('/result/${test.id}');
        break;
      case TestStatus.retry:
        buttonText = 'Retake Test';
        onPressed = () => context.go('/test/${test.id}');
        break;
      case TestStatus.pending:
        buttonText = 'Take Test';
        onPressed = () => context.go('/test/${test.id}');
        break;
    }

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          buttonText,
          style: AppTextStyles.buttonMedium,
        ),
      ),
    );
  }

  Color _getStatusColor(TestStatus status) {
    switch (status) {
      case TestStatus.completed:
        return AppColors.success;
      case TestStatus.retry:
        return AppColors.retry;
      case TestStatus.pending:
        return AppColors.pending;
    }
  }
}
