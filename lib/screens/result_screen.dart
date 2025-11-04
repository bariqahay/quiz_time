import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/question.dart';
import '../screens/quiz_screen.dart'; 

class ResultScreen extends StatefulWidget {
  final String userName;
  final int score;
  final int totalQuestions;
  final Map<int, int> userAnswers;
  final List<Question> questions;

  const ResultScreen({
    super.key,
    required this.userName,
    required this.score,
    required this.totalQuestions,
    required this.userAnswers,
    required this.questions,
  });

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 3));

    // mainin confetti kalau score bagus
    final percentage = (widget.score / widget.totalQuestions) * 100;
    if (percentage >= 70) {
      _confettiController.play();
    }
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  String _getPerformanceMessage() {
    final percentage = (widget.score / widget.totalQuestions) * 100;
    if (percentage >= 90) {
      return 'Luar Biasa! 🎉';
    } else if (percentage >= 70) {
      return 'Bagus Sekali! 👏';
    } else if (percentage >= 50) {
      return 'Cukup Baik! 👍';
    } else {
      return 'Tetap Semangat! 💪';
    }
  }

  String _getDynamicMessage() {
    final percentage = (widget.score / widget.totalQuestions) * 100;
    if (percentage >= 90) {
      return 'Lu udah dewa banget di topik ini bro 🔥';
    } else if (percentage >= 70) {
      return 'Mantap bro, udah jago nih!';
    } else if (percentage >= 50) {
      return 'Masih bisa lebih baik, semangat terus 💪';
    } else {
      return 'Gapapa bro, belajar pelan² juga oke 😉';
    }
  }

  Color _getScoreColor() {
    final percentage = (widget.score / widget.totalQuestions) * 100;
    if (percentage >= 70) {
      return Colors.green;
    } else if (percentage >= 50) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;
    final isTablet = screenSize.width > 600;
    final percentage = ((widget.score / widget.totalQuestions) * 100).toInt();
    final correct = widget.score;
    final wrong = widget.totalQuestions - widget.score;

    return Scaffold(
      body: Stack(
        children: [
          // confetti animation 🎉
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [Colors.green, Colors.blue, Colors.orange, Colors.purple],
              emissionFrequency: 0.05,
              numberOfParticles: 30,
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(
                horizontal: isTablet ? screenSize.width * 0.1 : screenSize.width * 0.06,
                vertical: screenSize.height * 0.03,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: screenSize.height * 0.02),

                  // icon + title
                  Container(
                    width: isTablet ? 140 : 120,
                    height: isTablet ? 140 : 120,
                    decoration: BoxDecoration(
                      color: _getScoreColor().withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      percentage >= 70 ? Icons.emoji_events : Icons.flag,
                      size: isTablet ? 70 : 60,
                      color: _getScoreColor(),
                    ),
                  ),

                  const SizedBox(height: 20),
                  Text(
                    _getPerformanceMessage(),
                    style: TextStyle(
                      fontSize: isTablet ? 32 : 26,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    widget.userName,
                    style: TextStyle(
                      fontSize: isTablet ? 22 : 18,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 30),

                  // pie chart section 🥧
                  SizedBox(
                    height: isTablet ? 200 : 160,
                    child: PieChart(
                      PieChartData(
                        sectionsSpace: 2,
                        centerSpaceRadius: 40,
                        sections: [
                          PieChartSectionData(
                            color: Colors.green,
                            value: correct.toDouble(),
                            title: '$correct',
                            radius: 50,
                            titleStyle: TextStyle(
                              fontSize: isTablet ? 20 : 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          PieChartSectionData(
                            color: Colors.red,
                            value: wrong.toDouble(),
                            title: '$wrong',
                            radius: 50,
                            titleStyle: TextStyle(
                              fontSize: isTablet ? 20 : 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // skor card
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: EdgeInsets.all(isTablet ? 32 : 24),
                      child: Column(
                        children: [
                          Text(
                            'Skor Anda',
                            style: TextStyle(
                              fontSize: isTablet ? 20 : 18,
                              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Text(
                                '${widget.score}',
                                style: TextStyle(
                                  fontSize: isTablet ? 72 : 64,
                                  fontWeight: FontWeight.bold,
                                  color: _getScoreColor(),
                                ),
                              ),
                              Text(
                                '/${widget.totalQuestions}',
                                style: TextStyle(
                                  fontSize: isTablet ? 36 : 32,
                                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            '$percentage% Benar',
                            style: TextStyle(
                              fontSize: isTablet ? 18 : 16,
                              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            _getDynamicMessage(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                              fontSize: isTablet ? 16 : 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // review jawaban
                  SizedBox(
                    width: double.infinity,
                    height: isTablet ? 56 : 50,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                          ),
                          builder: (context) => _ReviewAnswersSheet(
                            questions: widget.questions,
                            userAnswers: widget.userAnswers,
                            isTablet: isTablet,
                          ),
                        );
                      },
                      icon: const Icon(Icons.list_alt),
                      label: const Text('Review Jawaban'),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // coba lagi
                  SizedBox(
                    width: double.infinity,
                    height: isTablet ? 56 : 50,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => QuizScreen(
                              userName: widget.userName,
                              isTimed: false,
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Coba Lagi'),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // back to home
                  SizedBox(
                    width: double.infinity,
                    height: isTablet ? 56 : 50,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.popUntil(context, (route) => route.isFirst);
                      },
                      icon: const Icon(Icons.home),
                      label: const Text('Kembali ke Beranda'),
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewAnswersSheet extends StatelessWidget {
  final List<Question> questions;
  final Map<int, int> userAnswers;
  final bool isTablet;

  const _ReviewAnswersSheet({
    required this.questions,
    required this.userAnswers,
    required this.isTablet,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      builder: (context, scrollController) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Text(
              'Review Jawaban',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                controller: scrollController,
                itemCount: questions.length,
                itemBuilder: (context, index) {
                  final q = questions[index];
                  final userAnswer = userAnswers[index];
                  final isCorrect = userAnswer == q.correctAnswerIndex;

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    color: isCorrect
                        ? Colors.green.withValues(alpha: 0.1)
                        : Colors.red.withValues(alpha: 0.1),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                isCorrect ? Icons.check_circle : Icons.cancel,
                                color: isCorrect ? Colors.green : Colors.red,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Pertanyaan ${index + 1}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: isCorrect ? Colors.green : Colors.red,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(q.question),
                          const SizedBox(height: 8),
                          Text(
                            'Jawaban Anda: ${userAnswer != null ? q.options[userAnswer] : 'Tidak Dijawab'}',
                            style: TextStyle(
                              color: isCorrect ? Colors.green : Colors.red,
                            ),
                          ),
                          if (!isCorrect)
                            Text(
                              'Jawaban Benar: ${q.options[q.correctAnswerIndex]}',
                              style: const TextStyle(color: Colors.green),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
