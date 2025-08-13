import 'package:flutter/material.dart';
import 'package:nodyslexia/customwigdets/return_button.dart';
import 'package:nodyslexia/customwigdets/settings_button.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _buildPlaceholderSection(String title, String message, IconData icon) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(icon, size: 80, color: colorScheme.onSurface.withValues(alpha: 0.5)),
            const SizedBox(height: 20),
            Text(
              title,
              style: textTheme.displayLarge, // Using theme's titleLarge
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              message,
              style: textTheme.bodyMedium?.copyWith( // Using theme's bodyMedium
                color: colorScheme.onSurface.withValues(alpha: 0.5),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    // final colorScheme = Theme.of(context).colorScheme;

    // Define TabBar styles using Theme for better adaptability
    // final effectiveLabelColor = tabBarTheme.labelColor ?? colorScheme.primary;
    // final effectiveUnselectedLabelColor = tabBarTheme.unselectedLabelColor ?? colorScheme.onSurface.withOpacity(0.7);
    // final effectiveIndicatorColor = tabBarTheme.indicatorColor ?? colorScheme.primary;
    // final effectiveLabelStyle = tabBarTheme.labelStyle ?? textTheme.labelLarge;
    // final effectiveUnselectedLabelStyle = tabBarTheme.unselectedLabelStyle ?? textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w500);


    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            // Screen Title
            Padding(
              padding: const EdgeInsets.only(top: 30.0, bottom: 16.0),
              child: Text(
                'Thư viện',
                style: textTheme.displayLarge, // Using theme's displayLarge
              ),
            ),

            // Tab Bar
            TabBar(
              controller: _tabController,
              // indicatorColor: effectiveIndicatorColor,
              // labelColor: effectiveLabelColor,
              // unselectedLabelColor: effectiveUnselectedLabelColor,
              // labelStyle: effectiveLabelStyle,
              // unselectedLabelStyle: effectiveUnselectedLabelStyle,
              tabs: const [
                Tab(text: 'Văn bản'),
                Tab(text: 'Từ nổi bật'),
                Tab(text: 'Từ điển'),
              ],
            ),

            // Tab Bar View
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: <Widget>[
                  _buildPlaceholderSection(
                    'Lịch sử Văn bản',
                    'Các văn bản được chuyển đổi từ file sẽ được lưu tại đây.',
                    Icons.history_edu_outlined,
                  ),
                  _buildPlaceholderSection(
                    'Từ Đã Đánh Dấu',
                    'Danh sách các từ bạn đã đánh dấu sẽ xuất hiện ở đây.',
                    Icons.bookmark_border_outlined,
                  ),
                  _buildPlaceholderSection(
                    'Từ điển Tiếng Việt',
                    'Tra cứu và tìm hiểu nghĩa của từ tại đây. (Chức năng đang phát triển)',
                    Icons.menu_book_outlined,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // Bottom Navigation Bar
            Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: 16.0, horizontal: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const <Widget>[
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
