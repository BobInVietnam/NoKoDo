import 'package:flutter/material.dart';
import 'package:nodyslexia/customwigdets/return_button.dart';
import 'package:nodyslexia/customwigdets/settings_button.dart';
import 'package:nodyslexia/models/test.dart';
import 'package:nodyslexia/modules/test/test_viewmodel.dart';
import 'package:provider/provider.dart';

class TestScreen extends StatelessWidget {
  const TestScreen({super.key});

  void _submitTest(BuildContext context, TestViewModel viewModel) {
    final textTheme = Theme.of(context).textTheme;
    showDialog(
      context: context,
      builder: (confirmContext) => AlertDialog(
        title: const Text('Nộp bài?'),
        content: const Text('Bạn có chắc chắn muốn nộp bài không?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(confirmContext),
            child: Text('Huỷ', style: textTheme.bodySmall!.copyWith(color: Colors.teal[800])),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(confirmContext); // Close confirmation dialog

              // Show a non-dismissible loading dialog
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (loadingContext) => const Center(
                  child: CircularProgressIndicator(),
                ),
              );

              try {
                await viewModel.submitTest();
                if (context.mounted) {
                  Navigator.pop(context); // Close loading dialog
                  Navigator.pop(context); // Exit TestScreen
                }
              } catch (e) {
                if (context.mounted) {
                  Navigator.pop(context); // Close loading dialog
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Lỗi: $e')),
                  );
                }
              }
            },
            child: Text('Nộp bài', style: textTheme.bodySmall!.copyWith(color: Colors.teal[800])),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final viewModel = context.watch<TestViewModel>();
    final questions = viewModel.questions;

    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Column(
          children: [
            // --- QUESTION AREA ---
            Expanded(
              child: PageView.builder(
                controller: viewModel.pageController,
                itemCount: questions.length,
                onPageChanged: viewModel.setCurrentPage,
                itemBuilder: (context, index) {
                  return _buildQuestionPage(context, viewModel, questions[index], index);
                },
              ),
            ),

            // --- BOTTOM TRAY ---
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
              height: viewModel.isTrayExpanded ? 450 : 150,
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
              child: viewModel.isTrayExpanded
                  ? _buildExpandedTrayContent(context, viewModel, textTheme, colorScheme)
                  : _buildCollapsedTrayContent(context, viewModel, textTheme, colorScheme),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionPage(BuildContext context, TestViewModel viewModel, Question question, int index) {
    bool isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Question Box
          isKeyboardOpen
              ? const SizedBox(height: 0)
              : Container(
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
            _buildMultipleChoiceOptions(context, viewModel, question),
          if (question is FillBlankQuestion)
            _buildTextInput(context, viewModel, question, index),
        ],
      ),
    );
  }

  Widget _buildMultipleChoiceOptions(BuildContext context, TestViewModel viewModel, MultipleChoiceQuestion question) {
    final textTheme = Theme.of(context).textTheme;
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 4 / 1,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: question.options.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final option = question.options[index];
        return InkWell(
          onTap: () => viewModel.registerAnswer(question.id, option),
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

  Widget _buildTextInput(BuildContext context, TestViewModel viewModel, FillBlankQuestion question, int index) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        Text(
          "Nhập câu trả lời của bạn",
          style: textTheme.bodyLarge,
        ),
        const SizedBox(height: 12),
        TextField(
          controller: viewModel.textControllers[index],
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
            final answer = viewModel.textControllers[index]?.text ?? "";
            if (answer.isNotEmpty) {
              viewModel.registerAnswer(question.id, answer);
            }
          },
          child: const Text("XÁC NHẬN"),
        ),
      ],
    );
  }

  Widget _buildCollapsedTrayContent(BuildContext context, TestViewModel viewModel, TextTheme textTheme, ColorScheme colorScheme) {
    final questions = viewModel.questions;
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
                onPressed: viewModel.currentPage > 0
                    ? () => viewModel.jumpToPage(viewModel.currentPage - 1)
                    : null,
              ),
              const SizedBox(width: 16),
              // Question Indicators (Scrollable)
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: List.generate(questions.length, (index) {
                      return _buildQuestionIndicator(viewModel, index, colorScheme);
                    }),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Right Arrow
              IconButton(
                iconSize: 60,
                icon: const Icon(Icons.arrow_right),
                onPressed: viewModel.currentPage < questions.length - 1
                    ? () => viewModel.jumpToPage(viewModel.currentPage + 1)
                    : null,
              ),
              // Expand Button
              IconButton(
                iconSize: 36,
                icon: const Icon(Icons.arrow_upward),
                onPressed: viewModel.toggleExpandTray,
              ),
            ],
          ),
          const Spacer(),
          Text(
            '${viewModel.currentPage + 1} / ${questions.length}',
            style: textTheme.bodyMedium?.copyWith(color: Colors.black54),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildExpandedTrayContent(BuildContext context, TestViewModel viewModel, TextTheme textTheme, ColorScheme colorScheme) {
    final questions = viewModel.questions;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Collapse Button
          IconButton(
            icon: const Icon(Icons.arrow_downward),
            onPressed: viewModel.toggleExpandTray,
          ),
          // Question Grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 12,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: questions.length,
              itemBuilder: (context, index) {
                return _buildQuestionIndicator(viewModel, index, colorScheme);
              },
            ),
          ),
          // Bottom Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ReturnButton(),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  side: const BorderSide(color: Colors.green, width: 4),
                  padding: EdgeInsets.fromLTRB(24, 8, 24, 8),
                  backgroundColor: Colors.grey[200],
                  foregroundColor: Colors.teal,
                ),
                onPressed: () => _submitTest(context, viewModel),
                child: Text("Nộp bài", style: textTheme.bodyMedium,),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildQuestionIndicator(TestViewModel viewModel, int index, ColorScheme colorScheme) {
    final questions = viewModel.questions;
    final questionId = questions[index].id;
    final bool isAnswered = (viewModel.answers[questionId] != null);
    final bool isCurrent = viewModel.currentPage == index;

    Color color = Colors.grey[100]!;
    Border? border = Border.all(color: Colors.green, width: 2);

    if (isAnswered) {
      color = Colors.green.withOpacity(0.5);
    }
    if (isCurrent) {
      border = Border.all(color: colorScheme.primary, width: 3);
    }

    return GestureDetector(
      onTap: () => viewModel.jumpToPage(index),
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
          fit: BoxFit.contain,
          child: Text(
            (index + 1).toString(),
          ),
        ),
      ),
    );
  }
}
