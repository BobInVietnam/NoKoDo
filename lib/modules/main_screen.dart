import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:nodyslexia/customwigdets/settings_button.dart';
import 'package:nodyslexia/data/persistence.dart';

import 'package:nodyslexia/modules/practice/practice_selection_screen.dart';
import 'package:nodyslexia/modules/practice/practice_selection_viewmodel.dart';
import 'package:nodyslexia/modules/file_to_text/file_to_text_screen.dart';
import 'package:nodyslexia/modules/statistics/statistics_viewmodel.dart';
import 'package:nodyslexia/modules/test/test_selection_screen.dart';
import 'package:nodyslexia/modules/test/test_selection_viewmodel.dart';
import 'package:nodyslexia/modules/library/library_screen.dart';
import 'package:nodyslexia/modules/statistics/statistics_screen.dart';
import 'package:nodyslexia/data/repository_manager.dart';
import 'package:nodyslexia/utils/tts_service.dart';
import 'package:nodyslexia/utils/usage_time_tracker.dart';
import 'package:provider/provider.dart';

import 'package:nodyslexia/modules/simplifier/simplifier_screen.dart';
import 'package:nodyslexia/modules/simplifier/simplifier_viewmodel.dart';
import 'package:nodyslexia/utils/simplifier_service.dart';
import '../customwigdets/return_button.dart';
import '../device_size.dart';
import '../utils/ocr_service.dart';
import 'file_to_text/file_to_text_viewmodel.dart';
import 'library/library_viewmodel.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late String? _token = null;
  final _secureStorage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _getToken();
  }

  Future<void> _getToken() async {
    _token = await _secureStorage.read(key: "jwt_token");
  }

  // Helper function to create styled buttons
  Widget _buildMenuButton({
    required IconData icon,
    required String label,
    VoidCallback? onPressed,
    bool expand = true,
  }) {
    final textTheme = Theme.of(context).textTheme;

    final buttonWidget = Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton.icon(
        icon: Icon(icon, size: 42),
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
          backgroundColor: Colors.white,
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
    );

    if (expand) {
      return Expanded(child: buttonWidget);
    }
    return SizedBox(
      width: double.infinity,
      child: buttonWidget,
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = getSize(context);
    final isSingleColumn = screenSize == ScreenSize.Compact || screenSize == ScreenSize.Medium;
    debugPrint("SCREENSIZE: main_screen screen size: $screenSize (single column: $isSingleColumn)");

    final textTheme = Theme.of(context).textTheme;
    final username = context.watch<RepoManager>().currentStudent?.firstname;

    final practiceBtnAction = () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider(
            create: (innerContext) => PracticeSelectionViewModel(
              repoManager: innerContext.read<RepoManager>(),
            ),
            child: const PracticeSelectionScreen(),
          ),
        ),
      );
    };

    final testBtnAction = () {
      if (context.read<RepoManager>().currentStudent == null) {
        _showOfflineWarning(context);
        return;
      }
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (innerContext) => ChangeNotifierProvider(
            create: (providerContext) => TestSelectionViewModel(
              repoManager: providerContext.read<RepoManager>(),
            ),
            child: const TestSelectionScreen(),
          ),
        ),
      );
    };

    final simplifierBtnAction = () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider<SimplifierViewModel>(
            create: (innerContext) => SimplifierViewModel(
              simplifierService: LocalSimplifierService(token: _token),
            ),
            child: const SimplifierScreen(),
          ),
        ),
      );
    };

    final libraryBtnAction = () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider<LibraryViewModel>(
            create: (innerContext) => LibraryViewModel(
              localDatabase: innerContext.read<LocalDatabase>(),
              repoManager: innerContext.read<RepoManager>(),
              ttsService: innerContext.read<TtsService>()
            ),
            child: const LibraryScreen(),
          ),
        ),
      );
    };

    final ocrBtnAction = () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ChangeNotifierProvider(
          create: (context) => FileToTextViewModel(
              ocrService: LocalOCRService(token: _token),
              localDatabase: context.read<LocalDatabase>()
          ),
          child: const FileToTextScreen(),
        ))
      );
    };

    final statsBtnAction = () {
      if (context.read<RepoManager>().currentStudent == null) {
        _showOfflineWarning(context);
        return;
      }
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ChangeNotifierProvider(
          create: (context) => StatisticsViewmodel(
              repoManager: context.read<RepoManager>(),
              usageTimeTracker: context.read<UsageTimeTracker>()
          ),
          child: const StatisticsScreen(),
        ))
      );
    };

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _logOut();
      },
      child: Scaffold(
        // No AppBar here
        body: SafeArea( // Ensures content is not obscured by system UI (like notches)
          child: Column(
            children: <Widget>[
              // App Title
              Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 20.0), // Added more top padding
                child: Text(
                    'Nokodo',
                    style: textTheme.titleLarge
                ),
              ),

              // Buttons Area
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: isSingleColumn
                      ? SingleChildScrollView(
                          child: Column(
                            children: <Widget>[
                              _buildMenuButton(
                                icon: Icons.play_circle_outline,
                                label: 'LUYỆN TẬP',
                                expand: false,
                                onPressed: practiceBtnAction,
                              ),
                              const SizedBox(height: 10),
                              _buildMenuButton(
                                icon: Icons.book_outlined,
                                label: 'LÀM BÀI KIỂM TRA',
                                expand: false,
                                onPressed: testBtnAction,
                              ),
                              const SizedBox(height: 10),
                              _buildMenuButton(
                                icon: Icons.abc_outlined,
                                label: 'ĐƠN GIẢN HÓA CÂU TỪ',
                                expand: false,
                                onPressed: simplifierBtnAction,
                              ),
                              const SizedBox(height: 10),
                              _buildMenuButton(
                                icon: Icons.bar_chart_outlined,
                                label: 'THƯ VIỆN',
                                expand: false,
                                onPressed: libraryBtnAction,
                              ),
                              const SizedBox(height: 10),
                              _buildMenuButton(
                                icon: Icons.settings_outlined,
                                label: 'CHUYỂN ẢNH SANG VĂN BẢN',
                                expand: false,
                                onPressed: ocrBtnAction,
                              ),
                              const SizedBox(height: 10),
                              _buildMenuButton(
                                icon: Icons.help_outline,
                                label: 'THEO DÕI TIẾN ĐỘ',
                                expand: false,
                                onPressed: statsBtnAction,
                              ),
                            ],
                          ),
                        )
                      : SingleChildScrollView(
                          child: Column(
                            children: <Widget>[
                              // Row 1 (2 buttons)
                              Row(
                                children: <Widget>[
                                  _buildMenuButton(
                                    icon: Icons.play_circle_outline,
                                    label: 'LUYỆN TẬP',
                                    expand: true,
                                    onPressed: practiceBtnAction,
                                  ),
                                  _buildMenuButton(
                                    icon: Icons.book_outlined,
                                    label: 'LÀM BÀI KIỂM TRA',
                                    expand: true,
                                    onPressed: testBtnAction,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),

                              // Row 2 (2 buttons)
                              Row(
                                children: <Widget>[
                                  _buildMenuButton(
                                    icon: Icons.abc_outlined,
                                    label: 'ĐƠN GIẢN HÓA CÂU TỪ',
                                    expand: true,
                                    onPressed: simplifierBtnAction,
                                  ),
                                  _buildMenuButton(
                                    icon: Icons.bar_chart_outlined,
                                    label: 'THƯ VIỆN',
                                    expand: true,
                                    onPressed: libraryBtnAction,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),

                              // Row 3 (2 buttons)
                              Row(
                                children: <Widget>[
                                  _buildMenuButton(
                                    icon: Icons.settings_outlined,
                                    label: 'CHUYỂN ẢNH SANG VĂN BẢN',
                                    expand: true,
                                    onPressed: ocrBtnAction,
                                  ),
                                  _buildMenuButton(
                                    icon: Icons.help_outline,
                                    label: 'THEO DÕI TIẾN ĐỘ',
                                    expand: true,
                                    onPressed: statsBtnAction,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  ReturnButton(
                    onReturn: (context) {
                      _logOut();
                    }
                  ),
                  Expanded(child: Container()),
                  screenSize == ScreenSize.Compact
                    ? Container()
                    : Text(
                      username != null? "Xin chào $username" : "Sử dụng ngoại tuyến",
                      style: textTheme.bodyMedium
                    ),
                  SizedBox(width: 10),
                  SettingButton()
                ],
              )
            )
          ],
        ),
      ),
    )
    );
  }

  void _showOfflineWarning(BuildContext context) {

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Chế độ ngoại tuyến'),
        content: const Text('Tính năng này chỉ khả dụng khi đăng nhập tài khoản trực tuyến.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Đóng'),
          ),
        ],
      ),
    );
  }

  void _logOut() {
    final textTheme = Theme.of(context).textTheme;

    showDialog(
      context: context,
      builder: (confirmContext) => AlertDialog( // Rename context to avoid confusion
        title: const Text('Đăng xuất?'),
        content: const Text('Bạn có chắc chắn muốn đăng xuất không? Bạn sẽ phải đăng nhập lại.'),
        actions: [
          TextButton(
            // Just close the confirmation dialog
            onPressed: () => Navigator.pop(confirmContext),
            child: Text('Huỷ', style: const TextStyle(color: Colors.black87)),
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
                final usageTimeTracker = context.read<UsageTimeTracker>();
                await usageTimeTracker.resetTracker();
                await currentRepoManager.signOut();
              } catch (e) {
                // Handle error: Close loader and show error
                if (mounted) {
                  Navigator.pop(context); // Close loader
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Lỗi: $e')),
                  );
                }
              }
              finally {
                if (mounted) {
                  Navigator.pop(context);
                  Navigator.pop(context);
                }
              }
            },
            child: Text('Đăng xuất'),
          ),
        ],
      ),
    );
  }
}
