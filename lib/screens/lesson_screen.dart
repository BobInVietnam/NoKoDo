import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Optional, for consistent font
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
                  'Bài tập',
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
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Go back to the previous screen
                    },
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(12),
                      backgroundColor: Colors.grey[300],
                      foregroundColor: Colors.black54,
                    ),
                    child: const Icon(Icons.arrow_back, size: 28),
                  ),

                  // Settings Button
                  ElevatedButton(
                    onPressed: () {
                      // TODO: Navigate to Settings Screen if needed from here
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => const SettingsScreen()),
                      // );
                      print('Settings button pressed on Lesson Detail Screen');
                    },
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(12),
                      backgroundColor: Colors.grey[300],
                      foregroundColor: Colors.black54,
                    ),
                    child: const Icon(Icons.settings_outlined, size: 28),
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
