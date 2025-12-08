import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Import the custom buttons from your project
import 'package:nodyslexia/customwigdets/return_button.dart';
import 'package:nodyslexia/customwigdets/settings_button.dart';

import 'package:nodyslexia/models/test.dart';

import 'package:nodyslexia/utils/repository_manager.dart';

// --- 2. THE TEST SCREEN WIDGET ---

class TestScreen extends StatefulWidget {
  final Test test; // The screen is built based on this test object
  final TestSession testSession;
  TestScreen({super.key, required this.test, required this.testSession});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  late final PageController _pageController;
  late final List<Question> _questions;

  // State variables
  int _currentPage = 0;
  bool _isTrayExpanded = false;
  final Map<int, dynamic> _answers = {}; // Stores {questionId: answer}
  final Map<int, TextEditingController> _textControllers = {}; // To manage text fields

  @override
  void initState() {
    super.initState();
    _questions = widget.test.questions;
    _pageController = PageController();

    // Initialize text controllers for text input questions
    for (int i = 0; i < _questions.length; i++) {
      _answers[_questions[i].id] = null;
      if (_questions[i] is FillBlankQuestion) {
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
  void _registerAnswer(int questionId, dynamic answer) {
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
    // 1. Show the initial confirmation dialog
    showDialog(
      context: context,
      builder: (confirmContext) => AlertDialog( // Rename context to avoid confusion
        title: const Text('Nộp bài?'),
        content: const Text('Bạn có chắc chắn muốn nộp bài không?'),
        actions: [
          TextButton(
            // Just close the confirmation dialog
            onPressed: () => Navigator.pop(confirmContext),
            child: const Text('Huỷ'),
          ),
          TextButton(
            onPressed: () async {
              // A. Close the "Are you sure?" dialog first
              Navigator.pop(confirmContext);

              // B. Show a non-dismissible Loading Dialog
              showDialog(
                context: context,
                barrierDismissible: false, // Prevents clicking outside to close
                builder: (loadingContext) => const Center(
                  child: CircularProgressIndicator(), // Or a custom loading widget
                ),
              );

              try {
                // C. Prepare the data
                TestSession submitTestSession = TestSession(
                    id: widget.testSession.id,
                    testId: widget.testSession.testId,
                    studentId: widget.testSession.studentId,
                    startTime: widget.testSession.startTime,
                    endTime: DateTime.now().millisecondsSinceEpoch,
                    score: Question.calculateScore(_questions, _answers)
                );

                // D. Run the async operation (The Waiting Part)
                await RepoManager().updateTestSessionStatus(submitTestSession);
                await RepoManager().sendTestAnswers(widget.testSession, _answers);

                debugPrint("Bài đã nộp: $_answers");

                // E. Close the Loading Dialog
                // We check 'mounted' to ensure the widget tree is still valid
                if (context.mounted) {
                  Navigator.pop(context);
                }

                // F. Close the Test Screen (Go back to menu)
                if (context.mounted) {
                  Navigator.pop(context);
                }

                // Optional: If you want to go to results instead of popping:
                // if (context.mounted) {
                //    Navigator.pushReplacement(context, MaterialPageRoute(...));
                // }

              } catch (e) {
                // Handle error: Close loader and show error
                if (context.mounted) {
                  Navigator.pop(context); // Close loader
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Lỗi: $e')),
                  );
                }
              }
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
                question.content,
                style: textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Answer Area (Dynamic)
          if (question is MultipleChoiceQuestion)
            _buildMultipleChoiceOptions(question),
          if (question is FillBlankQuestion)
            _buildTextInput(question, index),
        ],
      ),
    );
  }

  /// Builds the 4-grid for Multiple Choice
  Widget _buildMultipleChoiceOptions(MultipleChoiceQuestion question) {
    final textTheme = Theme.of(context).textTheme;
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 4 / 1,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: question.options.length ?? 0,
      shrinkWrap: true, // Important for GridView in a Column
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final option = question.options[index];
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
  Widget _buildTextInput(FillBlankQuestion question, int index) {
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
    final bool isAnswered = (_answers[questionId] != null);
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

