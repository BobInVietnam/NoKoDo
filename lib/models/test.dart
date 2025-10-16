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

enum State {UNANSWERED, CORRECT, INCORRECT}

class Test {
  final int id;
  final DateTime dateCreated;
  final List<Question> questions;
  final int timeLimit;
  double score = 0;
  List<State> questionsState;

  Test(this.id, this.dateCreated, this.timeLimit, this.questions,
      this.questionsState);

  void clearTestState() {
    questionsState = List.filled(questions.length, State.UNANSWERED);
  }

  void answerQuestion(int questionIndex, String answer) {
    if (questions[questionIndex].isAnswerCorrect(answer)) {
      questionsState[questionIndex] = State.CORRECT;
    } else {
      questionsState[questionIndex] = State.INCORRECT;
    }
  }

  void calculateScore() {
    int currentScore = 0;
    for (State s in questionsState) {
      if (s == State.CORRECT) {
        currentScore++;
      }
    }
    score = currentScore / questions.length;
  }
}