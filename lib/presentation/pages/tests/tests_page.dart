import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../data/services/exam_service.dart';
import '../../../data/models/exam_model.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

class TestsPage extends StatefulWidget {
  const TestsPage({super.key});

  @override
  State<TestsPage> createState() => _TestsPageState();
}

class _TestsPageState extends State<TestsPage> {
  final ExamService _examService = ExamService();
  late Map<String, dynamic> _userProgress;

  @override
  void initState() {
    super.initState();
    _loadExams();
  }

  void _loadExams() {
    _userProgress = _examService.getUserProgress();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        title: const Text('📝 Tests'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProgressOverview(),
            const SizedBox(height: 24),
            _buildExamsList(),
            const SizedBox(height: 24),
            _buildScheduleCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressOverview() {
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
                      '${_userProgress['completed']}/${_userProgress['total']} Exams Completed',
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
                child: _buildProgressStat('Completed', '${_userProgress['completed']}', Colors.white),
              ),
              Expanded(
                child: _buildProgressStat('Available', '${_userProgress['available']}', Colors.white),
              ),
              Expanded(
                child: _buildProgressStat('Locked', '${_userProgress['locked']}', Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: _userProgress['completionRate'] / 100,
            backgroundColor: Colors.white.withOpacity(0.3),
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            minHeight: 8,
          ),
        ],
      ),
    );
  }

  Widget _buildProgressStat(String label, String value, Color color) {
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
    final allExams = _examService.getAllExams();
    
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
        ...allExams.map((exam) => _buildExamCard(exam)).toList(),
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

  Widget _buildScheduleCard() {
    final nextRelease = _examService.getNextExamReleaseDate();
    final daysUntilNext = _examService.getDaysUntilNextExam();
    final currentQuarter = _examService.getCurrentQuarter();

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

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  int _getDaysUntilRelease(DateTime releaseDate) {
    final now = DateTime.now();
    return releaseDate.difference(now).inDays;
  }

  void _startExam(ExamModel exam) {
    // Navigate to exam detail page
    context.go('/exam/${exam.id}');
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

  int _getTotalDuration(ExamModel exam) {
    return (exam.prelimsDuration + exam.mainsDuration) ~/ 60;
  }

  int _getTotalQuestions(ExamModel exam) {
    return exam.prelimsQuestions + exam.mainsQuestions;
  }

  int _getTotalMarks(ExamModel exam) {
    return exam.prelimsMarks + exam.mainsMarks;
  }

  void _viewResults(ExamModel exam) {
    // Navigate to results page
    context.go('/results/${exam.id}');
  }
}
