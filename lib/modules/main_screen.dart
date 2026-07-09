import 'package:flutter/material.dart';
import 'package:nodyslexia/customwigdets/settings_button.dart';
import 'package:nodyslexia/data/persistence.dart';

import 'package:nodyslexia/modules/practice/practice_selection_screen.dart';
import 'package:nodyslexia/modules/file_to_text/file_to_text_screen.dart';
import 'package:nodyslexia/modules/statistics/statistics_viewmodel.dart';
import 'package:nodyslexia/modules/test/test_selection_screen.dart';
import 'package:nodyslexia/modules/library/library_screen.dart';
import 'package:nodyslexia/modules/statistics/statistics_screen.dart';
import 'package:nodyslexia/data/repository_manager.dart';
import 'package:provider/provider.dart';

import 'package:nodyslexia/modules/simplifier/simplifier_screen.dart';
import 'package:nodyslexia/modules/simplifier/simplifier_viewmodel.dart';
import 'package:nodyslexia/utils/simplifier_service.dart';
import '../utils/ocr_service.dart';
import 'file_to_text/file_to_text_viewmodel.dart';
import 'library/library_viewmodel.dart';

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
    final textTheme = Theme.of(context).textTheme;

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton.icon(
          icon: Icon(icon, size: 36),
          label: Padding(
            padding: const EdgeInsets.symmetric(vertical: 36.0, horizontal: 20.0), // Add padding to make button taller
            child: Text(label,
                style: textTheme.displayMedium,
                textAlign: TextAlign.center),
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
    final textTheme = Theme.of(context).textTheme;
    final username = context.watch<RepoManager>().currentStudent?.firstname;
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
                style: textTheme.titleLarge
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
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Row 2 (2 buttons)a
                    Row(
                      children: <Widget>[
                        _buildMenuButton(
                          icon: Icons.abc_outlined, // Placeholder
                          label: 'Đơn giản hóa câu từ',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChangeNotifierProvider<SimplifierViewModel>(
                                  create: (innerContext) => SimplifierViewModel(
                                    simplifierService: LocalSimplifierService(),
                                  ),
                                  child: const SimplifierScreen(),
                                ),
                              ),
                            );
                          },
                        ),
                        _buildMenuButton(
                          icon: Icons.bar_chart_outlined, // Placeholder
                          label: 'Thư Viện',
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChangeNotifierProvider<LibraryViewModel>(
                                  create: (innerContext) => LibraryViewModel(
                                    localDatabase: innerContext.read<LocalDatabase>(),
                                  ),
                                  child: const LibraryScreen(),
                                ),
                              ),
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
                                MaterialPageRoute(builder: (context) => ChangeNotifierProvider(
                                  create: (context) => FileToTextViewModel(
                                      ocrService: LocalOCRService(),
                                      localDatabase: context.read<LocalDatabase>()
                                  ),
                                  child: const FileToTextScreen(),
                                )
                                )
                            );
                          },
                        ),
                        _buildMenuButton(
                          icon: Icons.help_outline, // Placeholder
                          label: 'Theo Dõi Tiến Độ',
                          onPressed: () {
                            Navigator.push(
                              context,
                                MaterialPageRoute(builder: (context) => ChangeNotifierProvider(
                                  create: (context) => StatisticsViewmodel(
                                      repoManager: context.read<RepoManager>()
                                  )..gatherStatisticData(),
                                  child: const StatisticsScreen(),
                                )
                                )
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
                  ElevatedButton(
                    onPressed: () {
                      _logOut(); // Go back to the previous screen
                    },
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(12),
                      backgroundColor: Colors.grey[300],
                      foregroundColor: Colors.black54,
                    ),
                    child: const Icon(Icons.arrow_back, size: 28),
                  ),
                  Expanded(child: Container()),
                  Text(username != null? "Xin chào $username" : "",
                  style: textTheme.bodyMedium),
                  SizedBox(width: 10),
                  SettingButton()
                ],
              )
            )
          ],
        ),
      ),
    );
  }

  void _logOut() {
    showDialog(
      context: context,
      builder: (confirmContext) => AlertDialog( // Rename context to avoid confusion
        title: const Text('Đăng xuất?'),
        content: const Text('Bạn có chắc chắn muốn đăng xuất không? Bạn sẽ phải đăng nhập lại.'),
        actions: [
          TextButton(
            // Just close the confirmation dialog
            onPressed: () => Navigator.pop(confirmContext),
            child: const Text('Huỷ'),
          ),
          TextButton(
            onPressed: () async {
              // A. Close the "Are you sure?" dialog first
              Navigator.pop(confirmContext);

              // B. Show a non-dismissible Loading Dialog
              showDialog(
                context: context,
                barrierDismissible: false, // Prevents clicking outside to close
                builder: (loadingContext) => const Center(
                  child: CircularProgressIndicator(), // Or a custom loading widget
                ),
              );

              try {
                final currentRepoManager = context.read<RepoManager>();
                currentRepoManager.signOut();
                if (context.mounted) {
                  Navigator.pop(context);
                }
                if (context.mounted) {
                  Navigator.pop(context);
                }
              } catch (e) {
                // Handle error: Close loader and show error
                if (context.mounted) {
                  Navigator.pop(context); // Close loader
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Lỗi: $e')),
                  );
                }
              }
            },
            child: const Text('Đăng xuất'),
          ),
        ],
      ),
    );
  }
}
