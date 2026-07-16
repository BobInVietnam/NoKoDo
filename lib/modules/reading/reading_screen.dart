import 'package:flutter/material.dart';
import 'package:nodyslexia/customwigdets/dictionary_entry_display.dart';
import 'package:provider/provider.dart';
import 'package:nodyslexia/customwigdets/adjustable_text.dart';
import 'package:nodyslexia/customwigdets/return_button.dart';
import 'package:nodyslexia/customwigdets/settings_button.dart';
import 'package:nodyslexia/utils/tts_service.dart';
import 'package:nodyslexia/modules/reading/reading_viewmodel.dart';

class ReadingScreen extends StatefulWidget {
  const ReadingScreen({super.key});

  @override
  State<ReadingScreen> createState() => _ReadingScreenState();
}

class _ReadingScreenState extends State<ReadingScreen> {
  final GlobalKey _textKey = GlobalKey();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.hasClients) {
      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.position.pixels;
      // Triggers scrolled to bottom when within a 15-pixel tolerance
      if (currentScroll >= maxScroll - 15) {
        context.read<ReadingViewModel>().markScrolledToBottom();
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ReadingViewModel>();

    // Post-frame check to auto-mark scrolledToBottom if the text is short
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context.mounted && _scrollController.hasClients) {
        final maxScroll = _scrollController.position.maxScrollExtent;
        if (maxScroll <= 0) {
          context.read<ReadingViewModel>().markScrolledToBottom();
        }
      }
    });

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          context.read<ReadingViewModel>().syncLessonResultIfCriteriaMet();
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: <Widget>[
              // Text Display Area
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
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
                      controller: _scrollController,
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
                                            debugPrint("READING: Highlight function pressed");
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
                        ReturnButton(
                          onReturn: (context) {
                            Navigator.pop(context);
                          },
                        ),
                        ElevatedButton.icon(
                          icon: Icon(viewModel.ttsState == TtsState.playing && viewModel.currentTtsMode == TtsMode.paragraph
                              ? Icons.stop_circle_outlined
                              : Icons.play_circle_outline),
                          label: Text(viewModel.ttsState == TtsState.playing && viewModel.currentTtsMode == TtsMode.paragraph ? 'Dừng' : 'Đọc đoạn chọn'),
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
                          label: Text(viewModel.ttsState == TtsState.playing && viewModel.currentTtsMode == TtsMode.all ? 'Dừng' : 'Đọc toàn bộ'),
                          onPressed: viewModel.toggleTtsAll,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: viewModel.ttsState == TtsState.playing && viewModel.currentTtsMode == TtsMode.all ? Colors.redAccent : Colors.teal[800],
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
      ),
    );
  }
}