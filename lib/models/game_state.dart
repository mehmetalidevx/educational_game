import 'package:flutter/foundation.dart';
import 'dart:math';

class Question {
  final String question;
  final List<String> options;
  final int correctAnswerIndex;
  final String explanation;

  Question({
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
    required this.explanation,
  });
}

class GameState with ChangeNotifier {
  int _score = 0;
  int _currentLevel = 1;
  int _questionsAnswered = 0;
  int _correctAnswers = 0;
  List<Question> _questions = [];
  int _currentQuestionIndex = 0;
  bool _gameOver = false;
  final int _questionsPerLevel = 5;
  
  // Getters
  int get score => _score;
  int get currentLevel => _currentLevel;
  int get questionsAnswered => _questionsAnswered;
  int get correctAnswers => _correctAnswers;
  List<Question> get questions => _questions;
  Question get currentQuestion => _questions[_currentQuestionIndex];
  int get currentQuestionIndex => _currentQuestionIndex;
  bool get gameOver => _gameOver;
  int get questionsPerLevel => _questionsPerLevel;
  
  GameState() {
    _generateQuestions();
  }
  
  void _generateQuestions() {
    _questions = [];
    final random = Random();
    
    // Generate addition questions for level 1
    if (_currentLevel == 1) {
      for (int i = 0; i < _questionsPerLevel; i++) {
        int num1 = random.nextInt(10) + 1;
        int num2 = random.nextInt(10) + 1;
        int correctAnswer = num1 + num2;
        
        List<int> wrongAnswers = [];
        while (wrongAnswers.length < 3) {
          int wrongAnswer = correctAnswer + random.nextInt(5) - 2;
          if (wrongAnswer != correctAnswer && !wrongAnswers.contains(wrongAnswer) && wrongAnswer > 0) {
            wrongAnswers.add(wrongAnswer);
          }
        }
        
        List<String> options = [correctAnswer.toString(), ...wrongAnswers.map((e) => e.toString())];
        options.shuffle();
        
        _questions.add(Question(
          question: 'What is $num1 + $num2?',
          options: options,
          correctAnswerIndex: options.indexOf(correctAnswer.toString()),
          explanation: '$num1 + $num2 = $correctAnswer',
        ));
      }
    }
    
    // Generate subtraction questions for level 2
    else if (_currentLevel == 2) {
      for (int i = 0; i < _questionsPerLevel; i++) {
        int num1 = random.nextInt(15) + 5;
        int num2 = random.nextInt(num1) + 1;
        int correctAnswer = num1 - num2;
        
        List<int> wrongAnswers = [];
        while (wrongAnswers.length < 3) {
          int wrongAnswer = correctAnswer + random.nextInt(5) - 2;
          if (wrongAnswer != correctAnswer && !wrongAnswers.contains(wrongAnswer) && wrongAnswer >= 0) {
            wrongAnswers.add(wrongAnswer);
          }
        }
        
        List<String> options = [correctAnswer.toString(), ...wrongAnswers.map((e) => e.toString())];
        options.shuffle();
        
        _questions.add(Question(
          question: 'What is $num1 - $num2?',
          options: options,
          correctAnswerIndex: options.indexOf(correctAnswer.toString()),
          explanation: '$num1 - $num2 = $correctAnswer',
        ));
      }
    }
    
    // Generate multiplication questions for level 3
    else if (_currentLevel == 3) {
      for (int i = 0; i < _questionsPerLevel; i++) {
        int num1 = random.nextInt(10) + 1;
        int num2 = random.nextInt(10) + 1;
        int correctAnswer = num1 * num2;
        
        List<int> wrongAnswers = [];
        while (wrongAnswers.length < 3) {
          int wrongAnswer = correctAnswer + random.nextInt(10) - 5;
          if (wrongAnswer != correctAnswer && !wrongAnswers.contains(wrongAnswer) && wrongAnswer > 0) {
            wrongAnswers.add(wrongAnswer);
          }
        }
        
        List<String> options = [correctAnswer.toString(), ...wrongAnswers.map((e) => e.toString())];
        options.shuffle();
        
        _questions.add(Question(
          question: 'What is $num1 × $num2?',
          options: options,
          correctAnswerIndex: options.indexOf(correctAnswer.toString()),
          explanation: '$num1 × $num2 = $correctAnswer',
        ));
      }
    }
    
    notifyListeners();
  }
  
  void answerQuestion(int selectedAnswerIndex) {
    bool isCorrect = selectedAnswerIndex == currentQuestion.correctAnswerIndex;
    
    if (isCorrect) {
      _score += 10 * _currentLevel;
      _correctAnswers++;
    }
    
    _questionsAnswered++;
    
    if (_currentQuestionIndex < _questions.length - 1) {
      _currentQuestionIndex++;
    } else {
      if (_currentLevel < 3 && _correctAnswers >= (_questionsPerLevel * 0.6).round()) {
        _currentLevel++;
        _currentQuestionIndex = 0;
        _questionsAnswered = 0;
        _correctAnswers = 0;
        _generateQuestions();
      } else {
        _gameOver = true;
      }
    }
    
    notifyListeners();
  }
  
  void resetGame() {
    _score = 0;
    _currentLevel = 1;
    _questionsAnswered = 0;
    _correctAnswers = 0;
    _currentQuestionIndex = 0;
    _gameOver = false;
    _generateQuestions();
    notifyListeners();
  }
}