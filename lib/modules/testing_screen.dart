import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:nodyslexia/data/persistence.dart';
import 'package:nodyslexia/modules/reading/reading_screen.dart';
import 'package:nodyslexia/modules/reading/reading_viewmodel.dart';
import 'package:nodyslexia/utils/audio_recorder.dart';
import 'package:nodyslexia/utils/tts_service.dart';
import 'package:provider/provider.dart';

import '../data/remote_database.dart';
import '../data/repository_manager.dart';
import '../models/test.dart';
import 'letter_search/letter_search_screen.dart';
import 'letter_search/letter_search_viewmodel.dart';

class AScreen extends StatelessWidget {
  const AScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => ReadingViewModel(
            text: " If you're looking for random paragraphs, you've come to the right place. When a random word or a random sentence isn't quite enough, the next logical step is to find a random paragraph. We created the Random Paragraph Generator with you in mind. The process is quite simple. Choose the number of random paragraphs you'd like to see and click the button. Your chosen number of paragraphs will instantly appear.While it may not be obvious to everyone, there are a number of reasons creating random paragraphs can be useful. A few examples of how some people use this generator are listed in the following paragraphs. ",
            ttsService: context.read<TtsService>(),
            localDatabase: context.read<LocalDatabase>(),
            lessonName: "abc",
            lessonId: "123",
            audioRecorder: context.read<AudioRecorder>(),
            repoManager: context.read<RepoManager>()
        ),
        child: ReadingScreen()
    );
  }
}