abstract class Question {
  final int id;

  Question(this.id);

  bool isAnswerCorrect(String answer);
}

class MultipleChoiceQuestion extends Question{

  final String content;
  final List<String> options;
  final String correctAnswerIndex;

  MultipleChoiceQuestion(super.id, this.content, this.options, this.correctAnswerIndex);

  @override
  bool isAnswerCorrect(String answer) {
    return options.contains(answer);
  }
}

class FillBlankQuestion extends Question{
  final String content;
  final String correctAnswer;

  FillBlankQuestion(super.id, this.content, this.correctAnswer);

  @override
  bool isAnswerCorrect(String answer) {
    return answer == this.correctAnswer.toLowerCase();
  }
}

enum QuestState {UNANSWERED, CORRECT, INCORRECT}

class TestInfo {
  final int id;
  final String name;
  final DateTime dateCreated;
  final int timeLimit;
  final int attempts;
  final int allowedAttempts;
  final int difficulty;
  final double result;

  TestInfo({required this.id, required this.name, required this.dateCreated, required this.timeLimit, required this.attempts,
    required this.allowedAttempts, required this.difficulty, required this.result});

  factory TestInfo.fromMap(Map<String, Object?> map) {
    return TestInfo(id: map['id'] as int,
        name: map['name'] as String,
        dateCreated: map['date_created'] as DateTime,
        timeLimit: map['time_limit'] as int,
        attempts: map['attempts'] as int,
        allowedAttempts: map['allowed_attempts'] as int,
        difficulty: map['difficulty'] as int,
        result: map['result'] as double);
  }
}

class Test {
  final int id;
  final List<Question> questions;
  final int timeLimit;
  final int allowedAttempts;
  double score = 0;
  late List<QuestState> questionsState;

  Test(this.id, this.questions, this.timeLimit, this.allowedAttempts) {
    questionsState = List.filled(questions.length, QuestState.UNANSWERED);
  }

  void clearTestState() {
    questionsState = List.filled(questions.length, QuestState.UNANSWERED);
  }

  void answerQuestion(int questionIndex, String answer) {
    if (questions[questionIndex].isAnswerCorrect(answer)) {
      questionsState[questionIndex] = QuestState.CORRECT;
    } else {
      questionsState[questionIndex] = QuestState.INCORRECT;
    }
  }

  void calculateScore() {
    int currentScore = 0;
    for (QuestState s in questionsState) {
      if (s == QuestState.CORRECT) {
        currentScore++;
      }
    }
    score = currentScore / questions.length;
  }


}