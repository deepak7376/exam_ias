import 'package:flutter/material.dart';
import '../../../data/services/polity_content_service.dart';
import '../../../data/models/mains_question_model.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

class MainsPage extends StatefulWidget {
  const MainsPage({super.key});

  @override
  State<MainsPage> createState() => _MainsPageState();
}

class _MainsPageState extends State<MainsPage> {
  final PolityContentService _polityService = PolityContentService();
  late List<MainsQuestionModel> _mainsQuestions;
  final Map<String, TextEditingController> _answerControllers = {};

  @override
  void initState() {
    super.initState();
    _mainsQuestions = _polityService.getMainsQuestions();
    _initializeControllers();
  }

  void _initializeControllers() {
    for (var question in _mainsQuestions) {
      _answerControllers[question.id] = TextEditingController();
    }
  }

  @override
  void dispose() {
    for (var controller in _answerControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        title: const Text('📝 Mains Practice'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            _buildQuestionsList(),
            const SizedBox(height: 24),
            _buildSubmitSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
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
              const Icon(Icons.edit_note, color: Colors.white, size: 32),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Mains Practice',
                      style: AppTextStyles.headline.copyWith(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Descriptive Questions for UPSC Mains',
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: Colors.white70,
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
              _buildHeaderStat('Questions', '${_mainsQuestions.length}'),
              const SizedBox(width: 24),
              _buildHeaderStat('Topics', 'Polity'),
              const SizedBox(width: 24),
              _buildHeaderStat('Time', 'Flexible'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderStat(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: AppTextStyles.headlineSmall.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: Colors.white70,
          ),
        ),
      ],
    );
  }

  Widget _buildQuestionsList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Practice Questions',
          style: AppTextStyles.headlineSmall.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _mainsQuestions.length,
          itemBuilder: (context, index) {
            final question = _mainsQuestions[index];
            return _buildQuestionCard(question, index + 1);
          },
        ),
      ],
    );
  }

  Widget _buildQuestionCard(MainsQuestionModel question, int questionNumber) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
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
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Q$questionNumber',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  '${question.marks} Marks • ${question.wordLimit} Words',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            question.question,
            style: AppTextStyles.bodyLarge.copyWith(
              fontWeight: FontWeight.w600,
              height: 1.4,
            ),
          ),
          if (question.hint != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.info.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.info.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.lightbulb_outline, color: AppColors.info, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Hint: ${question.hint}',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.info,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 16),
          TextField(
            controller: _answerControllers[question.id],
            maxLines: 8,
            decoration: InputDecoration(
              hintText: 'Write your answer here...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.lightGrey),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.primary, width: 2),
              ),
              contentPadding: const EdgeInsets.all(16),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Word Count: ${_getWordCount(question.id)}/${question.wordLimit}',
                style: AppTextStyles.bodySmall.copyWith(
                  color: _getWordCount(question.id) > question.wordLimit
                      ? AppColors.error
                      : AppColors.textSecondary,
                ),
              ),
              if (question.sampleAnswer != null)
                TextButton.icon(
                  onPressed: () => _showSampleAnswer(question),
                  icon: const Icon(Icons.visibility, size: 16),
                  label: const Text('Sample Answer'),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.primary,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.3),
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
              const Icon(Icons.psychology, color: AppColors.primary, size: 24),
              const SizedBox(width: 8),
              Text(
                'AI Evaluation',
                style: AppTextStyles.headlineSmall.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Submit your answers for AI-powered evaluation and feedback. Get detailed analysis of your writing style, content quality, and improvement suggestions.',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: _saveDraft,
                  icon: const Icon(Icons.save),
                  label: const Text('Save Draft'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    side: const BorderSide(color: AppColors.primary),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _submitAnswers,
                  icon: const Icon(Icons.send),
                  label: const Text('Submit for Evaluation'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  int _getWordCount(String questionId) {
    final controller = _answerControllers[questionId];
    if (controller == null) return 0;
    return controller.text.trim().split(RegExp(r'\s+')).where((word) => word.isNotEmpty).length;
  }

  void _showSampleAnswer(MainsQuestionModel question) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Sample Answer - ${question.topic}'),
        content: SingleChildScrollView(
          child: Text(
            question.sampleAnswer ?? 'No sample answer available.',
            style: AppTextStyles.bodyMedium,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _saveDraft() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Draft saved successfully!'),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _submitAnswers() {
    final answeredQuestions = _answerControllers.values
        .where((controller) => controller.text.trim().isNotEmpty)
        .length;

    if (answeredQuestions == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please answer at least one question before submitting.'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Submit for AI Evaluation'),
        content: Text(
          'You have answered $answeredQuestions out of ${_mainsQuestions.length} questions. Do you want to submit for AI evaluation?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _processSubmission();
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  void _processSubmission() {
    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 16),
            Text('Evaluating your answers...'),
          ],
        ),
      ),
    );

    // Simulate AI evaluation
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pop(context); // Close loading dialog
      _showEvaluationResults();
    });
  }

  void _showEvaluationResults() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('AI Evaluation Results'),
        content: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Overall Score: 7.5/10',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(height: 16),
              Text('Strengths:'),
              Text('• Good understanding of constitutional concepts'),
              Text('• Well-structured arguments'),
              Text('• Relevant examples used'),
              SizedBox(height: 12),
              Text('Areas for Improvement:'),
              Text('• Need more current examples'),
              Text('• Improve conclusion writing'),
              Text('• Focus on time management'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
