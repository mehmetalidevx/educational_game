import 'package:flutter/material.dart';
import '../models/game_state.dart';

class QuestionCard extends StatefulWidget {
  final Question question;
  final Function(int) onAnswerSelected;
  
  const QuestionCard({
    super.key,
    required this.question,
    required this.onAnswerSelected,
  });

  @override
  State<QuestionCard> createState() => _QuestionCardState();
}

class _QuestionCardState extends State<QuestionCard> {
  int? _selectedAnswerIndex;
  bool _showExplanation = false;
  
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.question.question,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            Expanded(
              child: ListView.builder(
                itemCount: widget.question.options.length,
                itemBuilder: (context, index) {
                  final isSelected = _selectedAnswerIndex == index;
                  final isCorrect = index == widget.question.correctAnswerIndex;
                  
                  Color backgroundColor = Colors.white;
                  if (_showExplanation) {
                    backgroundColor = isCorrect ? Colors.green.shade100 : Colors.white;
                  } else if (isSelected) {
                    backgroundColor = Theme.of(context).colorScheme.primaryContainer;
                  }
                  
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      child: ElevatedButton(
                        onPressed: _showExplanation ? null : () {
                          setState(() {
                            _selectedAnswerIndex = index;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: backgroundColor,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                            side: BorderSide(
                              color: isSelected ? Theme.of(context).colorScheme.primary : Colors.grey.shade300,
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                        ),
                        child: Text(
                          widget.question.options[index],
                          style: TextStyle(
                            fontSize: 18,
                            color: isSelected ? Theme.of(context).colorScheme.primary : Colors.black87,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            if (_showExplanation)
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Explanation:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      widget.question.explanation,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _selectedAnswerIndex == null
                  ? null
                  : _showExplanation
                      ? () {
                          widget.onAnswerSelected(_selectedAnswerIndex!);
                          setState(() {
                            _selectedAnswerIndex = null;
                            _showExplanation = false;
                          });
                        }
                      : () {
                          setState(() {
                            _showExplanation = true;
                          });
                        },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: Text(
                _showExplanation ? 'Next Question' : 'Check Answer',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}