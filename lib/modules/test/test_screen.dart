import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Import the custom buttons from your project
import 'package:nodyslexia/customwigdets/return_button.dart';
import 'package:nodyslexia/customwigdets/settings_button.dart';

// --- 1. DATA MODELS & MOCK DATA ---

enum QuestionType { multipleChoice, textInput }

class Question {
  final String id;
  final QuestionType type;
  final String text;
  final List<String>? options;
  final dynamic correctAnswer;

  Question({
    required this.id,
    required this.type,
    required this.text,
    this.options,
    this.correctAnswer,
  });
}

class Test {
  final String id;
  final String name;
  final List<Question> questions;

  Test({required this.id, required this.name, required this.questions});
}

// A global mock test object for this example.
// In your real app, you would pass this from the TestSelectionScreen.
final Test mockTest = Test(
  id: "test_101",
  name: "Bài Kiểm Tra Ngữ Nghĩa",
  questions: [
    Question(
      id: "q1",
      type: QuestionType.multipleChoice,
      text: "Từ nào sau đây đồng nghĩa với 'hạnh phúc'?",
      options: ["Vui vẻ", "Buồn bã", "Giận dữ", "Lo lắng"],
      correctAnswer: "Vui vẻ",
    ),
    Question(
      id: "q2",
      type: QuestionType.textInput,
      text: "Điền vào chỗ trống: '... che mắt thánh'",
      correctAnswer: "Một đồng",
    ),
    Question(
      id: "q3",
      type: QuestionType.multipleChoice,
      text: "Câu nào sau đây là câu đơn?",
      options: [
        "Trời mưa và tôi ngủ.",
        "Mẹ đi làm.",
        "Nếu bạn cố gắng, bạn sẽ thành công.",
        "Tất cả đều sai."
      ],
      correctAnswer: "Mẹ đi làm.",
    ),
    Question(
      id: "q4",
      type: QuestionType.textInput,
      text: "Viết 1 từ trái nghĩa với 'yêu thương'",
      correctAnswer: "Căm ghét",
    ),
    // Add more questions to see the tray scroll
    for (int i = 5; i <= 25; i++)
      Question(
        id: "q$i",
        type: i % 3 == 0 ? QuestionType.textInput : QuestionType.multipleChoice,
        text: "Đây là câu hỏi $i?",
        options: ["Option A", "Option B", "Option C", "Option D"],
        correctAnswer: "Option A",
      ),
  ],
);

// --- 2. THE TEST SCREEN WIDGET ---

class TestScreen extends StatefulWidget {
  final Test test = mockTest; // The screen is built based on this test object
  TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  late final PageController _pageController;
  late final List<Question> _questions;

  // State variables
  int _currentPage = 0;
  bool _isTrayExpanded = false;
  final Map<String, dynamic> _answers = {}; // Stores {questionId: answer}
  final Map<int, TextEditingController> _textControllers = {}; // To manage text fields

  @override
  void initState() {
    super.initState();
    _questions = widget.test.questions;
    _pageController = PageController();

    // Initialize text controllers for text input questions
    for (int i = 0; i < _questions.length; i++) {
      if (_questions[i].type == QuestionType.textInput) {
        _textControllers[i] = TextEditingController();
      }
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    for (var controller in _textControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  /// Registers an answer and automatically moves to the next page
  void _registerAnswer(String questionId, dynamic answer) {
    setState(() {
      _answers[questionId] = answer;
    });

    // Automatically jump to the next question
    if (_currentPage < _questions.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    } else {
      // Last question, maybe show a "Submit" prompt
      debugPrint("Test finished. Answers: $_answers");
    }
  }

  /// Jumps the PageView to a specific question
  void _jumpToPage(int pageIndex) {
    _pageController.animateToPage(
      pageIndex,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  /// Toggles the bottom tray between collapsed and expanded
  void _toggleExpandTray() {
    setState(() {
      _isTrayExpanded = !_isTrayExpanded;
    });
  }

  /// Submits the test
  void _submitTest() {

    // 1. Show a confirmation dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nộp bài?'),
        content: const Text('Bạn có chắc chắn muốn nộp bài không?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Huỷ'),
          ),
          TextButton(
            onPressed: () {
              // Pop dialog
              Navigator.pop(context);
              // Pop test screen
              Navigator.pop(context);
              debugPrint("Bài đã nộp: $_answers");
              // TODO: Navigate to a Results Screen
            },
            child: const Text('Nộp bài'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Inherit styles from the theme
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Colors.grey[200], // Background color from images
      body: SafeArea(
        child: Column(
          children: [
            // --- 3. QUESTION AREA ---
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _questions.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  return _buildQuestionPage(_questions[index], index);
                },
              ),
            ),

            // --- 4. BOTTOM TRAY ---
            // This is the animated tray
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
              height: _isTrayExpanded ? 450 : 150, // Changes height
              decoration: BoxDecoration(
                color: Colors.grey[300],
                boxShadow: [
                  BoxShadow(
                    blurRadius: 10,
                    color: Colors.black.withOpacity(0.1),
                    offset: const Offset(0, -5),
                  )
                ],
              ),
              child: _isTrayExpanded
                  ? _buildExpandedTrayContent(textTheme, colorScheme)
                  : _buildCollapsedTrayContent(textTheme, colorScheme),
            ),
          ],
        ),
      ),
    );
  }

  // --- 5. QUESTION WIDGET BUILDERS ---

  /// Builds the widget for a single question page
  Widget _buildQuestionPage(Question question, int index) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Question Box
          Container(
            width: double.infinity,
            height: 200,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                question.text,
                style: textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Answer Area (Dynamic)
          if (question.type == QuestionType.multipleChoice)
            _buildMultipleChoiceOptions(question),
          if (question.type == QuestionType.textInput)
            _buildTextInput(question, index),
        ],
      ),
    );
  }

  /// Builds the 4-grid for Multiple Choice
  Widget _buildMultipleChoiceOptions(Question question) {
    final textTheme = Theme.of(context).textTheme;
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 4 / 1,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: question.options?.length ?? 0,
      shrinkWrap: true, // Important for GridView in a Column
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final option = question.options![index];
        return InkWell(
          onTap: () => _registerAnswer(question.id, option),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blue, width: 2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                option,
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium,
              ),
            ),
          ),
        );
      },
    );
  }

  /// Builds the Text Field and "ENTER" button
  Widget _buildTextInput(Question question, int index) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        Text(
          "Nhập câu trả lời của bạn",
          style: textTheme.bodyLarge,
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _textControllers[index],
          decoration: InputDecoration(
            hintText: 'Nhập câu trả lời...',
            border: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.blue, width: 2),
              borderRadius: BorderRadius.circular(8),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.blue, width: 2),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            side: const BorderSide(color: Colors.green, width: 2),
            backgroundColor: Colors.grey[200],
            foregroundColor: Colors.green,
          ),
          onPressed: () {
            final answer = _textControllers[index]?.text ?? "";
            if (answer.isNotEmpty) {
              _registerAnswer(question.id, answer);
            }
          },
          child: const Text("ENTER"),
        ),
      ],
    );
  }

  // --- 6. TRAY WIDGET BUILDERS ---

  /// Builds the small, collapsed tray at the bottom
  Widget _buildCollapsedTrayContent(TextTheme textTheme, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        children: [
          Row(
            children: [
              // Left Arrow
              IconButton(
                iconSize: 60,
                icon: const Icon(Icons.arrow_left),
                onPressed: _currentPage > 0
                    ? () => _jumpToPage(_currentPage - 1)
                    : null,
              ),
              const SizedBox(width: 16),
              // Question Indicators (Scrollable)
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(_questions.length, (index) {
                      return _buildQuestionIndicator(index, colorScheme);
                    }),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Right Arrow
              IconButton(
                iconSize: 60,
                icon: const Icon(Icons.arrow_right),
                onPressed: _currentPage < _questions.length - 1
                    ? () => _jumpToPage(_currentPage + 1)
                    : null,
              ),
              // Expand Button
              IconButton(
                iconSize: 36,
                icon: const Icon(Icons.arrow_upward), // "delta"
                onPressed: _toggleExpandTray,
              ),
            ],
          ),
          const Spacer(),
          Text(
            '${_currentPage + 1} / ${_questions.length}',
            style: textTheme.bodyMedium?.copyWith(color: Colors.black54),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  /// Builds the large, expanded tray
  Widget _buildExpandedTrayContent(TextTheme textTheme, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Collapse Button
          IconButton(
            icon: const Icon(Icons.arrow_downward), // "nabla"
            onPressed: _toggleExpandTray,
          ),
          // Question Grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 12, // As per your image
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: _questions.length,
              itemBuilder: (context, index) {
                return _buildQuestionIndicator(index, colorScheme);
              },
            ),
          ),
          // Bottom Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ReturnButton(), // Your custom widget
              SettingButton(), // Your custom widget
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  side: const BorderSide(color: Colors.green, width: 2),
                  backgroundColor: Colors.grey[200],
                  foregroundColor: Colors.green,
                ),
                onPressed: _submitTest,
                child: const Text("Submit")
              ),
            ],
          )
        ],
      ),
    );
  }

  /// Builds one single question indicator square
  Widget _buildQuestionIndicator(int index, ColorScheme colorScheme) {
    final questionId = _questions[index].id;
    final bool isAnswered = _answers.containsKey(questionId);
    final bool isCurrent = _currentPage == index;

    Color color = Colors.grey[100]!;
    Border? border = Border.all(color: Colors.green, width: 2); // Default green border

    if (isAnswered) {
      color = Colors.green.withOpacity(0.5); // Answered = filled
    }
    if (isCurrent) {
      border = Border.all(color: colorScheme.primary, width: 3); // Current = thick blue
    }

    return GestureDetector(
      onTap: () => _jumpToPage(index),
      child: Container(
        width: 64,
        height: 64,
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
        decoration: BoxDecoration(
          color: color,
          border: border,
          borderRadius: BorderRadius.circular(4),
        ),
        child: FittedBox(
          fit: BoxFit.contain, // This is the default
          child: Text(
              (index + 1).toString(),
          ))
      ),
    );
  }
}