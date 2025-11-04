import 'package:flutter/material.dart';

class QuizScreen extends StatelessWidget {
  final String userName;
  final bool isTimed;

  const QuizScreen({
    super.key,
    required this.userName,
    required this.isTimed,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz (Placeholder)'),
      ),
      body: Center(
        child: Text(
          'Halo $userName!\nMode: ${isTimed ? "Timed" : "Normal"}\n(Quiz belum diimplementasi)',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
