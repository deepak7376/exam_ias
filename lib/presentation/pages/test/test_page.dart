import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../data/services/mock_data_service.dart';
import '../../../data/models/question_model.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import 'dart:async';

class TestPage extends StatefulWidget {
  final String testId;

  const TestPage({super.key, required this.testId});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  final MockDataService _mockDataService = MockDataService();
  late List<QuestionModel> _questions;
  late Timer _timer;
  int _currentQuestionIndex = 0;
  int _timeRemaining = 0; // in seconds
  Map<String, int> _userAnswers = {};
  Map<String, bool> _markedForReview = {};

  @override
  void initState() {
    super.initState();
    _loadQuestions();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _loadQuestions() {
    _questions = _mockDataService.getQuestionsForTest(widget.testId);
    _timeRemaining = 60 * 60; // 60 minutes in seconds
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
    _timer.cancel();
    // Calculate score and navigate to result page
    context.go('/result/${widget.testId}');
  }

  @override
  Widget build(BuildContext context) {
    if (_questions.isEmpty) {
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
    final isMarkedForReview = _markedForReview[currentQuestion.id] ?? false;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        title: Text('Polity - Test 3'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            margin: const EdgeInsets.only(right: 16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '⏱️ ${_formatTime(_timeRemaining)}',
              style: AppTextStyles.bodyMedium.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildProgressBar(),
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
          _buildBottomActions(isMarkedForReview),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    final progress = (_currentQuestionIndex + 1) / _questions.length;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Q${_currentQuestionIndex + 1}/${_questions.length}',
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'Progress: ${((_currentQuestionIndex + 1) / _questions.length * 100).toInt()}%',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: AppColors.lightGrey,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
            minHeight: 6,
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionCard(QuestionModel question, int? selectedAnswer) {
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
          Text(
            question.question,
            style: AppTextStyles.bodyLarge.copyWith(
              fontWeight: FontWeight.w600,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 20),
          ...question.options.asMap().entries.map((entry) {
            final index = entry.key;
            final option = entry.value;
            final isSelected = selectedAnswer == index;
            
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              child: InkWell(
                onTap: () => _selectAnswer(index),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary.withOpacity(0.1) : AppColors.background,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.lightGrey,
                      width: 2,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected ? AppColors.primary : Colors.transparent,
                          border: Border.all(
                            color: isSelected ? AppColors.primary : AppColors.grey,
                            width: 2,
                          ),
                        ),
                        child: isSelected
                            ? const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 16,
                              )
                            : null,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          option,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: isSelected ? AppColors.primary : AppColors.textPrimary,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                          ),
                        ),
                      ),
                    ],
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
          child: ElevatedButton(
            onPressed: _currentQuestionIndex > 0 ? _previousQuestion : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.lightGrey,
              foregroundColor: AppColors.textPrimary,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('Previous'),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: _currentQuestionIndex < _questions.length - 1
                ? _nextQuestion
                : _submitTest,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              _currentQuestionIndex < _questions.length - 1 ? 'Next →' : 'Submit Test 🧾',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomActions(bool isMarkedForReview) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: _toggleMarkForReview,
              icon: Icon(
                isMarkedForReview ? Icons.star : Icons.star_border,
                color: isMarkedForReview ? AppColors.warning : AppColors.grey,
              ),
              label: Text(
                isMarkedForReview ? 'Marked for Review' : 'Mark for Review ⭐',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: isMarkedForReview ? AppColors.warning : AppColors.textSecondary,
                ),
              ),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                side: BorderSide(
                  color: isMarkedForReview ? AppColors.warning : AppColors.lightGrey,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: _submitTest,
              icon: const Icon(Icons.check_circle),
              label: const Text('Submit'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.success,
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
    );
  }
}
