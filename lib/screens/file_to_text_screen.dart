import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nodyslexia/customwigdets/return_button.dart';
import 'package:nodyslexia/customwigdets/settings_button.dart';

import 'reading_screen.dart'; // Optional: if you want consistent font like Galindo
// import 'settings_screen.dart'; // Uncomment if you have a SettingsScreen

class FileToTextScreen extends StatelessWidget {
  const FileToTextScreen({super.key});

  // Helper for the action buttons
  Widget _buildActionButton(
      {required BuildContext context,
        required IconData icon,
        required String label,
        required VoidCallback onPressed}) {
    final Color buttonColor = Colors.teal[600]!;
    final Color iconColor = Colors.white;
    final Color textColor = Colors.white;

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: AspectRatio(
          aspectRatio: 1 / 1, // Makes the button square
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: buttonColor,
              foregroundColor: iconColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(12), // Adjust padding as needed
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(icon, size: 40), // Larger icon size
                const SizedBox(height: 8),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: textColor, fontSize: 14),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Determine text style - using Poppins as a fallback if Galindo isn't set globally
    final TextTheme appTextTheme = Theme.of(context).textTheme;
    final TextStyle? titleStyle = GoogleFonts.galindo( // Consistent with MainScreen title
        fontSize: 28, fontWeight: FontWeight.bold, color: Colors.teal[700]);
    final TextStyle? subtitleStyle = GoogleFonts.poppins(fontSize: 16, color: Colors.grey[700]);
    final TextStyle? historyTitleStyle = GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.teal[700]);


    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            // Top Titles
            Padding(
              padding: const EdgeInsets.only(top: 30.0, bottom: 8.0),
              child: Text(
                'Chuyển file sang văn bản',
                style: titleStyle,
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
              child: Text(
                'Hãy chọn phương thức nhập ảnh hoặc tài liệu PDF',
                style: subtitleStyle,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 30),

            // Action Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _buildActionButton(
                    context: context,
                    icon: Icons.camera_alt_outlined,
                    label: 'Chụp ảnh',
                    onPressed: () {
                      // TODO: Implement camera functionality
                      String ocrResult = """
Chuyện kể rằng: vào đời Hùng Vương thứ 6, ở làng Gióng có hai vợ chồng ông lão chăm làm ăn và có tiếng là phúc đức. Hai ông bà ao ước có một đứa con. Một hôm bà ra đồng trông thấy  một vết chân to quá, liền đặt bàn chân mình lên ướm thử để xem thua kém  bao nhiêu.

Không ngờ về  nhà bà thụ thai và mười hai tháng sau sinh một thằng bé mặt mũi rất khôi ngô. Hai vợ chồng mừng lắm. Nhưng lạ thay! Ðứa trẻ cho đến khi lên ba  vẫn không biết nói, biết cười, cũng chẳng biết đi, cứ đặt đâu thì nằm đấy.
""";
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TextResultScreen(extractedText: ocrResult),
                        ),
                      );
                      print('Chụp ảnh button pressed');
                    },
                  ),
                  _buildActionButton(
                    context: context,
                    icon: Icons.folder_open_outlined,
                    label: 'Nhập từ máy',
                    onPressed: () {
                      // TODO: Implement file picking functionality
                      print('Nhập từ máy button pressed');
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // History Board Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Lịch sử',
                  style: historyTitleStyle,
                ),
              ),
            ),
            const SizedBox(height: 10),

            // History Board (Placeholder)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: const Center(
                    child: Text(
                      'Lịch sử chuyển đổi sẽ xuất hiện ở đây.',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20), // Spacer before bottom bar

            // Bottom Navigation Bar
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  // Return Button
                  ReturnButton(),
                  SettingButton()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
