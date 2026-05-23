// lib/modules/reading/tts_highlight_test_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nodyslexia/modules/reading/reading_viewmodel.dart';

class TtsHighlightTestScreen extends StatelessWidget {
  const TtsHighlightTestScreen({super.key});

  /// Dynamically segments text strings based on active native character array metrics
  List<TextSpan> _buildHighlightSpans(
      String fullText,
      int start,
      int end,
      TextStyle baseStyle,
      Color highlightColor,
      ) {
    // If no word is actively processing, return the text frame un-highlighted
    if (start == -1 || end == -1 || start >= fullText.length || end > fullText.length) {
      return [TextSpan(text: fullText, style: baseStyle)];
    }

    return [
      // 1. Strings before the highlighted keyword token
      TextSpan(
        text: fullText.substring(0, start),
        style: baseStyle,
      ),
      // 2. The active matching keyword token painted with custom background properties
      TextSpan(
        text: fullText.substring(start, end),
        style: baseStyle.copyWith(
          backgroundColor: highlightColor,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      // 3. Trailing strings remaining after the highlighted keyword token
      TextSpan(
        text: fullText.substring(end),
        style: baseStyle,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    // Listen to real-time progress emissions from our injected viewmodel
    final viewModel = context.watch<ReadingViewModel>();

    final baseTextStyle = TextStyle(
      fontSize: 24,
      height: 1.6,
      color: Colors.grey[800],
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('TTS Real-time Highlight Tester'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // 1. Text Container Render Area
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.teal.shade200, width: 2),
                  ),
                  child: SingleChildScrollView(
                    child: SelectionArea(
                      child: RichText(
                        textAlign: TextAlign.justify,
                        text: TextSpan(
                          children: _buildHighlightSpans(
                            viewModel.extractedText,
                            viewModel.currentWordStart, // tracked by progress indices
                            viewModel.currentWordEnd,   // tracked by progress indices
                            baseTextStyle,
                            Colors.yellow[400]!, // Custom marker tint
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // 2. Playback Control Trigger Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: viewModel.handleReadAll,
                    icon: const Icon(Icons.play_arrow),
                    label: const Text("Đọc Truyện"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton.icon(
                    onPressed: viewModel.handleStopReading,
                    icon: const Icon(Icons.stop),
                    label: const Text("Dừng"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}