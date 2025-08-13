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
    // Using Poppins as an example, adjust if you have a global theme
    final TextStyle? lessonTitleStyle = GoogleFonts.poppins(
      fontSize: 36,
      fontWeight: FontWeight.w600,
      color: Colors.teal[700],
    );

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            // Expanded widget to push the content to the center and bottom
            Expanded(
              child: Center(
                child: Text(
                  'Bài kiểm tra',
                  style: lessonTitleStyle,
                ),
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
