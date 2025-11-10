import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nodyslexia/customwigdets/return_button.dart';
import 'package:nodyslexia/customwigdets/settings_button.dart'; // Optional, for consistent font
// import 'settings_screen.dart'; // Uncomment if you have a SettingsScreen

class TestDetailScreen extends StatelessWidget {
  final int? testId; // Optional: To know which Test this is for

  const TestDetailScreen({super.key, this.testId});

  @override
  Widget build(BuildContext context) {
    // Using Poppins as an example, adjust if you have a global theme
    final TextStyle? TestTitleStyle = GoogleFonts.poppins(
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
                  style: TestTitleStyle,
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
