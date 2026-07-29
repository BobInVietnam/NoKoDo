import 'package:flutter/material.dart';
import 'package:nodyslexia/customwigdets/return_button.dart';
import 'package:nodyslexia/customwigdets/settings_button.dart';
import 'package:nodyslexia/models/test.dart';
import 'package:nodyslexia/data/repository_manager.dart';
import 'package:nodyslexia/modules/test/test_info_viewmodel.dart';
import 'package:provider/provider.dart';
import 'test_info_screen.dart';
import 'test_selection_viewmodel.dart';

class TestSelectionScreen extends StatelessWidget {
  const TestSelectionScreen({super.key});

  Widget _buildSortButton(BuildContext context, TestSelectionViewModel viewModel, SortOption option, String label, IconData icon) {
    bool isActive = viewModel.currentSortOption == option;
    return TextButton.icon(
      icon: Icon(
        isActive ? (viewModel.sortAscending ? Icons.arrow_downward : Icons.arrow_upward) : icon,
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
      onPressed: () => viewModel.setSortOption(option),
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
    final viewModel = context.watch<TestSelectionViewModel>();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            // Screen Title
            Padding(
              padding: const EdgeInsets.only(top: 30.0, bottom: 16.0),
              child: Text('Bài kiểm tra', style: textTheme.displayLarge),
            ),

            // Search and Sort Area
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  // Search Input
                  TextField(
                    controller: viewModel.searchController,
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
                      _buildSortButton(context, viewModel, SortOption.name, 'Tên', Icons.sort_by_alpha),
                      _buildSortButton(context, viewModel, SortOption.dateCreated, 'Ngày', Icons.date_range),
                      _buildSortButton(context, viewModel, SortOption.difficulty, 'Độ khó', Icons.stairs_outlined),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // TestInfo List
            Expanded(
              child: viewModel.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : viewModel.filteredTests.isEmpty
                      ? Center(
                          child: Text(
                            'Không tìm thấy bài học nào.',
                            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          itemCount: viewModel.filteredTests.length,
                          itemBuilder: (context, index) {
                            final testInfo = viewModel.filteredTests[index];
                            return _buildTestCard(context, testInfo, viewModel);
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
                  const SettingButton()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTestCard(BuildContext context, TestInfo testInfo, TestSelectionViewModel viewModel) {
    String statusText;
    String difficultyText;
    Color statusColor;
    Widget? progressIndicator;
    final textTheme = Theme.of(context).textTheme;
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    final DateTime createdDate = DateTime.fromMillisecondsSinceEpoch(testInfo.dateCreated);

    if (testInfo.attempts > 0) {
      statusText = 'Đã hoàn thành';
      statusColor = Colors.green.shade600;
      progressIndicator = Row(
        children: <Widget>[
          Text(
            'Điểm: ${testInfo.result} / 10',
            style: textTheme.bodyMedium?.copyWith(
              color: statusColor,
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

    switch (testInfo.difficulty) {
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
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          );
          final testFuture = context.read<RepoManager>().getTestDetailsAndQuestions(testInfo.id);
          testFuture.then((data) async {
            Navigator.pop(context);
            if (context.mounted) {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChangeNotifierProvider(
                    create: (context) => TestDetailViewModel(
                      test: data,
                      repoManager: context.read<RepoManager>()
                    ),
                    child: TestDetailScreen()),
                ),
              );
              viewModel.refreshData();
            }
          }).catchError((e) {
            Navigator.pop(context);
            scaffoldMessenger.showSnackBar(const SnackBar(content: Text('Không thể truy cập bài kiểm tra. Hãy kiểm tra kết nối internet của bạn.')));
            debugPrint("Error loading test details: $e");
          });
        },
        borderRadius: BorderRadius.circular(10.0),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              // Left Column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      testInfo.name,
                      style: textTheme.displayMedium,
                    ),
                    const SizedBox(height: 4.0),
                    Row(
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
                              'Ngày thêm: ${createdDate.day}/${createdDate.month}/${createdDate.year}',
                              style: textTheme.bodyMedium,
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
              // Right Column
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  if (progressIndicator != null)
                    progressIndicator
                  else
                    Text(
                      statusText,
                      style: textTheme.bodyMedium?.copyWith(
                        color: statusColor
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
