// screens/library_screen.dart
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nodyslexia/modules/reading/editable_reading_screen.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import 'package:nodyslexia/customwigdets/return_button.dart';
import 'package:nodyslexia/customwigdets/settings_button.dart';
import 'package:nodyslexia/models/converted_file.dart';
import 'package:nodyslexia/data/persistence.dart';
import 'package:nodyslexia/modules/settings/text_settings.dart';

// Import target route bindings
import 'package:nodyslexia/modules/library/library_viewmodel.dart';
import 'package:nodyslexia/modules/editing/editing_screen.dart';
import 'package:nodyslexia/modules/editing/editing_viewmodel.dart';

import '../../customwigdets/dictionary_entry_display.dart';
import '../../models/dictionary_entry.dart';
import '../../utils/tts_service.dart';
import '../reading/editable_reading_viewmodel.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _dictScrollController = ScrollController();
  final TextEditingController _highlightInputController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _dictScrollController.addListener(_onDictScroll);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _dictScrollController.removeListener(_onDictScroll);
    _dictScrollController.dispose();
    _highlightInputController.dispose();
    super.dispose();
  }

  /// Infinite scrolling listener targeted at the active dictionary tab viewport profile
  void _onDictScroll() {
    if (_dictScrollController.position.pixels >= _dictScrollController.position.maxScrollExtent - 200) {
      context.read<LibraryViewModel>().loadNextDictionaryPage();
    }
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
                      style: textTheme.bodySmall?.copyWith(color: Colors.grey[900]),
                    ),
                  ],
                ),
                const Divider(height: 16),
                Ink(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (routeContext) => ChangeNotifierProvider<EditableReadingViewModel>(
                            create: (providerContext) => EditableReadingViewModel(
                              file: fileItem,
                              ttsService: TtsService(),
                              localDatabase: viewModel.localDatabase
                            ),
                            child: EditableReadingScreen(),
                          ),
                        ),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      child:  Text(
                        fileItem.extractedText,
                        style: textTheme.bodyMedium?.copyWith(color: Colors.grey[900], height: 1.4),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      )
                    )
                  )
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton.icon(
                      icon: const Icon(Icons.delete, size: 16),
                      label: const Text('Xóa'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      ),
                      onPressed: () => _confirmDeletionDialog(context, viewModel, fileItem),
                    ),
                    const SizedBox(width: 8),
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

  Widget _buildHighlightsSection(LibraryViewModel viewModel, TextStyleSettings textStyleSettings, TextTheme textTheme) {
    final highlights = textStyleSettings.highlights;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _highlightInputController,
                  decoration: const InputDecoration(
                    hintText: 'Nhập từ hoặc câu cần tô sáng...',
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () {
                  final text = _highlightInputController.text.trim();
                  if (text.isNotEmpty) {
                    textStyleSettings.addHighlight(viewModel.localDatabase, text);
                    _highlightInputController.clear();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                ),
                child: const Text('Thêm'),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: highlights.isEmpty
              ? _buildPlaceholderSection(
                  'Từ Đã Đánh Dấu',
                  'Các từ được chọn và đánh dấu trong bài đọc hoặc thêm tại đây sẽ hiển thị ở danh sách.',
                  Icons.star_outline,
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: highlights.length,
                  itemBuilder: (context, index) {
                    final itemText = highlights[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8.0),
                      elevation: 1,
                      child: ListTile(
                        leading: const Icon(Icons.star, color: Colors.amber),
                        title: Text(
                          itemText,
                          style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.redAccent),
                          onPressed: () {
                            textStyleSettings.removeHighlight(viewModel.localDatabase, itemText);
                          },
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  // --- NEW: Tab 3 Layout: Dictionary View Component ---
  Widget _buildDictionarySection(LibraryViewModel viewModel, TextTheme textTheme) {
    return Column(
      children: [
        if (viewModel.isDictUpdating)
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(color: Colors.teal),
                    const SizedBox(height: 24),
                    Text(
                      viewModel.dictUpdateStatus,
                      style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: viewModel.dictUpdateProgress,
                        color: Colors.teal,
                        backgroundColor: Colors.teal.shade50,
                        minHeight: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        else ...[
          // Real-time Search Box Header Container
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: viewModel.updateSearchQuery,
              decoration: InputDecoration(
                hintText: 'Tìm kiếm từ vựng...',
                prefixIcon: const Icon(Icons.search, color: Colors.teal),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: const BorderSide(color: Colors.teal, width: 2.0),
                ),
              ),
            ),
          ),

          // Live Search Results / List View
          Expanded(
            child: viewModel.dictionaryEntries.isEmpty && !viewModel.isDictLoading
                ? _buildPlaceholderSection(
                    'Không tìm thấy từ',
                    'Thử tra cứu với một từ vựng khác.',
                    Icons.find_in_page_outlined,
                  )
                : ListView.builder(
                    controller: _dictScrollController,
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    itemCount: viewModel.dictionaryEntries.length + (viewModel.hasMoreDictEntries ? 1 : 0),
                    itemBuilder: (context, index) {
                      // Show a bottom spinning bubble loader if we are loading the next page segment
                      if (index == viewModel.dictionaryEntries.length) {
                        return const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Center(child: CircularProgressIndicator(color: Colors.teal)),
                        );
                      }

                      final DictionaryEntry wordItem = viewModel.dictionaryEntries[index];

                      return Card(
                        color: Colors.white,
                        elevation: 0.5,
                        margin: const EdgeInsets.only(bottom: 10.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          side: BorderSide(color: Colors.grey.shade200),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(12.0),
                          onTap: () {
                            // Open our static modal pipeline class instance effortlessly
                            DictionaryDetailDialog.show(
                              context,
                              wordItem,
                              TtsService(), // Calls your active singleton service provider
                            );
                          },
                          leading: FutureBuilder<Directory>(
                            future: getApplicationDocumentsDirectory(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return Container(width: 50, height: 50, color: Colors.grey.shade100);
                              }

                              // Construct the path pointer matching where we copied the file
                              final String imagePath = p.join(snapshot.data!.path, wordItem.imageName);
                              final File imageFile = File(imagePath);

                              return Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.teal.shade50,
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: imageFile.existsSync() // Fallback safety validation
                                      ? Image.file(imageFile, fit: BoxFit.cover)
                                      : const Icon(Icons.menu_book_rounded, color: Colors.teal),
                                ),
                              );
                            },
                          ),
                          title: Text(
                            wordItem.word,
                            style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Text(
                              wordItem.description,
                              style: textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ],
    );
  }

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

    String pad(int value) => value.toString().padLeft(2, '0');

    final String hour = pad(date.hour);
    final String minute = pad(date.minute);
    final String day = pad(date.day);
    final String month = pad(date.month);
    final String year = date.year.toString();

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
            Padding(
              padding: const EdgeInsets.only(top: 20.0, bottom: 12.0),
              child: Text('Thư viện', style: textTheme.displayLarge),
            ),

            TabBar(
              controller: _tabController,
              indicatorColor: Colors.teal,
              labelColor: Colors.teal,
              labelStyle: textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
              unselectedLabelColor: Colors.grey[600],
              tabs: const [
                Tab(text: 'Văn bản'),
                Tab(text: 'Từ nổi bật'),
                Tab(text: 'Từ điển'),
              ],
            ),

            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: <Widget>[
                  _buildHistorySection(viewModel, textTheme),
                  _buildHighlightsSection(viewModel, context.watch<TextStyleSettings>(), textTheme),
                  _buildDictionarySection(viewModel, textTheme), // Injected dynamic dictionary page section
                ],
              ),
            ),
            const SizedBox(height: 10),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
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