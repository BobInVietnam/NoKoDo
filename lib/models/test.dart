abstract class Question {
  final int id;
  final String content;
  final String correctAnswer;

  Question(this.id, this.content, this.correctAnswer);
  factory Question.fromMap(Map<String, Object?> map) {
    final isMultipleChoiceVal = map['isMultipleChoice'] ?? 0;
    if (isMultipleChoiceVal as int == 0) {
      return FillBlankQuestion(
          map['id'] as int,
          map['question'] as String,
          map['answer'] as String);
    } else {
      return MultipleChoiceQuestion(
          map['id'] as int,
          map['question'] as String,
          List<String>.from(map['choices'] as List),
          map['answer'] as String);
    }
  }

  bool isAnswerCorrect(String answer);

  static double calculateScore(
      List<Question> questionList,
      Map<int, String?> answerList)
  {
    int length = questionList.length;
    int correctAnswerCount = 0;
    for (final question in questionList) {
      if (answerList[question.id] != null
          && answerList[question.id]!.toLowerCase() == question.correctAnswer.toLowerCase()) {
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
    return TestInfo(
        id: map['id'] as int,
        name: map['name'] as String,
        dateCreated: map['dateCreated'] as int,
        timeLimit: map['timeLimit'] as int,
        attempts: map['attempts'] as int,
        allowedAttempts: map['allowedAttempts'] as int,
        difficulty: map['difficulty'] as int,
        result: (map['result'] as num?)?.toDouble()
    );
  }
}

class TestSession {
  final int testId;
  final String studentId;
  final int startTime;
  final int endTime;
  final double score;

  TestSession({required this.testId,
    required this.studentId, required this.startTime,
    required this.endTime, required this.score});

  factory TestSession.fromMap(Map<String, Object?> map) {
    return TestSession(
        testId: map['testid'] as int,
        studentId: map['studentid'] as String,
        startTime: map['dateCreated'] as int,
        endTime: map['dateFinished'] as int,
        score: ((map['score'] ?? map['result']) as num).toDouble()
    );
  }
}

class Test {
  final int id;
  final String name;
  final List<Question> questions;
  final int timeLimit;
  final int allowedAttempts;
  final List<TestSession> studentStatuses;
  double score = 0;
  late List<QuestState> questionsState;

  Test({
    required this.id,
    required this.name,
    required this.questions,
    required this.timeLimit,
    required this.allowedAttempts,
    required this.studentStatuses,
  }) {
    questionsState = List.filled(questions.length, QuestState.UNANSWERED);
  }

  factory Test.fromMap(Map<String, Object?> map) {
    final statusesList = map['studentStatuses'] as List?;
    final List<TestSession> parsedStatuses = statusesList != null
        ? statusesList
            .map((item) => TestSession.fromMap(Map<String, Object?>.from(item as Map)))
            .toList()
        : [];

    return Test(
      id: map['id'] as int,
      name: (map['name'] ?? '') as String,
      questions: map['questions'] as List<Question>,
      timeLimit: (map['timeLimit'] ?? map['time_limit'] ?? 0) as int,
      allowedAttempts: (map['allowedAttempts'] ?? map['allowed_attempts'] ?? 0) as int,
      studentStatuses: parsedStatuses,
    );
  }

  void clearTestState() {
    questionsState = List.filled(questions.length, QuestState.UNANSWERED);
  }

}