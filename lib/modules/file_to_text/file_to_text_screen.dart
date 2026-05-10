
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:nodyslexia/customwigdets/return_button.dart';
import 'package:nodyslexia/customwigdets/settings_button.dart';
import 'package:nodyslexia/modules/reading_screen.dart';

// Import your ViewModel
import 'package:nodyslexia/modules/file_to_text/file_to_text_viewmodel.dart';

class FileToTextScreen extends StatelessWidget {
  const FileToTextScreen({super.key});

  // Helper method to handle button taps and navigation cleanly
  Future<void> _handleImageAction(BuildContext context, int sourceIndex) async {
    final viewModel = context.read<FileToTextViewModel>();
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);

    // Call the ViewModel logic
    final String? result = await viewModel.processImageFromSource(sourceIndex);

    // If context is still valid and we got a result, navigate to the next screen
    if (context.mounted && result != null) {
      navigator.push(
        MaterialPageRoute(
          builder: (context) => TextResultScreen(extractedText: result),
        ),
      );
    } else if (context.mounted && result == null && !viewModel.isLoading) {
      // Optional: Show an error or cancellation message
      // scaffoldMessenger.showSnackBar(const SnackBar(content: Text('Không thể xử lý ảnh.')));
    }
  }

  // Action Button Builder remains mostly the same, just streamlined
  Widget _buildActionButton({required IconData icon, required String label, required VoidCallback onPressed}) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: AspectRatio(
          aspectRatio: 1 / 1,
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal[600],
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.all(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(icon, size: 40),
                const SizedBox(height: 8),
                Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 14)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final titleStyle = GoogleFonts.galindo(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.teal[700]);
    final subtitleStyle = GoogleFonts.poppins(fontSize: 16, color: Colors.grey[700]);
    final historyTitleStyle = GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.teal[700]);

    // Watch the ViewModel for UI updates (like loading states or history changes)
    final viewModel = context.watch<FileToTextViewModel>();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 30.0, bottom: 8.0),
              child: Text('Chuyển file sang văn bản', style: titleStyle, textAlign: TextAlign.center),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
              child: Text('Hãy chọn phương thức nhập ảnh hoặc tài liệu PDF', style: subtitleStyle, textAlign: TextAlign.center),
            ),
            const SizedBox(height: 30),

            // Action Buttons
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: viewModel.isLoading
                    ? const Center(child: CircularProgressIndicator()) // Show loading state
                    : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _buildActionButton(
                      icon: Icons.camera_alt_outlined,
                      label: 'Chụp ảnh',
                      onPressed: () => _handleImageAction(context, 0), // 0 for Camera
                    ),
                    _buildActionButton(
                      icon: Icons.folder_open_outlined,
                      label: 'Nhập từ máy',
                      onPressed: () => _handleImageAction(context, 1), // 1 for Gallery
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),

            // History Board Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('Lịch sử', style: historyTitleStyle),
              ),
            ),
            const SizedBox(height: 10),

            // History Board (Now dynamic based on ViewModel state)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: viewModel.history.isEmpty
                      ? const Center(
                    child: Text('Lịch sử chuyển đổi sẽ xuất hiện ở đây.', style: TextStyle(color: Colors.grey, fontSize: 16), textAlign: TextAlign.center),
                  )
                      : ListView.builder(
                    itemCount: viewModel.history.length,
                    itemBuilder: (context, index) {
                      final item = viewModel.history[index];
                      return ListTile(
                        leading: const Icon(Icons.description),
                        title: Text(item.fileName),
                        subtitle: Text(item.extractedText, maxLines: 1, overflow: TextOverflow.ellipsis),
                        onTap: () {
                          // Re-open a past result
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => TextResultScreen(extractedText: item.extractedText)),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Bottom Navigation Bar
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const <Widget>[
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