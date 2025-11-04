import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../services/mock_data_service.dart';
import '../../../data/models/question_model.dart';
import '../../../data/models/test_model.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/routes/app_router.dart';
import 'dart:async';

class TestPage extends StatefulWidget {
  final String testId;

  const TestPage({super.key, required this.testId});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  final MockDataService _mockDataService = MockDataService();
  List<QuestionModel> _questions = [];
  TestModel? _test;
  Timer? _timer;
  int _currentQuestionIndex = 0;
  int _timeRemaining = 0; // in seconds
  Map<String, int> _userAnswers = {};
  Map<String, bool> _markedForReview = {};

  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _loadQuestions() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Load questions from API
      _questions = await _mockDataService.getQuestionsForTest(widget.testId);
      
      // Try to find test model for duration
      TestModel? foundTest;
      final subjects = await _mockDataService.getSubjects();
      for (var subject in subjects) {
        try {
          final tests = await _mockDataService.getTestsForSubject(subject.id);
          foundTest = tests.firstWhere(
            (test) => test.id == widget.testId,
          );
          break;
        } catch (e) {
          continue;
        }
      }
      
      // If test not found, create a default test model
      if (foundTest == null) {
        final dailyQuiz = await _mockDataService.getDailyQuiz();
        if (widget.testId == dailyQuiz['id']) {
          _test = TestModel(
            id: widget.testId,
            subjectId: dailyQuiz['subject_id'] ?? 'general',
            title: dailyQuiz['title'] ?? 'Quiz',
            description: dailyQuiz['description'] ?? '',
            duration: dailyQuiz['duration_minutes'] ?? 20,
            totalQuestions: _questions.length,
            status: TestStatus.pending,
            canRetake: false,
          );
        } else {
          _test = TestModel(
            id: widget.testId,
            subjectId: 'general',
            title: 'Test',
            description: '',
            duration: 60,
            totalQuestions: _questions.length,
            status: TestStatus.pending,
            canRetake: false,
          );
        }
      } else {
        _test = foundTest;
      }
      
      _timeRemaining = (_test?.duration ?? 60) * 60;
      _startTimer();
      
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = 'Failed to load questions: $e';
      });
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeRemaining > 0) {
        setState(() {
          _timeRemaining--;
        });
      } else {
        _submitTest();
      }
    });
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  void _selectAnswer(int answerIndex) {
    setState(() {
      _userAnswers[_questions[_currentQuestionIndex].id] = answerIndex;
    });
  }

  void _toggleMarkForReview() {
    setState(() {
      final questionId = _questions[_currentQuestionIndex].id;
      _markedForReview[questionId] = !(_markedForReview[questionId] ?? false);
    });
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
    }
  }

  void _previousQuestion() {
    if (_currentQuestionIndex > 0) {
      setState(() {
        _currentQuestionIndex--;
      });
    }
  }

  void _goToQuestion(int index) {
    setState(() {
      _currentQuestionIndex = index;
    });
  }

  void _submitTest() {
    _timer?.cancel();
    // Calculate score and navigate to result page
    context.go('/result/${widget.testId}');
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          title: const Text('Loading Test...'),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          title: const Text('Error'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Error: $_error', style: AppTextStyles.bodyMedium),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _loadQuestions,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (_questions.isEmpty || _test == null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          title: const Text('Test Not Found'),
        ),
        body: const Center(
          child: Text('No questions available for this test.'),
        ),
      );
    }

    final currentQuestion = _questions[_currentQuestionIndex];
    final selectedAnswer = _userAnswers[currentQuestion.id];

    final progress = ((_currentQuestionIndex + 1) / _questions.length * 100).toInt();
    
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.cardBackground,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: InkWell(
          onTap: () => _showExitDialog(),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.arrow_back_ios_new, color: AppColors.primary, size: 18),
                const SizedBox(width: 4),
                Text(
                  'Exit Quiz',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
        centerTitle: true,
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.access_time, size: 16, color: AppColors.primary),
              const SizedBox(width: 6),
              Text(
                _formatTime(_timeRemaining),
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                  fontFeatures: [const FontFeature.tabularFigures()],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                width: 1,
                height: 16,
                color: AppColors.borderLight,
              ),
              const SizedBox(width: 12),
              Text(
                '${_currentQuestionIndex + 1}/${_questions.length}',
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: FilledButton.icon(
              onPressed: _submitTest,
              icon: const Icon(Icons.check_circle_outline, size: 18),
              label: const Text('Submit'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Quiz Progress - Modern Design
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadowLight,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Quiz Progress',
                      style: AppTextStyles.labelLarge.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '$progress%',
                      style: AppTextStyles.titleMedium.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: progress / 100,
                    backgroundColor: AppColors.surfaceVariant,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                    minHeight: 8,
                  ),
                ),
              ],
            ),
          ),
          // Question Display
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildQuestionCard(currentQuestion, selectedAnswer),
                  const SizedBox(height: 20),
                  _buildNavigationButtons(),
                ],
              ),
            ),
          ),
          // Question Palette
          _buildQuestionPalette(),
        ],
      ),
    );
  }

  void _showExitDialog() {
    // Store the page context to use for navigation
    final pageContext = context;
    
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.warningLight,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.warning_amber_rounded,
                color: AppColors.warning,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text('Exit Quiz?'),
            ),
          ],
        ),
        content: Text(
          'Are you sure you want to exit? Your progress will be saved.',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(
              'Cancel',
              style: AppTextStyles.buttonMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          FilledButton(
            onPressed: () {
              // Close the dialog first
              Navigator.of(dialogContext).pop();
              
              // Then navigate back using the page context
              if (pageContext.mounted) {
                // Stop the timer if running
                _timer?.cancel();
                
                // Navigate back to previous page
                if (pageContext.canPop()) {
                  pageContext.pop();
                } else {
                  // If can't pop, go to home
                  pageContext.go(AppRouter.home);
                }
              }
            },
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.error,
            ),
            child: const Text('Exit'),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionPalette() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Question Palette',
            style: AppTextStyles.titleSmall.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _questions.length,
              itemBuilder: (context, index) {
                final questionId = _questions[index].id;
                final isAnswered = _userAnswers.containsKey(questionId);
                final isCurrent = index == _currentQuestionIndex;
                
                Color bgColor;
                Color borderColor;
                Color textColor;
                
                if (isCurrent) {
                  bgColor = AppColors.primary;
                  borderColor = AppColors.primary;
                  textColor = Colors.white;
                } else if (isAnswered) {
                  bgColor = AppColors.successLight;
                  borderColor = AppColors.success;
                  textColor = AppColors.success;
                } else {
                  bgColor = AppColors.surfaceVariant;
                  borderColor = AppColors.borderLight;
                  textColor = AppColors.textSecondary;
                }
                
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => _goToQuestion(index),
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: bgColor,
                          border: Border.all(
                            color: borderColor,
                            width: isCurrent ? 2.5 : 1.5,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            '${index + 1}',
                            style: AppTextStyles.labelMedium.copyWith(
                              fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w600,
                              color: textColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 20,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: [
              _buildPaletteLegend('Current', AppColors.primary, AppColors.primary),
              _buildPaletteLegend('Answered', AppColors.success, AppColors.successLight),
              _buildPaletteLegend('Not Answered', AppColors.textSecondary, AppColors.surfaceVariant),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaletteLegend(String label, Color borderColor, Color bgColor) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: bgColor,
            border: Border.all(color: borderColor, width: 1.5),
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: AppTextStyles.labelSmall.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildQuestionCard(QuestionModel question, int? selectedAnswer) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowMedium,
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Q.${_currentQuestionIndex + 1}',
                  style: AppTextStyles.labelMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  question.question,
                  style: AppTextStyles.titleLarge.copyWith(
                    fontWeight: FontWeight.w600,
                    height: 1.4,
                  ),
                ),
              ),
              if (question.topic != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    question.topic!,
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 24),
          ...question.options.asMap().entries.map((entry) {
            final index = entry.key;
            final option = entry.value;
            final isSelected = selectedAnswer == index;
            final optionLabel = String.fromCharCode(97 + index); // a, b, c, d
            
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => _selectAnswer(index),
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: isSelected 
                          ? AppColors.primaryContainer 
                          : AppColors.surfaceVariant,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected 
                            ? AppColors.primary 
                            : AppColors.borderLight,
                        width: isSelected ? 2 : 1.5,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isSelected 
                                ? AppColors.primary 
                                : Colors.transparent,
                            border: isSelected 
                                ? null 
                                : Border.all(
                                    color: AppColors.textTertiary,
                                    width: 2,
                                  ),
                          ),
                          child: isSelected
                              ? const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 18,
                                )
                              : Center(
                                  child: Text(
                                    optionLabel.toUpperCase(),
                                    style: AppTextStyles.labelMedium.copyWith(
                                      color: AppColors.textTertiary,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            option,
                            style: AppTextStyles.bodyLarge.copyWith(
                              color: isSelected 
                                  ? AppColors.primary 
                                  : AppColors.textPrimary,
                              fontWeight: isSelected 
                                  ? FontWeight.w600 
                                  : FontWeight.normal,
                              height: 1.5,
                            ),
                          ),
                        ),
                        if (isSelected)
                          Icon(
                            Icons.radio_button_checked,
                            color: AppColors.primary,
                            size: 20,
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: _currentQuestionIndex > 0 ? _previousQuestion : null,
            icon: const Icon(Icons.arrow_back, size: 18),
            label: const Text('Previous'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 2,
          child: FilledButton.icon(
            onPressed: _currentQuestionIndex < _questions.length - 1
                ? _nextQuestion
                : _submitTest,
            icon: Icon(
              _currentQuestionIndex < _questions.length - 1
                  ? Icons.arrow_forward
                  : Icons.check_circle,
              size: 18,
            ),
            label: Text(
              _currentQuestionIndex < _questions.length - 1
                  ? 'Next'
                  : 'Submit Test',
            ),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
          ),
        ),
      ],
    );
  }
}
