// screens/editable_reading_screen.dart
import 'package:flutter/material.dart';
import 'package:nodyslexia/customwigdets/dictionary_entry_display.dart';
import 'package:provider/provider.dart';
import 'package:nodyslexia/customwigdets/adjustable_text.dart';
import 'package:nodyslexia/customwigdets/return_button.dart';
import 'package:nodyslexia/customwigdets/settings_button.dart';
import 'package:nodyslexia/utils/tts_service.dart';

// Import your ViewModel
import 'package:nodyslexia/modules/reading/editable_reading_viewmodel.dart';
import 'package:nodyslexia/modules/settings/text_settings.dart';

import '../../data/persistence.dart';
import '../../models/converted_file.dart';
import '../editing/editing_screen.dart';
import '../editing/editing_viewmodel.dart';

class EditableReadingScreen extends StatelessWidget {
  // Use a local key reference inside the context hierarchy to calculate placement targets
  final GlobalKey _textKey = GlobalKey();

  EditableReadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<EditableReadingViewModel>();
    final textTheme = Theme.of(context).textTheme;

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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: List.generate(viewModel.paragraphs.length, (index) {
                          final isSelected = index == viewModel.selectedParagraphIndex;
                          final paragraphText = viewModel.paragraphs[index];

                          return GestureDetector(
                            onTap: () {
                              viewModel.selectParagraph(index);
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              margin: const EdgeInsets.symmetric(vertical: 4.0),
                              padding: const EdgeInsets.all(12.0),
                              decoration: BoxDecoration(
                                color: isSelected ? Colors.white : Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(8.0),
                                border: Border.all(
                                  color: isSelected ? Colors.teal : Colors.transparent,
                                  width: 1.5,
                                ),
                              ),
                              child: IntrinsicHeight(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Opacity(
                                        opacity: isSelected ? 1.0 : 0.6,
                                        child: SelectableAdjustableText(
                                          key: isSelected ? _textKey : null,
                                          paragraphText,
                                          isSelected ? viewModel.currentWordStart : -1,
                                          isSelected ? viewModel.currentWordEnd : -1,
                                          textAlign: TextAlign.justify,
                                          onTextSelected: (selection, offset) {
                                            if (isSelected) {
                                              viewModel.updateSelection(selection, offset);
                                            }
                                          },
                                          onReadPressed: () {
                                            viewModel.toggleTtsSelection();
                                          },
                                          onDefinePressed: () async {
                                            final dictionaryEntry = await viewModel.getWordDefinition();
                                            if (context.mounted) {
                                              DictionaryDetailDialog.show(
                                                  context,
                                                  dictionaryEntry,
                                                  viewModel.ttsService);
                                            }
                                          },
                                          onHighlightPressed: () {
                                            if (viewModel.currentSelection != null) {
                                              final String text = viewModel.currentSelection!;
                                              final settings = context.read<TextStyleSettings>();
                                              final db = context.read<LocalDatabase>();
                                              if (settings.highlights.contains(text.trim())) {
                                                settings.removeHighlight(db, text);
                                              } else {
                                                settings.addHighlight(db, text);
                                              }
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    GestureDetector(
                                      behavior: HitTestBehavior.opaque,
                                      onTap: () {
                                        viewModel.selectParagraph(index);
                                      },
                                      child: Container(
                                        width: 28,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: isSelected ? Colors.teal : Colors.grey.shade400,
                                          borderRadius: BorderRadius.circular(6.0),
                                        ),
                                        child: Icon(
                                          isSelected ? Icons.check : Icons.circle_outlined,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
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
                          min: 0.05,
                          max: 1.2,
                          divisions: 24,
                          label: 'Tốc độ đọc: ${viewModel.currentReadingSpeed.toStringAsFixed(2)}x',
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
                      ReturnButton(
                        onReturn: (context) {
                          Navigator.pop(context, viewModel.file);
                        },
                      ),
                      ElevatedButton.icon(
                        icon: Icon(viewModel.ttsState == TtsState.playing && viewModel.currentTtsMode == TtsMode.paragraph
                            ? Icons.stop_circle_outlined
                            : Icons.play_circle_outline),
                        label: Text(
                            viewModel.ttsState == TtsState.playing && viewModel.currentTtsMode == TtsMode.paragraph ? 'Dừng' : 'Đọc đoạn chọn',
                            style: textTheme.bodySmall!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.white
                            )),
                        onPressed: viewModel.toggleTtsParagraph,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: viewModel.ttsState == TtsState.playing && viewModel.currentTtsMode == TtsMode.paragraph ? Colors.redAccent : Colors.teal,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        ),
                      ),
                      ElevatedButton.icon(
                        icon: Icon(viewModel.ttsState == TtsState.playing && viewModel.currentTtsMode == TtsMode.all
                            ? Icons.stop_circle_outlined
                            : Icons.menu_book_outlined),
                        label: Text(
                            viewModel.ttsState == TtsState.playing && viewModel.currentTtsMode == TtsMode.all ? 'Dừng' : 'Đọc toàn bộ',
                            style: textTheme.bodySmall!.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.white
                            )),
                        onPressed: viewModel.toggleTtsAll,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: viewModel.ttsState == TtsState.playing && viewModel.currentTtsMode == TtsMode.all ? Colors.redAccent : Colors.teal[800],
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        ),
                      ),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.edit_outlined),
                        label: Text('Chỉnh sửa',
                            style: textTheme.bodySmall!.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.white
                            )),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal[600],
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        ),
                        onPressed: () async {
                          // Stop TTS playback automatically before leaving the screen context
                          if (viewModel.ttsState == TtsState.playing) {
                            viewModel.handleStopReading();
                          }

                          // Secure route navigation using decoupled provider initialization rules
                          final newFile = await Navigator.push<ConvertedFile>(
                            context,
                            MaterialPageRoute(
                              builder: (routeContext) => ChangeNotifierProvider<EditingViewModel>(
                                create: (providerContext) => EditingViewModel(
                                  file: viewModel.file,
                                  localDatabase: providerContext.read<LocalDatabase>(), // Read database up the context tree
                                ),
                                child: const EditingScreen(),
                              ),
                            ),
                          );
                          viewModel.refreshContent(newFile!);
                        },
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