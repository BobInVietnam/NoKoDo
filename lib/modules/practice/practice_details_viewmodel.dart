import 'package:flutter/material.dart';
import 'package:nodyslexia/models/lesson.dart';
import 'package:nodyslexia/modules/reading/reading_screen.dart';
import 'package:nodyslexia/modules/reading/reading_viewmodel.dart';
import 'package:nodyslexia/utils/tts_service.dart';
import 'package:nodyslexia/data/persistence.dart';
import 'package:provider/provider.dart';

class PracticeDetailsViewModel extends ChangeNotifier {
  final Lesson lesson;

  PracticeDetailsViewModel({required this.lesson});

  void startLesson(BuildContext context) {
    if (lesson.type == 0) {
      final String textContent = lesson.content['text'] ?? '';

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (innerContext) => ChangeNotifierProvider(
            create: (providerContext) => ReadingViewModel(
              text: textContent,
              ttsService: TtsService(),
              localDatabase: providerContext.read<LocalDatabase>(),
            ),
            child: ReadingScreen(),
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Bài tập tìm kiếm hình ảnh sẽ được phát triển sau.'),
        ),
      );
    }
  }
}
