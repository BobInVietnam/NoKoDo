import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nodyslexia/customwigdets/return_button.dart';
import 'package:nodyslexia/customwigdets/settings_button.dart';

import 'lesson_screen.dart';
// import 'settings_screen.dart'; // Uncomment if you have a SettingsScreen
// import 'lesson_detail_screen.dart'; // Placeholder for where a lesson might navigate

// Enum for sorting options
enum SortOption { name, dateAdded, difficulty }

// Enum for lesson status
enum LessonStatus { notStarted, inProgress, completed }

// Placeholder Lesson Data Model
class Lesson {
  final String id;
  final String name;
  final String difficulty;
  final DateTime dateAdded;
  final LessonStatus status;
  final double progress; // 0.0 to 1.0 for inProgress

  Lesson({
    required this.id,
    required this.name,
    required this.difficulty,
    required this.dateAdded,
    this.status = LessonStatus.notStarted,
    this.progress = 0.0,
  });
}

class PracticeSelectionScreen extends StatefulWidget {
  const PracticeSelectionScreen({super.key});

  @override
  State<PracticeSelectionScreen> createState() =>
      _PracticeSelectionScreenState();
}

class _PracticeSelectionScreenState extends State<PracticeSelectionScreen> {
  final TextEditingController _searchController = TextEditingController();
  SortOption _currentSortOption = SortOption.dateAdded; // Default sort
  bool _sortAscending = true; // Default sort order

  // --- Placeholder Data ---
  // In a real app, this would come from a database or API and be managed by a state solution
  final List<Lesson> _allLessons = [
    Lesson(
      id: '1',
      name: 'Bài Tập Đọc Hiểu Cơ Bản',
      difficulty: 'Dễ',
      dateAdded: DateTime.now().subtract(const Duration(days: 5)),
      status: LessonStatus.completed,
    ),
    Lesson(
      id: '2',
      name: 'Luyện Viết Chính Tả Nâng Cao',
      difficulty: 'Khó',
      dateAdded: DateTime.now().subtract(const Duration(days: 2)),
      status: LessonStatus.inProgress,
      progress: 0.65,
    ),
    Lesson(
      id: '3',
      name: 'Nhận Biết Âm Vần',
      difficulty: 'Trung Bình',
      dateAdded: DateTime.now().subtract(const Duration(days: 10)),
    ),
    Lesson(
      id: '4',
      name: 'Phân Biệt Từ Đồng Âm',
      difficulty: 'Khó',
      dateAdded: DateTime.now().subtract(const Duration(days: 1)),
      status: LessonStatus.inProgress,
      progress: 0.20,
    ),
  ];

  List<Lesson> _filteredLessons = [];

  @override
  void initState() {
    super.initState();
    _filteredLessons = List.from(_allLessons); // Initialize with all lessons
    _sortLessons(); // Apply initial sort
    _searchController.addListener(_filterLessons);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterLessons);
    _searchController.dispose();
    super.dispose();
  }

  void _filterLessons() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredLessons = _allLessons.where((lesson) {
        return lesson.name.toLowerCase().contains(query);
      }).toList();
      _sortLessons(); // Re-sort after filtering
    });
  }

  void _sortLessons() {
    setState(() {
      _filteredLessons.sort((a, b) {
        int comparison;
        switch (_currentSortOption) {
          case SortOption.name:
            comparison = a.name.toLowerCase().compareTo(b.name.toLowerCase());
            break;
          case SortOption.dateAdded:
            comparison = a.dateAdded.compareTo(b.dateAdded);
            break;
          case SortOption.difficulty:
          // This requires a defined order for difficulty, e.g., Dễ < Trung Bình < Khó
            comparison = _compareDifficulty(a.difficulty, b.difficulty);
            break;
        }
        return _sortAscending ? comparison : -comparison;
      });
    });
  }

  int _compareDifficulty(String d1, String d2) {
    const difficultyOrder = {'Dễ': 1, 'Trung Bình': 2, 'Khó': 3};
    return (difficultyOrder[d1] ?? 0).compareTo(difficultyOrder[d2] ?? 0);
  }

  void _setSortOption(SortOption option) {
    setState(() {
      if (_currentSortOption == option) {
        _sortAscending = !_sortAscending; // Toggle order if same option
      } else {
        _currentSortOption = option;
        _sortAscending = true; // Default to ascending for new option
      }
      _sortLessons();
    });
  }

  Widget _buildSortButton(BuildContext context, SortOption option, String label, IconData icon) {
    bool isActive = _currentSortOption == option;
    return TextButton.icon(
      icon: Icon(
        isActive ? (_sortAscending ? Icons.arrow_downward : Icons.arrow_upward) : icon,
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
      onPressed: () => _setSortOption(option),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final TextStyle? screenTitleStyle = GoogleFonts.galindo(
        fontSize: 28, fontWeight: FontWeight.bold, color: Colors.teal[700]);
    final Color primaryColor = Theme.of(context).colorScheme.primary;

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
              child: _filteredLessons.isEmpty
                  ? Center(
                  child: Text(
                    'Không tìm thấy bài học nào.',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ))
                  : ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                itemCount: _filteredLessons.length,
                itemBuilder: (context, index) {
                  final lesson = _filteredLessons[index];
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
                  // Return Button
                  ReturnButton(),
                  // Settings Button
                  SettingButton()
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

    switch (lesson.status) {
      case LessonStatus.completed:
        statusText = 'Đã hoàn thành';
        statusColor = Colors.green.shade600;
        progressIndicator = Icon(Icons.check_circle, color: statusColor, size: 20);
        break;
      case LessonStatus.inProgress:
        statusText = 'Đang học (${(lesson.progress * 100).toInt()}%)';
        statusColor = Colors.orange.shade700;
        progressIndicator = SizedBox(
          width: 60, // Constrain width of the progress bar
          child: LinearProgressIndicator(
            value: lesson.progress,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(statusColor),
            minHeight: 6, // Make it a bit thicker
          ),
        );
        break;
      case LessonStatus.notStarted:
      default:
        statusText = 'Chưa bắt đầu';
        statusColor = Colors.grey.shade600;
        break;
    }

    return Card(
      elevation: 2.0,
      margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 4.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: InkWell(
        onTap: () {
          // In PracticeSelectionScreen, inside the _buildLessonCard's onTap:
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LessonDetailScreen(lessonId: lesson.id), // Pass lessonId if needed
              ),
            );
            print('Tapped on lesson: ${lesson.name}');
        },
        borderRadius: BorderRadius.circular(10.0),
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                lesson.name,
                style: GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.w600, color: Colors.teal[800]),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Độ khó: ${lesson.difficulty}',
                        style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Ngày thêm: ${lesson.dateAdded.day}/${lesson.dateAdded.month}/${lesson.dateAdded.year}',
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
                      if (progressIndicator != null && lesson.status == LessonStatus.inProgress) ...[
                        const SizedBox(height: 4),
                        progressIndicator,
                      ] else if (lesson.status == LessonStatus.completed) ...[
                        const SizedBox(height: 4), // Keep alignment
                        progressIndicator!,
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
