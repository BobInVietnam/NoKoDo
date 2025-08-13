import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nodyslexia/customwigdets/settings_button.dart';

import 'package:nodyslexia/modules/practice/practice_selection_screen.dart';
import 'package:nodyslexia/modules/file_to_text_screen.dart';
import 'package:nodyslexia/modules/test/test_selection_screen.dart';
import 'package:nodyslexia/modules/library_screen.dart';
import 'package:nodyslexia/modules/statistics_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // Helper function to create styled buttons
  Widget _buildMenuButton({
    required IconData icon,
    required String label,
    VoidCallback? onPressed,
  }) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton.icon(
          icon: Icon(icon, size: 28),
          label: Padding(
            padding: const EdgeInsets.symmetric(vertical: 36.0, horizontal: 20.0), // Add padding to make button taller
            child: Text(label, textAlign: TextAlign.center),
          ),
          onPressed: onPressed ?? () {
            // Placeholder action
            print('$label button pressed');
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.black,
            backgroundColor: Colors.teal[5],
            textStyle: const TextStyle(fontSize: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(
                color: Colors.teal,
                width: 8,
              )
            ),
            elevation: 3,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // No AppBar here
      body: SafeArea( // Ensures content is not obscured by system UI (like notches)
        child: Column(
          children: <Widget>[
            // App Title
            Padding(
              padding: const EdgeInsets.only(top: 40.0, bottom: 30.0), // Added more top padding
              child: Text(
                'Nokodo',
                style: GoogleFonts.galindo( // Using Galindo font
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal[700],
                ),
              ),
            ),

            // Buttons Area
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center, // Center the buttons column vertically
                  children: <Widget>[
                    // Row 1 (1 button)
                    Row(
                      children: <Widget>[
                        _buildMenuButton(
                          icon: Icons.play_circle_outline, // Placeholder
                          label: 'Luyện Tập',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const PracticeSelectionScreen()),
                            );
                          }
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Row 2 (2 buttons)
                    Row(
                      children: <Widget>[
                        _buildMenuButton(
                          icon: Icons.book_outlined, // Placeholder
                          label: 'Làm Bài Kiểm Tra',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const TestSelectionScreen()),
                            );
                          },
                        ),
                        _buildMenuButton(
                          icon: Icons.bar_chart_outlined, // Placeholder
                          label: 'Thư Viện',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const LibraryScreen()),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Row 3 (2 buttons)
                    Row(
                      children: <Widget>[
                        _buildMenuButton(
                          icon: Icons.settings_outlined, // Placeholder
                          label: 'Chuyển File Sang Văn Bản',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const FileToTextScreen()),
                            );
                          },
                        ),
                        _buildMenuButton(
                          icon: Icons.help_outline, // Placeholder
                          label: 'Theo Dõi Tiến Độ',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const StatisticsScreen()),
                            );
                          },
                        ),
                      ],
                    ),
                    const Spacer(), // Pushes content above it up slightly if there's extra space
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  SettingButton()
                ],
              )
            )
          ],
        ),
      ),
    );
  }
}
