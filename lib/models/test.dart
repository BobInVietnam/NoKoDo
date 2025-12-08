abstract class Question {
  final int id;
  final String content;
  final String correctAnswer;

  Question(this.id, this.content, this.correctAnswer);
  factory Question.fromMap(Map<String, Object?> map) {
    if (map['is_multiple_choice'] as int == 0) {
      return FillBlankQuestion(
          map['id'] as int,
          map['question'] as String,
          map['answer'] as String);
    } else {
      return MultipleChoiceQuestion(
          map['id'] as int,
          map['question'] as String,
          (map['choices'] as String).replaceAll('[', '') // Remove start brace
              .replaceAll(']', '') // Remove end brace
              .split(',')          // Split by comma
              .map((e) => e.trim().replaceAll('"', "")) // Remove whitespace and quotes
              .toList(), //String manip inline
          map['answer'] as String);
    }
  }

  bool isAnswerCorrect(String answer);

  static double calculateScore(
      List<Question> questionList,
      Map<int, dynamic> answerList)
  {
    int length = questionList.length;
    int correctAnswerCount = 0;
    for (final question in questionList) {
      if (answerList[question.id] != null
          && answerList[question.id] == question.correctAnswer) {
        correctAnswerCount++;
      }
    };
    return 10 * correctAnswerCount / length;
  }
}

class MultipleChoiceQuestion extends Question{

  final List<String> options;

  MultipleChoiceQuestion(super.id, super.content, this.options, super.correctAnswer);

  @override
  bool isAnswerCorrect(String answer) {
    return options.contains(answer);
  }
}

class FillBlankQuestion extends Question{

  FillBlankQuestion(super.id, super.content, super.correctAnswer);

  @override
  bool isAnswerCorrect(String answer) {
    return answer == this.correctAnswer.toLowerCase();
  }
}

enum QuestState {UNANSWERED, CORRECT, INCORRECT}

class TestInfo {
  final int id;
  final String name;
  final int dateCreated;
  final int timeLimit;
  final int attempts;
  final int allowedAttempts;
  final int difficulty;
  final double? result;

  TestInfo({required this.id, required this.name, required this.dateCreated, required this.timeLimit, required this.attempts,
    required this.allowedAttempts, required this.difficulty, required this.result});

  factory TestInfo.fromMap(Map<String, Object?> map) {
    return TestInfo(id: map['id'] as int,
        name: map['name'] as String,
        dateCreated: map['date_created'] as int,
        timeLimit: map['time_limit'] as int,
        attempts: map['attempts'] as int,
        allowedAttempts: map['allowed_attempts'] as int,
        difficulty: map['difficulty'] as int,
        result: map['result'] as double?
    );
  }
}

class TestSession {
  int id;
  final int testId;
  final String studentId;
  final int startTime;
  final int endTime;
  final double score;

  TestSession({required this.id, required this.testId,
    required this.studentId, required this.startTime,
    required this.endTime, required this.score});

  factory TestSession.fromMap(Map<String, Object?> map) {
    return TestSession(id: map['id'] as int,
        testId: map['testid'] as int,
        studentId: map['studentid'] as String,
        startTime: map['starttime'] as int,
        endTime: map['endtime'] as int,
        score: map['score'] as double);
  }
}

class Test {
  final int id;
  final List<Question> questions;
  final int timeLimit;
  final int allowedAttempts;
  double score = 0;
  late List<QuestState> questionsState;

  Test({required this.id, required this.questions,
    required this.timeLimit, required this.allowedAttempts}) {
    questionsState = List.filled(questions.length, QuestState.UNANSWERED);
  }

  factory Test.fromMap(Map<String, Object?> map) {
    return Test(
      id: map['id'] as int,
      questions: map['questions'] as List<Question>,
      timeLimit: map['time_limit'] as int,
      allowedAttempts: map['allowed_attempts'] as int,
    );
  }

  void clearTestState() {
    questionsState = List.filled(questions.length, QuestState.UNANSWERED);
  }

}