// screens/library_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:nodyslexia/customwigdets/return_button.dart';
import 'package:nodyslexia/customwigdets/settings_button.dart';
import 'package:nodyslexia/models/converted_file.dart';
import 'package:nodyslexia/data/persistence.dart';

// Import target route bindings
import 'package:nodyslexia/modules/library/library_viewmodel.dart';
import 'package:nodyslexia/modules/editing/editing_screen.dart';
import 'package:nodyslexia/modules/editing/editing_viewmodel.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> with SingleTickerProviderStateMixin {
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

  // Generic Placeholder Section UI Component (unchanged)
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
            Text(title, style: textTheme.displayLarge, textAlign: TextAlign.center),
            const SizedBox(height: 10),
            Text(
              message,
              style: textTheme.bodyMedium?.copyWith(color: colorScheme.onSurface.withValues(alpha: 0.5)),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // --- Dynamic Tab 1 Component Layout: Text History Builder ---
  Widget _buildHistorySection(LibraryViewModel viewModel, TextTheme textTheme) {
    if (viewModel.isLoading) {
      return const Center(child: CircularProgressIndicator(color: Colors.teal));
    }

    if (viewModel.isLibraryEmpty) {
      return _buildPlaceholderSection(
        'Lịch sử Văn bản',
        'Các văn bản được chuyển đổi từ file sẽ được lưu tại đây.',
        Icons.history_edu_outlined,
      );
    }

    return RefreshIndicator(
      onRefresh: viewModel.loadSavedFiles,
      color: Colors.teal,
      child: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: viewModel.savedFiles.length,
        itemBuilder: (context, index) {
          final ConvertedFile fileItem = viewModel.savedFiles[index];

          final String formattedDate = _formatDateNative(fileItem.dateConverted);

          return Container(
            margin: const EdgeInsets.only(bottom: 14.0),
            padding: const EdgeInsets.all(14.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              border: Border.all(color: Colors.grey.shade300),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.08),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title and Meta Row Info
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        fileItem.fileName,
                        style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold, fontSize: 20),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      formattedDate,
                      style: textTheme.bodySmall?.copyWith(color: Colors.grey[500]),
                    ),
                  ],
                ),
                const Divider(height: 16),

                // Extracted snippet display frame
                Text(
                  fileItem.extractedText,
                  style: textTheme.bodyMedium?.copyWith(color: Colors.grey[600], height: 1.4),
                  maxLines: 2, // Cutoff preview text safely at two lines
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),

                // Item Actions Row Box
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Delete Button Action
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                      tooltip: 'Xóa tập tin',
                      onPressed: () => _confirmDeletionDialog(context, viewModel, fileItem),
                    ),
                    const SizedBox(width: 8),

                    // Edit Navigation Action Button
                    ElevatedButton.icon(
                      icon: const Icon(Icons.edit_outlined, size: 16),
                      label: const Text('Chỉnh sửa'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      ),
                      onPressed: () async {
                        // Route to EditingScreen passing this element's ConvertedFile payload
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (routeContext) => ChangeNotifierProvider<EditingViewModel>(
                              create: (providerContext) => EditingViewModel(
                                file: fileItem,
                                localDatabase: providerContext.read<LocalDatabase>(),
                              ),
                              child: const EditingScreen(),
                            ),
                          ),
                        );
                        // Reload the history listings after returning to pick up any text/name edits
                        viewModel.loadSavedFiles();
                      },
                    ),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }

  // Safety Confirmation Alert Panel before clearing items out of database records
  void _confirmDeletionDialog(BuildContext context, LibraryViewModel viewModel, ConvertedFile file) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận xóa', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Text('Bạn có chắc chắn muốn xóa vĩnh viễn tập tin "${file.fileName}" không? Hành động này không thể hoàn tác.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Hủy', style: TextStyle(color: Colors.grey[600])),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () {
              viewModel.deleteFile(file.id!);
              Navigator.pop(context);
            },
            child: const Text('Xóa', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  String _formatDateNative(DateTime? date) {
    if (date == null) return 'Không rõ thời gian';

    // Pad single digits with a leading zero (e.g., '9' becomes '09')
    String pad(int value) => value.toString().padLeft(2, '0');

    final String hour = pad(date.hour);
    final String minute = pad(date.minute);
    final String day = pad(date.day);
    final String month = pad(date.month);
    final String year = date.year.toString();

    // Returns the formatted layout matching your exact pattern requirement
    return "$hour:$minute - $day/$month/$year";
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final viewModel = context.watch<LibraryViewModel>();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            // Screen Title
            Padding(
              padding: const EdgeInsets.only(top: 20.0, bottom: 12.0),
              child: Text('Thư viện', style: textTheme.displayLarge),
            ),

            // Tab Navigation Headers
            TabBar(
              controller: _tabController,
              indicatorColor: Colors.teal,
              labelColor: Colors.teal,
              unselectedLabelColor: Colors.grey[600],
              tabs: const [
                Tab(text: 'Văn bản'),
                Tab(text: 'Từ nổi bật'),
                Tab(text: 'Từ điển'),
              ],
            ),

            // Tab Sub-window Rendering Areas
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: <Widget>[
                  _buildHistorySection(viewModel, textTheme), // Inject live text history module builder
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

            // Bottom Control Action Row Panel
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
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