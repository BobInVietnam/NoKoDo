import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nodyslexia/customwigdets/return_button.dart';
import 'package:nodyslexia/customwigdets/settings_button.dart'; // Optional, for consistent font
// import 'settings_screen.dart'; // Uncomment if you have a SettingsScreen

class LessonDetailScreen extends StatelessWidget {
  final String? lessonId; // Optional: To know which lesson this is for

  const LessonDetailScreen({super.key, this.lessonId});

  @override
  Widget build(BuildContext context) {

    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            // Expanded widget to push the content to the center and bottom
            Expanded(
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 48),
                  Text(
                    'Bài tập',
                    style: textTheme.displayLarge,
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 30.0, horizontal: 16.0),
                      margin: EdgeInsets.symmetric(vertical: 30.0),
                      child: Text(
                          "Hãy trả lời những câu hỏi sau nhé!"
                      )
                    )
                  ),
                  ElevatedButton(
                    onPressed: () => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const LessonPracticeScreen())
                      )
                    },
                    child: Text(
                      'Bắt đầu',
                      style: textTheme.displayMedium,
                    )
                  )
                ]
              ),
            ),

            // Bottom Navigation Bar
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  // Return Button
                  ReturnButton(),
                  SettingButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LessonPracticeScreen extends StatefulWidget {
  const LessonPracticeScreen({super.key});

  @override
  State<LessonPracticeScreen> createState() => _LessonPracticeScreenState();
}

class _LessonPracticeScreenState extends State<LessonPracticeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Text(
                "Bài tập ở đây"
              )
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  // Return Button
                  ReturnButton(),
                  SettingButton(),
                ],
              ),
            ),
          ]
        )
      )
    );
  }
  
}