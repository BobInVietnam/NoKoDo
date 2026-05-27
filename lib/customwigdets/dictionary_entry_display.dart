import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:nodyslexia/models/dictionary_entry.dart';
import 'package:nodyslexia/utils/tts_service.dart';

class DictionaryDetailDialog extends StatelessWidget {
  final DictionaryEntry wordItem;
  final TtsService ttsService;

  const DictionaryDetailDialog({
    super.key,
    required this.wordItem,
    required this.ttsService,
  });

  /// Static helper method to cleanly present this dialog from any screen context
  static void show(BuildContext context, DictionaryEntry item, TtsService tts) {
    showDialog(
      context: context,
      builder: (context) => DictionaryDetailDialog(wordItem: item, ttsService: tts),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      contentPadding: const EdgeInsets.all(16.0),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 1. Dynamic Image Frame Loader from Internal App Storage
          FutureBuilder<Directory>(
            future: getApplicationDocumentsDirectory(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Container(
                  height: 160,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: const Center(child: CircularProgressIndicator(color: Colors.teal)),
                );
              }

              final String imagePath = p.join(snapshot.data!.path, wordItem.imageName);
              final File imageFile = File(imagePath);

              return Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.teal.shade50,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: imageFile.existsSync()
                      ? Image.file(imageFile, fit: BoxFit.cover)
                      : const Icon(Icons.menu_book_rounded, size: 60, color: Colors.teal),
                ),
              );
            },
          ),
          const SizedBox(height: 16),

          // 2. Word Header Token display
          Text(
            wordItem.word,
            style: textTheme.displayMedium?.copyWith(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.teal.shade800,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),

          // 3. Description Segment Content
          Text(
            wordItem.description,
            style: textTheme.bodyMedium?.copyWith(color: Colors.grey[700], height: 1.5),
            textAlign: TextAlign.justify,
          ),
          const SizedBox(height: 20),

          // 4. Core Audio Playback Interaction Action Button
          ElevatedButton.icon(
            icon: const Icon(Icons.volume_up_rounded, size: 22),
            label: const Text('Đọc thành tiếng', style: TextStyle(fontWeight: FontWeight.bold)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 45),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              elevation: 1,
            ),
            onPressed: () {
              // Direct execution command to play back the focused word text string
              ttsService.speak(wordItem.word);
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            ttsService.stop(); // Stops audio playback instantly if the user closes out early
            Navigator.pop(context);
          },
          child: Text('Đóng', style: TextStyle(color: Colors.grey[600], fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}