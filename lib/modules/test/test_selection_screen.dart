import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nodyslexia/customwigdets/return_button.dart';
import 'package:nodyslexia/customwigdets/settings_button.dart';

import 'test_info_screen.dart';

// Enum for sorting options
enum SortOption { name, dateAdded, difficulty }

// Enum for Test status
enum TestStatus { notStarted, inProgress, completed }

// Placeholder Test Data Model
class Test {
  final String id;
  final String name;
  final String difficulty;
  final DateTime dateAdded;
  final TestStatus status;
  final double progress; // 0.0 to 1.0 for inProgress
  final double result;

  Test({
    required this.id,
    required this.name,
    required this.difficulty,
    required this.dateAdded,
    this.status = TestStatus.notStarted,
    this.progress = 0.0,
    this.result = 0.0
  });
}

class TestSelectionScreen extends StatefulWidget {
  const TestSelectionScreen({super.key});

  @override
  State<TestSelectionScreen> createState() =>
      _TestSelectionScreenState();
}

class _TestSelectionScreenState extends State<TestSelectionScreen> {
  final TextEditingController _searchController = TextEditingController();
  SortOption _currentSortOption = SortOption.dateAdded; // Default sort
  bool _sortAscending = true; // Default sort order

  // --- Placeholder Data ---
  // In a real app, this would come from a database or API and be managed by a state solution
  final List<Test> _allTests = [
    Test(
      id: '1',
      name: 'Bài Kiểm Tra Đọc Hiểu Cơ Bản',
      difficulty: 'Dễ',
      dateAdded: DateTime.now().subtract(const Duration(days: 5)),
      status: TestStatus.completed,
      result: 9.0
    ),
    Test(
      id: '3',
      name: 'Bài Kiểm Tra Nhận Biết Âm Vần',
      difficulty: 'Trung Bình',
      dateAdded: DateTime.now().subtract(const Duration(days: 10)),
      status: TestStatus.notStarted,
    ),
    Test(
      id: '4',
      name: 'Bài Kiểm Tra Chung 1',
      difficulty: 'Khó',
      dateAdded: DateTime.now().subtract(const Duration(days: 1)),
      status: TestStatus.inProgress,
      progress: 0.20,
    ),
  ];

  List<Test> _filteredTests = [];

  @override
  void initState() {
    super.initState();
    _filteredTests = List.from(_allTests); // Initialize with all Tests
    _sortTests(); // Apply initial sort
    _searchController.addListener(_filterTests);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterTests);
    _searchController.dispose();
    super.dispose();
  }

  void _filterTests() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredTests = _allTests.where((Test) {
        return Test.name.toLowerCase().contains(query);
      }).toList();
      _sortTests(); // Re-sort after filtering
    });
  }

  void _sortTests() {
    setState(() {
      _filteredTests.sort((a, b) {
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
      _sortTests();
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

            // Test List
            Expanded(
              child: _filteredTests.isEmpty
                  ? Center(
                  child: Text(
                    'Không tìm thấy bài học nào.',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ))
                  : ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                itemCount: _filteredTests.length,
                itemBuilder: (context, index) {
                  final Test = _filteredTests[index];
                  return _buildTestCard(context, Test);
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

  Widget _buildTestCard(BuildContext context, Test Test) {
    String statusText;
    Color statusColor;
    double scoreDisplay;
    Widget? progressIndicator;

    switch (Test.status) {
      case TestStatus.completed:
        statusText = 'Đã hoàn thành';
        statusColor = Colors.green.shade600;
        progressIndicator = Row(
            children: <Widget>[
              Text(
                'Điểm: ${Test.result} / 10',
                style: TextStyle(fontSize: 13, color: statusColor, fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                width: 8,
              ),
              Icon(Icons.check_circle, color: statusColor, size: 20)
            ],
          );
        break;
      case TestStatus.inProgress:
        statusText = 'Đang thực hiện (${(Test.progress * 100).toInt()}%)';
        statusColor = Colors.orange.shade700;
        progressIndicator = SizedBox(
          width: 60, // Constrain width of the progress bar
          child: LinearProgressIndicator(
            value: Test.progress,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(statusColor),
            minHeight: 6, // Make it a bit thicker
          ),
        );
        break;
      case TestStatus.notStarted:
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
          // In TestSelectionScreen, inside the _buildTestCard's onTap:
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TestDetailScreen(TestId: Test.id), // Pass TestId if needed
            ),
          );
          print('Tapped on Test: ${Test.name}');
        },
        borderRadius: BorderRadius.circular(10.0),
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                Test.name,
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
                        'Độ khó: ${Test.difficulty}',
                        style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Ngày thêm: ${Test.dateAdded.day}/${Test.dateAdded.month}/${Test.dateAdded.year}',
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
                      if (progressIndicator != null && Test.status == TestStatus.inProgress) ...[
                        const SizedBox(height: 4),
                        progressIndicator,
                      ] else if (Test.status == TestStatus.completed) ...[
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
