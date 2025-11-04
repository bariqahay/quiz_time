import 'dart:async';
import 'package:flutter/material.dart';
import '../models/question.dart';
import '../widgets/answer_option.dart';
import '../widgets/question_map.dart';
import '../widgets/progress_indicator.dart';
import 'result_screen.dart';

class QuizScreen extends StatefulWidget {
  final String userName;
  final bool isTimed;

  const QuizScreen({
    super.key,
    required this.userName,
    required this.isTimed,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final List<Question> _questions = getQuestions();
  int _currentQuestionIndex = 0;
  final Map<int, int> _userAnswers = {};
  final Set<int> _doubtQuestions = {};
  int? _selectedAnswerIndex;

  // === TIMER VARIABEL ===
  Timer? _quizTimer;
  int _remainingTime = 60; // harus int, biar bisa decrement

  @override
  void initState() {
    super.initState();

    // Shuffle pertanyaan
    _questions.shuffle();

    // Shuffle jawaban tiap soal
    for (var q in _questions) {
      q.shuffleOptions();
    }

    if (widget.isTimed) _startTimer();
  }

  void _startTimer() {
    _quizTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        setState(() => _remainingTime--);
      } else {
        timer.cancel();
        _finishQuiz();
      }
    });
  }

  @override
  void dispose() {
    _quizTimer?.cancel();
    super.dispose();
  }

  void _selectAnswer(int index) {
    setState(() {
      if (_selectedAnswerIndex == index) {
        _selectedAnswerIndex = null;
        _userAnswers.remove(_currentQuestionIndex);
      } else {
        _selectedAnswerIndex = index;
        _userAnswers[_currentQuestionIndex] = index;
      }
    });
  }

  void _toggleDoubt() {
    setState(() {
      if (_doubtQuestions.contains(_currentQuestionIndex)) {
        _doubtQuestions.remove(_currentQuestionIndex);
      } else {
        _doubtQuestions.add(_currentQuestionIndex);
      }
    });
  }

  void _nextQuestion() {
    if (_selectedAnswerIndex != null) {
      _userAnswers[_currentQuestionIndex] = _selectedAnswerIndex!;
    }

    if (_currentQuestionIndex < _questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _selectedAnswerIndex = _userAnswers[_currentQuestionIndex];
      });
    } else {
      _finishQuiz();
    }
  }

  void _previousQuestion() {
    if (_currentQuestionIndex > 0) {
      setState(() {
        _currentQuestionIndex--;
        _selectedAnswerIndex = _userAnswers[_currentQuestionIndex];
      });
    }
  }

  void _finishQuiz() {
    _quizTimer?.cancel();

    int score = 0;
    for (int i = 0; i < _questions.length; i++) {
      if (_userAnswers[i] == _questions[i].correctAnswerIndex) score++;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ResultScreen(
          userName: widget.userName,
          score: score,
          totalQuestions: _questions.length,
          userAnswers: _userAnswers,
          questions: _questions,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width > 600;
    final currentQuestion = _questions[_currentQuestionIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz - ${widget.userName}'),
        elevation: 0,
        actions: [
          if (widget.isTimed)
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Center(
                child: Text(
                  '⏱ $_remainingTime dtk',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),

              // Peta Soal
              QuestionMap(
                currentIndex: _currentQuestionIndex,
                userAnswers: _userAnswers,
                doubtQuestions: _doubtQuestions,
                totalQuestions: _questions.length,
                onTap: (index) {
                  setState(() {
                    _currentQuestionIndex = index;
                    _selectedAnswerIndex = _userAnswers[index];
                  });
                },
              ),

              const SizedBox(height: 20),

              // Pertanyaan
              Card(
                elevation: isTablet ? 2 : 1,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pertanyaan ${_currentQuestionIndex + 1}',
                        style: TextStyle(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        currentQuestion.question,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              Text(
                'Pilih Jawaban:',
                style: TextStyle(
                  fontSize: isTablet ? 18 : 16,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),

              ...List.generate(
                currentQuestion.options.length,
                (index) => AnswerOption(
                  optionLetter: String.fromCharCode(65 + index),
                  optionText: currentQuestion.options[index],
                  isSelected: _selectedAnswerIndex == index,
                  onTap: () => _selectAnswer(index),
                ),
              ),

              const SizedBox(height: 24),

              // === Tombol Navigasi ===
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: (_currentQuestionIndex > 0)
                        ? OutlinedButton.icon(
                            onPressed: _previousQuestion,
                            icon: const Icon(Icons.arrow_back),
                            label: const Text('Sebelumnya'),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          )
                        : const SizedBox(),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _toggleDoubt,
                      icon: Icon(
                        _doubtQuestions.contains(_currentQuestionIndex)
                            ? Icons.help
                            : Icons.help_outline,
                      ),
                      label: const Text('Ragu'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        foregroundColor: Colors.orangeAccent,
                        side: const BorderSide(color: Colors.orangeAccent),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _nextQuestion,
                      icon: Icon(
                        _currentQuestionIndex == _questions.length - 1
                            ? Icons.check
                            : Icons.arrow_forward,
                      ),
                      label: Text(
                        _currentQuestionIndex == _questions.length - 1
                            ? 'Selesai'
                            : 'Selanjutnya',
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
