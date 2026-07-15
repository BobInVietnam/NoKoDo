import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nodyslexia/customwigdets/return_button.dart';
import 'package:nodyslexia/customwigdets/settings_button.dart';
import 'package:nodyslexia/modules/letter_search/letter_search_viewmodel.dart';
import 'package:provider/provider.dart';

class LetterSearchScreen extends StatelessWidget {
  const LetterSearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<LetterSearchViewModel>();
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Colors.teal.shade50,
      body: SafeArea(
        child: Column(
          children: [
            // Top Status Header / Timer Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Tìm chữ: Vòng ${viewModel.currentRound + 1}/${viewModel.totalRound}',
                    style: textTheme.displayMedium,
                  ),
                  if (viewModel.currentState == GameState.IN_PROGRESS)
                    Row(
                      children: [
                        const Icon(Icons.timer_outlined, color: Colors.teal, size: 20),
                        const SizedBox(width: 4),
                        Text(
                          '${viewModel.elapsedSeconds.toStringAsFixed(1)} giây',
                          style: textTheme.displayMedium
                        ),
                      ],
                    ),
                ],
              ),
            ),
            const Divider(height: 1),

            // Main body area depending on GameState
            Expanded(
              child: _buildBody(context, viewModel),
            ),

            // Bottom Navigation Actions
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ReturnButton()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, LetterSearchViewModel viewModel) {
    final textTheme = Theme.of(context).textTheme;

    switch (viewModel.currentState) {
      case GameState.START:
        return Center(
          child: ElevatedButton(
            onPressed: viewModel.startGame,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
            child: Text(
              'Bắt đầu trò chơi',
              style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
        );

      case GameState.COUNTDOWN:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Chuẩn bị!',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                  color: Colors.teal[800],
                ),
              ),
              const SizedBox(height: 20),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, animation) => ScaleTransition(scale: animation, child: child),
                child: Text(
                  '${viewModel.countdownSeconds}',
                  key: ValueKey<int>(viewModel.countdownSeconds),
                  style: GoogleFonts.rowdies(
                    fontSize: 120,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal[700],
                  ),
                ),
              ),
            ],
          ),
        );

      case GameState.IN_PROGRESS:
        final feedback = viewModel.feedbackMessage;
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            // Grid Display
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.teal.withOpacity(0.1),
                          spreadRadius: 2,
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min, // 1. Tells the Column to hug its rows vertically
                      children: List.generate(viewModel.currentGridHeight, (rowIndex) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center, // 2. Centers the characters horizontally
                          mainAxisSize: MainAxisSize.min, // 3. Tells the Row to hug its items tightly
                          children: List.generate(viewModel.currentGridWidth, (colIndex) {
                            final char = viewModel.displayGrid[rowIndex][colIndex];

                            // 4. Set a square bounding box proportional to the text size
                            final double cellSize = viewModel.currentSize * 1.0;

                            return Padding(
                              padding: EdgeInsets.all(viewModel.currentSpacing),
                              child: SizedBox(
                                width: cellSize,
                                height: cellSize,
                                child: Material(
                                  color: Colors.transparent, // Keeps the parent Container's background
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(4.0),
                                    onTap: () => viewModel.handleCellTap(rowIndex, colIndex),
                                    child: Center(
                                      child: Text(
                                        char,
                                        style: textTheme.bodyLarge?.copyWith(
                                          fontSize: viewModel.currentSize,
                                          height: 1.0, // Prevents native font metrics padding issues
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        );
                      }),
                    ),
                  ),

              ),
            const SizedBox(height: 16),
            Text(
              "Ký tự cần tìm: ${viewModel.target}",
              style: textTheme.displayMedium
            ),
            // Feedback status bar
            Container(
              height: 48,
              alignment: Alignment.center,
              child: feedback == null
                  ? const SizedBox.shrink()
                  : AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                      decoration: BoxDecoration(
                        color: feedback == "Chính xác!" ? Colors.green.shade100 : Colors.red.shade100,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        feedback,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: feedback == "Chính xác!" ? Colors.green.shade800 : Colors.red.shade800,
                        ),
                      ),
                    ),
            ),
            const SizedBox(height: 20),
          ],
        );

      case GameState.FINISHED:
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Chúc mừng! Bạn đã hoàn thành bài tập!',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal[800],
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Kết quả chi tiết:',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal[900],
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: viewModel.results.length,
                  itemBuilder: (context, index) {
                    final res = viewModel.results[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.teal,
                          child: Text(
                            '${res["round"]}',
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                        title: Text(
                          'Tìm chữ "${res["target"]}"',
                          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          'Thời gian: ${(res["time"] as double).toStringAsFixed(1)} giây | Số lần bấm: ${res["attempts"]}',
                          style: GoogleFonts.poppins(),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
    }
  }
}