import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nodyslexia/customwigdets/return_button.dart';
import 'package:nodyslexia/customwigdets/settings_button.dart';
import 'package:nodyslexia/models/lesson.dart';
import 'package:nodyslexia/modules/practice/practice_selection_viewmodel.dart';
import 'package:provider/provider.dart';

import 'package:nodyslexia/modules/practice/practice_details_screen.dart';
import 'package:nodyslexia/modules/practice/practice_details_viewmodel.dart';

class PracticeSelectionScreen extends StatefulWidget {
  const PracticeSelectionScreen({super.key});

  @override
  State<PracticeSelectionScreen> createState() =>
      _PracticeSelectionScreenState();
}

class _PracticeSelectionScreenState extends State<PracticeSelectionScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    context.read<PracticeSelectionViewModel>().updateSearchQuery(_searchController.text);
  }

  Widget _buildSortButton(BuildContext context, SortOption option, String label, IconData icon) {
    final viewModel = context.watch<PracticeSelectionViewModel>();
    bool isActive = viewModel.currentSortOption == option;
    return TextButton.icon(
      icon: Icon(
        isActive ? (viewModel.sortAscending ? Icons.arrow_downward : Icons.arrow_upward) : icon,
        color: isActive ? Theme.of(context).colorScheme.primary : Colors.grey[700],
        size: 18,
      ),
      label: Text(
        label,
        style: TextStyle(
          color: isActive ? Theme.of(context).colorScheme.primary : Colors.grey[700],
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      onPressed: () => viewModel.setSortOption(option),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<PracticeSelectionViewModel>();
    final TextStyle? screenTitleStyle = GoogleFonts.galindo(
        fontSize: 28, fontWeight: FontWeight.bold, color: Colors.teal[700]);
    final Color primaryColor = Theme.of(context).colorScheme.primary;

    // Sync input field value from viewmodel if cleared/externally modified
    if (viewModel.searchQuery != _searchController.text) {
      _searchController.text = viewModel.searchQuery;
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            // Screen Title
            Padding(
              padding: const EdgeInsets.only(top: 30.0, bottom: 16.0),
              child: Text('Luyện tập', style: screenTitleStyle),
            ),

            // Search and Sort Area
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  // Search Input
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Tìm kiếm tên bài học...',
                      prefixIcon: const Icon(Icons.search, color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(color: Colors.grey[400]!),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(color: Colors.grey[400]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(color: primaryColor, width: 1.5),
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Sort Options
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      _buildSortButton(context, SortOption.name, 'Tên', Icons.sort_by_alpha),
                      _buildSortButton(context, SortOption.dateAdded, 'Ngày', Icons.date_range),
                      _buildSortButton(context, SortOption.difficulty, 'Độ khó', Icons.stairs_outlined),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Lesson List
            Expanded(
              child: viewModel.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : viewModel.filteredLessons.isEmpty
                      ? Center(
                          child: Text(
                            'Không tìm thấy bài học nào.',
                            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          itemCount: viewModel.filteredLessons.length,
                          itemBuilder: (context, index) {
                            final lesson = viewModel.filteredLessons[index];
                            return _buildLessonCard(context, lesson);
                          },
                        ),
            ),
            const SizedBox(height: 10), // Spacer before bottom bar

            // Bottom Navigation Bar
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

  Widget _buildLessonCard(BuildContext context, Lesson lesson) {
    String statusText;
    Color statusColor;
    Widget? progressIndicator;

    if (lesson.isDone) {
      statusText = 'Đã hoàn thành';
      statusColor = Colors.green.shade600;
      progressIndicator = Icon(Icons.check_circle, color: statusColor, size: 20);
    } else {
      statusText = 'Chưa bắt đầu';
      statusColor = Colors.grey.shade600;
    }

    String difficultyText;
    switch (lesson.difficulty) {
      case 0:
        difficultyText = 'Dễ';
        break;
      case 1:
        difficultyText = 'Trung Bình';
        break;
      case 2:
        difficultyText = 'Khó';
        break;
      default:
        difficultyText = 'Không xác định';
    }

    final dateVal = lesson.dateCreated < 1000000000000 ? lesson.dateCreated * 1000 : lesson.dateCreated;
    final DateTime createdDate = DateTime.fromMillisecondsSinceEpoch(dateVal);

    return Card(
      elevation: 2.0,
      margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 4.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: InkWell(
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChangeNotifierProvider(
                create: (innerContext) => PracticeDetailsViewModel(lesson: lesson),
                child: const PracticeDetailsScreen(),
              ),
            ),
          );
          if (context.mounted) {
            context.read<PracticeSelectionViewModel>().fetchLessons();
          }
        },
        borderRadius: BorderRadius.circular(10.0),
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: [
                  Icon(
                    lesson.type == 0 ? Icons.menu_book : Icons.search,
                    color: Colors.teal[700],
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      lesson.name,
                      style: GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.w600, color: Colors.teal[800]),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Độ khó: $difficultyText',
                        style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Ngày thêm: ${createdDate.day}/${createdDate.month}/${createdDate.year}',
                        style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        statusText,
                        style: TextStyle(fontSize: 13, color: statusColor, fontWeight: FontWeight.w500),
                      ),
                      if (progressIndicator != null) ...[
                        const SizedBox(height: 4),
                        progressIndicator,
                      ]
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
