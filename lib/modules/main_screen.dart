import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:nodyslexia/customwigdets/settings_button.dart';
import 'package:nodyslexia/data/persistence.dart';
import 'package:nodyslexia/data/repository_manager.dart';
import 'package:nodyslexia/modules/practice/unit/unit_selection_screen.dart';
import 'package:nodyslexia/modules/practice/unit/unit_selection_viewmodel.dart';
import 'package:nodyslexia/modules/tools/file_to_text/file_to_text_screen.dart';
import 'package:nodyslexia/modules/library/library_screen.dart';
import 'package:nodyslexia/modules/practice/practice_selection_screen.dart';
import 'package:nodyslexia/modules/practice/practice_selection_viewmodel.dart';
import 'package:nodyslexia/modules/settings/text_settings.dart';
import 'package:nodyslexia/modules/tools/simplifier/simplifier_screen.dart';
import 'package:nodyslexia/modules/tools/simplifier/simplifier_viewmodel.dart';
import 'package:nodyslexia/modules/statistics/statistics_screen.dart';
import 'package:nodyslexia/modules/statistics/statistics_viewmodel.dart';
import 'package:nodyslexia/modules/test/test_selection_screen.dart';
import 'package:nodyslexia/modules/test/test_selection_viewmodel.dart';
import 'package:nodyslexia/modules/tools/tools_navigation_screen.dart';
import 'package:nodyslexia/utils/simplifier_service.dart';
import 'package:nodyslexia/utils/tts_service.dart';
import 'package:nodyslexia/utils/usage_time_tracker.dart';
import 'package:provider/provider.dart';

import '../customwigdets/return_button.dart';
import '../device_size.dart';
import '../utils/ocr_service.dart';
import 'tools/file_to_text/file_to_text_viewmodel.dart';
import 'library/library_viewmodel.dart';
import 'login/login_screen.dart';
import 'login/login_viewmodel.dart';

// ───────────────────────────── Screen ─────────────────────────────

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final _secureStorage = const FlutterSecureStorage();
  String? _token;

  @override
  void initState() {
    super.initState();
    _loadToken();
    WidgetsBinding.instance.addPostFrameCallback((_) => _maybeShowSessionDialog());
  }

  Future<void> _loadToken() async {
    _token = await _secureStorage.read(key: "jwt_token");
  }

  // ── Session dialog ──

  Future<void> _maybeShowSessionDialog() async {
    if (!mounted) return;
    final repoManager = context.read<RepoManager>();
    // Only for logged-in students without an active session
    if (repoManager.currentStudent != null && repoManager.currentSession == null) {
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => _SessionInfoDialog(repoManager: repoManager),
      );
    }
  }

  // ── Navigation ──

  void _openScreen<T extends ChangeNotifier>({
    required T Function(BuildContext context) createViewModel,
    required Widget screen,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChangeNotifierProvider<T>(
          create: createViewModel,
          child: screen,
        ),
      ),
    );
  }

  /// Runs [action] only when a student is logged in, otherwise warns about offline mode.
  void _requireOnline(VoidCallback action) {
    if (context.read<RepoManager>().currentStudent == null) {
      _showOfflineWarning();
    } else {
      action();
    }
  }

  void _openPractice() => _openScreen(
    createViewModel: (ctx) =>
        UnitSelectionViewModel(repoManager: ctx.read<RepoManager>()),
    screen: const UnitSelectionScreen(),
  );

  void _openTools() => _requireOnline(
      () => Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => ToolsNavigationScreen(token: _token)
            )
      )
  );

  void _openLibrary() => _openScreen(
    createViewModel: (ctx) => LibraryViewModel(
      localDatabase: ctx.read<LocalDatabase>(),
      repoManager: ctx.read<RepoManager>(),
      ttsService: ctx.read<TtsService>(),
    ),
    screen: const LibraryScreen(),
  );

  void _openStatistics() => _requireOnline(
        () => _openScreen(
      createViewModel: (ctx) => StatisticsViewmodel(
        repoManager: ctx.read<RepoManager>(),
        usageTimeTracker: ctx.read<UsageTimeTracker>(),
      ),
      screen: const StatisticsScreen(),
    ),
  );

  // ── Dialogs ──

  void _showOfflineWarning() {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Chế độ ngoại tuyến'),
        content: const Text(
          'Tính năng này chỉ khả dụng khi đăng nhập tài khoản trực tuyến.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Đóng'),
          ),
        ],
      ),
    );
  }

  Future<void> _logOut() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Đăng xuất?'),
        content: const Text(
          'Bạn có chắc chắn muốn đăng xuất không? Bạn sẽ phải đăng nhập lại.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Huỷ', style: TextStyle(color: Colors.black87)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Đăng xuất'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await _signOutAndOpenLogin();
    }
  }

  Future<void> _signOutAndOpenLogin() async {
    final repoManager = context.read<RepoManager>();
    final usageTimeTracker = context.read<UsageTimeTracker>();
    final textSettings = context.read<NokodoSettings>();
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);

    // Non-dismissible loader
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      await usageTimeTracker.resetTracker();
      await repoManager.signOut();
    } catch (e) {
      navigator.pop(); // close loader
      messenger.showSnackBar(SnackBar(content: Text('Lỗi: $e')));
      return;
    }

    // Clears the whole stack, including the loader
    navigator.pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) => ChangeNotifierProvider(
          create: (_) => LoginViewModel(
            repoManager: repoManager,
            textSettings: textSettings,
            usageTimeTracker: usageTimeTracker,
          ),
          child: const LoginScreen(),
        ),
      ),
          (route) => false,
    );
  }

  // ── Build ──

  @override
  Widget build(BuildContext context) {
    final screenSize = getSize(context);
    final isSingleColumn =
        screenSize == ScreenSize.Compact || screenSize == ScreenSize.Medium;
    final textTheme = Theme.of(context).textTheme;

    final menuItems = <_MenuItem>[
      _MenuItem(icon: Icons.camera_outlined, label: 'CÔNG CỤ', onPressed: _openTools),
      _MenuItem(icon: Icons.bar_chart_outlined, label: 'THƯ VIỆN', onPressed: _openLibrary),
    ];

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _logOut();
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 20.0),
                child: Text('Nokodo', style: textTheme.titleLarge),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: SingleChildScrollView(
                    child: Column (
                      children: [
                        _BigButton(item: _MenuItem(icon: Icons.play_circle_outline, label: 'LUYỆN TẬP', onPressed: _openPractice)),
                        _MenuGrid(items: menuItems, singleColumn: isSingleColumn),
                        _SmallButton(item: _MenuItem(icon: Icons.help_outline, label: 'THEO DÕI TIẾN ĐỘ', onPressed: _openStatistics))
                      ],
                    ),
                  ),
                ),
              ),
              _BottomBar(
                showGreeting: screenSize != ScreenSize.Compact,
                onLogOut: _logOut,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ───────────────────────────── Menu ─────────────────────────────

class _MenuItem {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const _MenuItem({
    required this.icon,
    required this.label,
    required this.onPressed,
  });
}

/// One column on small screens, rows of two on large screens.
class _MenuGrid extends StatelessWidget {
  final List<_MenuItem> items;
  final bool singleColumn;

  const _MenuGrid({required this.items, required this.singleColumn});

  @override
  Widget build(BuildContext context) {
    const gap = SizedBox(height: 10);

    if (singleColumn) {
      return Column(
        children: [
          for (int i = 0; i < items.length; i++) ...[
            if (i > 0) gap,
            _MenuButton(item: items[i], expand: false),
          ],
        ],
      );
    }

    final rows = <Widget>[];
    for (int i = 0; i < items.length; i += 2) {
      final rowItems = items.skip(i).take(2).toList();
      rows.add(
        Row(
          children: [
            for (final item in rowItems) _MenuButton(item: item, expand: true),
            if (rowItems.length == 1) const Expanded(child: SizedBox()),
          ],
        ),
      );
    }

    return Column(
      children: [
        for (int i = 0; i < rows.length; i++) ...[
          if (i > 0) gap,
          rows[i],
        ],
      ],
    );
  }
}

class _MenuButton extends StatelessWidget {
  final _MenuItem item;
  final bool expand;

  const _MenuButton({required this.item, required this.expand});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final button = Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton.icon(
        icon: Icon(item.icon, size: 42),
        label: Padding(
          padding: const EdgeInsets.symmetric(vertical: 36.0, horizontal: 20.0),
          child: Text(
            item.label,
            style: textTheme.displayMedium,
            textAlign: TextAlign.center,
          ),
        ),
        onPressed: item.onPressed,
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.black,
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: Colors.teal, width: 8),
          ),
          elevation: 3,
        ),
      ),
    );

    return expand
        ? Expanded(child: button)
        : SizedBox(width: double.infinity, child: button);
  }
}

class _BigButton extends StatelessWidget {
  final _MenuItem item;

  const _BigButton({required this.item});
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SizedBox (
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton.icon(
          icon: Icon(item.icon, size: 42),
          label: Padding(
            padding: const EdgeInsets.symmetric(vertical: 42.0, horizontal: 20.0),
            child: Text(
              item.label,
              style: textTheme.displayMedium,
              textAlign: TextAlign.center,
            ),
          ),
          onPressed: item.onPressed,
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.black,
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: Colors.teal, width: 8),
            ),
            elevation: 3,
          ),
        ),
      )
    );
  }
}

class _SmallButton extends StatelessWidget {
  final _MenuItem item;

  const _SmallButton({required this.item});
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      children: <Widget>[
        const Spacer(flex: 1),
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton.icon(
              icon: Icon(item.icon, size: 42),
              label: Padding(
                padding: const EdgeInsets.symmetric(vertical: 42.0, horizontal: 20.0),
                child: Text(
                  item.label,
                  style: textTheme.displayMedium,
                  textAlign: TextAlign.center,
                ),
              ),
              onPressed: item.onPressed,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: Colors.teal, width: 8),
                ),
                elevation: 3,
              ),
            ),
          ), // 2 / (1 + 2 + 1) = 1/2 of the row width
        ),
        const Spacer(flex: 1),
      ],
    );
  }
}

// ───────────────────────────── Bottom bar ─────────────────────────────

class _BottomBar extends StatelessWidget {
  final bool showGreeting;
  final VoidCallback onLogOut;

  const _BottomBar({required this.showGreeting, required this.onLogOut});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final username = context.watch<RepoManager>().currentStudent?.firstname;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 24.0),
      child: Row(
        children: <Widget>[
          ReturnButton(onReturn: (_) => onLogOut()),
          const Spacer(),
          if (showGreeting)
            Text(
              username != null ? "Xin chào $username" : "Sử dụng ngoại tuyến",
              style: textTheme.bodyMedium,
            ),
          const SizedBox(width: 10),
          SettingButton(),
        ],
      ),
    );
  }
}

// ───────────────────────────── Session dialog ─────────────────────────────

String _two(int n) => n.toString().padLeft(2, '0');

class _SessionInfoDialog extends StatefulWidget {
  final RepoManager repoManager;

  const _SessionInfoDialog({required this.repoManager});

  @override
  State<_SessionInfoDialog> createState() => _SessionInfoDialogState();
}

class _SessionInfoDialogState extends State<_SessionInfoDialog> {
  final _examinerController = TextEditingController();
  final _siteController = TextEditingController();

  late final String _sid;
  late final String _sessionId;
  late final String _startTime;

  @override
  void initState() {
    super.initState();
    final student = widget.repoManager.currentStudent!;
    final now = DateTime.now();

    _sid = student.sid.toString();
    _sessionId =
    "${student.getFormattedSid()}_${now.year}${_two(now.month)}${_two(now.day)}"
        "${_two(now.hour)}${_two(now.minute)}${_two(now.second)}";
    _startTime =
    "${now.year}-${_two(now.month)}-${_two(now.day)} "
        "${_two(now.hour)}:${_two(now.minute)}:${_two(now.second)}";
  }

  @override
  void dispose() {
    _examinerController.dispose();
    _siteController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final size = MediaQuery.sizeOf(context);
    await widget.repoManager.createSession(
      examinerId: _examinerController.text,
      siteId: _siteController.text,
      screenWidth: size.width,
      screenHeight: size.height,
    );
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return AlertDialog(
      title: Text("Thông tin phiên can thiệp", style: textTheme.displayMedium),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Mã học sinh: $_sid",
              style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text("Mã phiên: $_sessionId", style: textTheme.bodyMedium),
            const SizedBox(height: 8),
            Text("Thời gian bắt đầu: $_startTime", style: textTheme.bodyMedium),
            const SizedBox(height: 16),
            _field(textTheme, _examinerController, "Mã người kiểm tra (examinerId)"),
            const SizedBox(height: 12),
            _field(textTheme, _siteController, "Mã địa điểm (siteId)"),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text("Bỏ qua", style: TextStyle(color: Colors.black87)),
        ),
        TextButton(
          onPressed: _save,
          child: const Text("Lưu thông tin phiên"),
        ),
      ],
    );
  }

  Widget _field(TextTheme textTheme, TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      style: textTheme.bodyMedium,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: textTheme.bodySmall,
        border: const OutlineInputBorder(),
      ),
    );
  }
}