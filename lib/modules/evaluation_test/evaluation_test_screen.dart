import 'package:flutter/material.dart';
import 'package:nodyslexia/customwigdets/return_button.dart';
import 'package:nodyslexia/data/repository_manager.dart';
import 'package:nodyslexia/modules/evaluation_test/evaluation_test_viewmodel.dart';
import 'package:nodyslexia/modules/settings/text_settings.dart';
import 'package:provider/provider.dart';

class EvaluationTestScreen extends StatelessWidget {
  const EvaluationTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<EvaluationTestViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFFE8E8E8),
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 70), // Leave space for ReturnButton
                child: switch (viewModel.currentState) {
                  EvalTestState.START => _buildStartScreen(context, viewModel),
                  EvalTestState.IN_PROGRESS => _buildInProgressScreen(context, viewModel),
                  EvalTestState.END => _buildEndScreen(context, viewModel),
                },
              ),
            ),

            // ReturnButton at bottom-left corner across all states
            Positioned(
              left: 16,
              bottom: 16,
              child: ReturnButton(
                onReturn: (ctx) {
                  if (viewModel.currentState == EvalTestState.IN_PROGRESS) {
                    viewModel.resetTest();
                  } else {
                    Navigator.of(ctx).maybePop();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- 1. START SCREEN ---
  Widget _buildStartScreen(BuildContext context, EvaluationTestViewModel viewModel) {
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Bài kiểm tra đầu vào",
              style: textTheme.displayLarge?.copyWith(
                color: Colors.teal[800],
                fontWeight: FontWeight.bold,
              ) ?? TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.teal[800]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Text(
                "Bài kiểm tra này giúp đánh giá khả năng nhận diện chữ cái và tìm ra định dạng hiển thị văn bản phù hợp nhất với em (phông chữ, kích thước, khoảng cách và màu nền).\n\nHãy bấm bắt đầu để tiến hành bài kiểm tra!",
                style: textTheme.bodyMedium?.copyWith(
                  fontSize: 20,
                  height: 1.5,
                  color: Colors.grey[800],
                ) ?? const TextStyle(fontSize: 18, height: 1.5),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => viewModel.startTest(),
              child: const Text(
                "Bắt đầu kiểm tra",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- 2. IN_PROGRESS SCREEN ---
  Widget _buildInProgressScreen(BuildContext context, EvaluationTestViewModel viewModel) {
    final textTheme = Theme.of(context).textTheme;

    List<TextSpan> headerText = viewModel.currentType == 0
        ? [TextSpan(text: "Hãy chọn chữ "),
          TextSpan(text: viewModel.currentTarget,
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800)),
          TextSpan(text:" mà em thấy dễ đọc nhất")]
        : [TextSpan(text: "Hãy chọn câu/từ mà em thấy dễ nhìn nhất")];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        children: [
          // Header text area without border (clean white background)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text.rich(
              TextSpan(
                style: textTheme.bodyLarge?.copyWith(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ) ?? const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                children: headerText
              ),
              textAlign: TextAlign.center,
            ),
          ),

          // Optional Try-Again Error Prompt Banner for Type 0 wrong selections
          if (viewModel.errorMessage != null) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.amber[100],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.amber[800]!),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.info_outline, color: Colors.amber[900], size: 20),
                  const SizedBox(width: 8),
                  Text(
                    viewModel.errorMessage!,
                    style: TextStyle(
                      color: Colors.amber[900],
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 12),

          // Question presentation fitting screen height exactly
          Expanded(
            child: _buildGrid(context, viewModel),
          ),
        ],
      ),
    );
  }

// Two-row grid for Type 0 and Type 1: columns grow with the item count, cells are evenly spaced
  Widget _buildGrid(BuildContext context, EvaluationTestViewModel viewModel) {
    final items = viewModel.displayAnswerList;
    final int columns = (items.length / 2).ceil();

    Widget buildRow(int row) {
      return Expanded(
        child: Row(
          children: List.generate(columns, (col) {
            final int index = row * columns + col;
            return Expanded(
              child: index < items.length
                  ? _buildGridCard(context, viewModel, items[index])
                  : const SizedBox.shrink(), // keeps columns aligned when the count is odd
            );
          }),
        ),
      );
    }

    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      clipBehavior: Clip.antiAlias,
      child: Column(children: [buildRow(0), buildRow(1)]),
    );
  }

  Widget _buildGridCard(BuildContext context, EvaluationTestViewModel viewModel, Map<String, dynamic> option) {
    String displayText = viewModel.currentType == 0
        ? option["letter"] ?? ""
        : option["word"] ?? "";

    String fontFamily = option["font"] ?? "VniAvo";
    double fontSize = (option["size"] as num?)?.toDouble() ?? 20.0;
    double wordSpacing = (option["word_spacing"] as num?)?.toDouble() ?? 0.0;
    double letterSpacing = (option["letter_spacing"] as num?)?.toDouble() ?? 0.0;
    double opacity = (option["opacity"] as num?)?.toDouble() ?? 1.0;
    Color textColor = option["text_color"] ?? Colors.black;
    Color bgColor = option["bg_color"] ?? Colors.white;

    return Material(
      color: bgColor,
      child: InkWell(
        onTap: () => viewModel.selectAnswer(option),
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          child: Text(
            displayText,
            style: TextStyle(
              fontFamily: fontFamily,
              fontSize: fontSize,
              wordSpacing: wordSpacing,
              letterSpacing: letterSpacing,
              color: textColor.withAlpha((255 * opacity).toInt()),
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }

  // --- 3. END SCREEN ---
  Widget _buildEndScreen(BuildContext context, EvaluationTestViewModel viewModel) {
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Kết quả kiểm tra",
              style: textTheme.displayLarge?.copyWith(
                color: Colors.teal[800],
                fontWeight: FontWeight.bold,
              ) ?? TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.teal[800]),
            ),
            const SizedBox(height: 20),

            // Performance Card (Type 0)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.analytics, color: Colors.teal[700], size: 28),
                      const SizedBox(width: 10),
                      Text(
                        "Khả năng nhận diện chữ",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.teal[800]),
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  _buildResultRow("Độ chính xác:", "${viewModel.type0Accuracy.toStringAsFixed(1)}%"),
                  const SizedBox(height: 8),
                  _buildResultRow("Thời gian trung bình:", "${viewModel.type0AverageTimeSeconds.toStringAsFixed(1)} giây / lượt"),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Preferred Format Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.tune, color: Colors.teal[700], size: 28),
                      const SizedBox(width: 10),
                      Text(
                        "Định dạng văn bản tối ưu",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.teal[800]),
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  _buildResultRow("Phông chữ ưu tiên:", viewModel.preferredFontFamily),
                  const SizedBox(height: 8),
                  _buildResultRow("Kích thước chữ:", "${viewModel.preferredFontSize.toStringAsFixed(0)} pt"),
                  const SizedBox(height: 8),
                  _buildResultRow("Độ rõ chữ:", viewModel.preferredFontOpacity.toStringAsFixed(2)),
                  const SizedBox(height: 8),
                  _buildResultRow("Khoảng cách từ:", viewModel.preferredWordSpacing.toStringAsFixed(1)),
                  const SizedBox(height: 8),
                  _buildResultRow("Khoảng cách chữ:", viewModel.preferredLetterSpacing.toStringAsFixed(1)),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Màu nền ưu tiên:",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: viewModel.preferredBackgroundColor,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey[400]!),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Màu chữ ưu tiên:",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: viewModel.preferredTextColor,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey[400]!),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),

            const SizedBox(height: 32),

            ElevatedButton.icon(
              onPressed: () {
                final textSettings = context.read<NokodoSettings>();
                viewModel.applyPreferredSettings(textSettings);
                try {
                  final repoManager = context.read<RepoManager>();
                  repoManager.saveStudentSettings(textSettings.toMap());
                } catch (e) {
                  debugPrint("EVALUATION: Settings sync failed: $e");
                }
                viewModel.resetTest();
                Navigator.of(context).maybePop();
              },
              icon: const Icon(Icons.check_circle_outline, size: 28),
              label: const Text(
                "Hoàn thành & Lưu cài đặt",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        Text(
          value,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal[900]),
        ),
      ],
    );
  }
}