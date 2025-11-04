import 'package:flutter/material.dart';

class QuestionMap extends StatelessWidget {
  final int currentIndex;
  final Map<int, int> userAnswers;
  final Set<int> doubtQuestions;
  final int totalQuestions;
  final Function(int) onTap;

  const QuestionMap({
    super.key,
    required this.currentIndex,
    required this.userAnswers,
    required this.doubtQuestions,
    required this.totalQuestions,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: List.generate(totalQuestions, (index) {
        final isAnswered = userAnswers.containsKey(index);
        final isCurrent = currentIndex == index;
        final isDoubt = doubtQuestions.contains(index);

        Color color;
        if (isCurrent) {
          color = theme.colorScheme.primary;
        } else if (isDoubt) {
          color = Colors.orangeAccent;
        } else if (isAnswered) {
          color = Colors.green;
        } else {
          color = Colors.grey.shade400;
        }

        return GestureDetector(
          onTap: () => onTap(index),
          child: CircleAvatar(
            backgroundColor: color,
            radius: 18,
            child: Text(
              '${index + 1}',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        );
      }),
    );
  }
}
