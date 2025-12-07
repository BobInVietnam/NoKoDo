import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nodyslexia/customwigdets/return_button.dart';
import 'package:nodyslexia/customwigdets/settings_button.dart';

import 'package:nodyslexia/models/test.dart';
import 'package:nodyslexia/utils/repository_manager.dart';
import 'package:provider/provider.dart';
import 'test_info_screen.dart';

// Enum for sorting options
enum SortOption { name, dateCreated, difficulty }


class TestSelectionScreen extends StatefulWidget {
  const TestSelectionScreen({super.key});

  @override
  State<TestSelectionScreen> createState() =>
      _TestSelectionScreenState();
}

class _TestSelectionScreenState extends State<TestSelectionScreen> {
  final TextEditingController _searchController = TextEditingController();
  SortOption _currentSortOption = SortOption.dateCreated; // Default sort
  bool _sortAscending = true; // Default sort order

  // --- Placeholder Data ---
  // In a real app, this would come from a database or API and be managed by a state solution
  late Future<List<TestInfo>> _allTests;
    // TestInfo(
    //   id: 1,
    //   name: 'Bài Kiểm Tra Đọc Hiểu Cơ Bản',
    //   difficulty: 0,
    //   dateCreated: DateTime.now().subtract(const Duration(days: 5)),
    //   attempts: 0,
    //   allowedAttempts: 1,
    //   result: 0,
    //   timeLimit: 300
    // ),
    // TestInfo(
    //     id: 1,
    //     name: 'Bài Kiểm Tra Đọc Hiểu Nâng Cao',
    //     difficulty: 1,
    //     dateCreated: DateTime.now().subtract(const Duration(days: 5)),
    //     attempts: 0,
    //     allowedAttempts: 3,
    //     result: 0,
    //     timeLimit: 500
    // ),
    // TestInfo(
    //     id: 1,
    //     name: 'Bài Kiểm Tra Chung',
    //     difficulty: 2,
    //     dateCreated: DateTime.now().subtract(const Duration(days: 5)),
    //     attempts: 1,
    //     allowedAttempts: 1,
    //     result: 9.0,
    //     timeLimit: 300
    // ),

  List<TestInfo> _filteredTests = [];

  Future<List<TestInfo>> _fetchData() async {
    debugPrint("TESTING: Pulling data...");
    return context.read<RepoManager>().getTestList();
  }

  @override
  void initState() {
    super.initState();
    debugPrint("TESTING: Inside initState");
    _allTests = _fetchData();
    _allTests.then((data) {
      if (mounted) { // Check if screen is still on display
        setState(() {
          // Populate the list used by the UI
          _filteredTests = data;
          // Apply your default sorting immediately
          _sortTests();
        });
      }
    });
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
    // Get the full list first
    _allTests.then((fullList) {
      setState(() {
        // Filter the list
        _filteredTests = fullList.where((testInfo) {
          return testInfo.name.toLowerCase().contains(query);
        }).toList();

        // Re-apply sort
        _sortTests();
      });
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
          case SortOption.dateCreated:
            comparison = a.dateCreated.compareTo(b.dateCreated);
            break;
          case SortOption.difficulty:
          // This requires a defined order for difficulty, e.g., Dễ < Trung Bình < Khó
            comparison = a.difficulty.compareTo(b.difficulty);
            break;
        }
        return _sortAscending ? comparison : -comparison;
      });
    });
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
        size: 20,
      ),
      label: Text(
        label,
        style: TextStyle(
          fontSize: 16,
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
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            // Screen Title
            Padding(
              padding: const EdgeInsets.only(top: 30.0, bottom: 16.0),
              child: Text('Luyện tập', style: textTheme.displayLarge),
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
                        borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
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
                      _buildSortButton(context, SortOption.dateCreated, 'Ngày', Icons.date_range),
                      _buildSortButton(context, SortOption.difficulty, 'Độ khó', Icons.stairs_outlined),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // TestInfo List
            Expanded(
              child: FutureBuilder<List<TestInfo>>(
                  future: _allTests,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      debugPrint("TESTING: _allTests: ${snapshot.data}");
                      return _filteredTests.isEmpty // If there are no test
                          ? Center(
                          child: Text(
                            'Không tìm thấy bài học nào.',
                            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                          ))

                          // If there is
                          : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        itemCount: _filteredTests.length,
                        itemBuilder: (context, index) {
                          final testInfo = _filteredTests[index];
                          return _buildTestCard(context, testInfo);});
                    } else if (snapshot.hasError) {
                      debugPrint('TESTING: Error: ${snapshot.error}');
                      return Center(
                          child: Text(
                            'Có lỗi đã xảy ra. ${snapshot.error}',
                            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                          ));
                    } else{
                        return const Center(child: CircularProgressIndicator());
                      }
                  })
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

  Widget _buildTestCard(BuildContext context, TestInfo TestInfo) {
    String statusText;
    String difficultyText;
    Color statusColor;
    Widget? progressIndicator;
    final textTheme = Theme.of(context).textTheme;

    if (TestInfo.attempts > 0) {
      statusText = 'Đã hoàn thành';
      statusColor = Colors.green.shade600;
      progressIndicator = Row(
        children: <Widget>[
          Text(
            'Điểm: ${TestInfo.result} / 10',
            style: textTheme.bodyMedium?.copyWith(
              color: statusColor
            ),
          ),
          const SizedBox(
            width: 8,
          ),
          Icon(Icons.check_circle, color: statusColor, size: 20)
        ],
      );
    } else {
      statusText = 'Chưa bắt đầu';
      statusColor = Colors.grey.shade600;
    }

    switch (TestInfo.difficulty) {
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

    return Card(
      elevation: 2.0,
      margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 4.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: InkWell(
        onTap: () {
          final test = RepoManager().getTestDetailsAndQuestions(TestInfo.id);
          // In TestSelectionScreen, inside the _buildTestCard's onTap:
          test.then((data) {
            if (mounted) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TestDetailScreen(test: data), // Pass TestId if needed
                ),
              );
              debugPrint('Tapped on TestInfo: ${TestInfo.name}');
            }
          });
        },
        borderRadius: BorderRadius.circular(10.0),
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                TestInfo.name,
                style: textTheme.displayMedium,
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
                        'Độ khó: $difficultyText',
                        style: textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Ngày thêm: ${TestInfo.dateCreated}',
                        style: textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        statusText,
                        style: textTheme.bodyMedium?.copyWith(
                          color: statusColor
                        ),
                      ),
                      const SizedBox(height: 4), // Keep alignment
                      (progressIndicator != null) ? progressIndicator : Container()
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
