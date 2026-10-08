import 'package:flutter/material.dart';
import 'package:nodyslexia/models/lesson.dart';
import 'package:nodyslexia/modules/reading/reading_screen.dart';
import 'package:nodyslexia/modules/reading/reading_viewmodel.dart';
import 'package:nodyslexia/modules/settings/text_settings.dart';
import 'package:nodyslexia/utils/audio_recorder.dart';
import 'package:nodyslexia/utils/tts_service.dart';
import 'package:nodyslexia/data/persistence.dart';
import 'package:nodyslexia/modules/letter_search/letter_search_screen.dart';
import 'package:nodyslexia/modules/letter_search/letter_search_viewmodel.dart';
import 'package:provider/provider.dart';

import '../../data/repository_manager.dart';

class PracticeDetailsViewModel extends ChangeNotifier {
  final Lesson lesson;

  PracticeDetailsViewModel({required this.lesson});

  Future<void> startLesson(BuildContext context) async {
    if (lesson.type == 0) {
      NokodoSettings settings = context.read<NokodoSettings>();
      RepoManager repoManager = context.read<RepoManager>();

      Map<String, dynamic> customSettings = await repoManager.getCustomSettings(
        lesson.id,
      );
      debugPrint(customSettings.toString());
      await settings.updateFromMap(customSettings);

      final String textContent = lesson.content['text'] ?? '';

      if (context.mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            settings: const RouteSettings(name: 'ReadingScreen'),
            builder:
                (innerContext) => ChangeNotifierProvider(
                  create:
                      (providerContext) => ReadingViewModel(
                        text: textContent,
                        ttsService: providerContext.read<TtsService>(),
                        localDatabase: providerContext.read<LocalDatabase>(),
                        lessonId: lesson.id,
                        lessonName: lesson.name,
                        repoManager: providerContext.read<RepoManager>(),
                        audioRecorder: providerContext.read<AudioRecorder>(),
                      ),
                  child: ReadingScreen(),
                ),
          ),
        );
      }
    } else if (lesson.type == 1) {
      List<Map<String, dynamic>>? customCases;
      if (lesson.content.containsKey('cases')) {
        customCases = List<Map<String, dynamic>>.from(
          lesson.content['cases'] as List,
        );
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (innerContext) => ChangeNotifierProvider(
                create:
                    (providerContext) => LetterSearchViewModel(
                      content: customCases,
                      lessonId: lesson.id,
                      lessonName: lesson.name,
                      repoManager: providerContext.read<RepoManager>(),
                    ),
                child: const LetterSearchScreen(),
              ),
        ),
      );
    }
  }
}
