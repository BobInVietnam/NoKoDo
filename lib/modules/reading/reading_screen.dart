// screens/reading_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nodyslexia/customwigdets/adjustable_text.dart';
import 'package:nodyslexia/customwigdets/return_button.dart';
import 'package:nodyslexia/customwigdets/settings_button.dart';
import 'package:nodyslexia/utils/tts_service.dart';

// Import your ViewModel
import 'package:nodyslexia/modules/reading/reading_viewmodel.dart';

class ReadingScreen extends StatelessWidget {
  // Use a local key reference inside the context hierarchy to calculate placement targets
  final GlobalKey _textKey = GlobalKey();

  ReadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final viewModel = context.watch<ReadingViewModel>();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            // Text Display Area
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: GestureDetector(
                  // onTap: viewModel.removeSelectionMenu,
                  child: Container(
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(color: Colors.grey.shade300),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: SingleChildScrollView(
                      child: SelectableAdjustableText(
                        key: _textKey,
                        viewModel.extractedText,
                        viewModel.currentWordStart,
                        viewModel.currentWordEnd,
                        textAlign: TextAlign.justify,
                        onTextSelected: (selection, offset) {
                            viewModel.updateSelection(selection, offset);
                        },
                        onReadPressed: () {
                          viewModel.toggleTts();
                        },
                        onDefinePressed: () {
                          //TODO Implement this
                          debugPrint("READING: Define function pressed");
                        },
                        onHighlightPressed: () {
                          //TODO Implement this
                          debugPrint("READING: Highlight function pressed");
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Bottom Control Bar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Reading Speed Slider
                  Row(
                    children: [
                      const Icon(Icons.speed, color: Colors.grey),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Slider(
                          value: viewModel.currentReadingSpeed,
                          min: 0.1,
                          max: 1.5,
                          divisions: 14,
                          label: 'Speed: ${viewModel.currentReadingSpeed.toStringAsFixed(1)}x',
                          onChanged: viewModel.handleSpeedChange,
                          activeColor: Colors.teal,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Action Buttons (Return, Read All/Stop, Settings)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const ReturnButton(),
                      ElevatedButton.icon(
                        icon: Icon(viewModel.ttsState == TtsState.playing
                            ? Icons.stop_circle_outlined
                            : Icons.play_circle_outline),
                        label: Text(viewModel.ttsState == TtsState.playing ? 'Stop' : 'Read All'),
                        onPressed: viewModel.toggleTts,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: viewModel.ttsState == TtsState.playing ? Colors.redAccent : Colors.teal,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        ),
                      ),
                      const SettingButton()
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}