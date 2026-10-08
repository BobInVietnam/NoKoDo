import 'package:flutter/material.dart';
import 'package:nodyslexia/modules/statistics/statistics_viewmodel.dart';
import 'package:percent_indicator/percent_indicator.dart'; // For circular progress
import 'package:nodyslexia/customwigdets/return_button.dart';
import 'package:nodyslexia/customwigdets/settings_button.dart';
import 'package:provider/provider.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  Widget _buildStatisticCard({
    required BuildContext context,
    required String title,
    required String value,
    IconData? icon,
    Color? iconColor,
  }) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 2.0,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            if (icon != null)
              Icon(icon, size: 30, color: iconColor ?? colorScheme.primary),
            if (icon != null) const SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    value,
                    style: textTheme.displayMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCircularProgressCard({
    required BuildContext context,
    required String title,
    required double percent, // 0.0 to 1.0
    required IconData icon,
    String? subtitle,
  }) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      elevation: 2.0,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircularPercentIndicator(
              radius: 40.0,
              lineWidth: 8.0,
              percent: percent,
              center: Icon(icon, size: 30, color: colorScheme.primary),
              progressColor: colorScheme.primary,
              circularStrokeCap: CircularStrokeCap.round,
            ),
            const SizedBox(width: 20.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${(percent * 100).toStringAsFixed(0)}%',
                        style: textTheme.displayMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (subtitle != null)
                        Text(
                          subtitle,
                          style: textTheme.bodyMedium!.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingScreen(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            strokeWidth: 5.0,
            valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
          ),
          const SizedBox(height: 24.0),
          Text(
            'Đang tải dữ liệu tiến độ...',
            style: textTheme.titleMedium?.copyWith(
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40.0),
            child: Text(
              'Hệ thống đang đồng bộ kết quả bài tập của bạn.',
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium?.copyWith(color: Colors.grey[500]),
            ),
          ),
        ],
      ),
    );
  }

  void _handleExportCsv(
    BuildContext context,
    StatisticsViewmodel viewModel,
  ) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (loadingContext) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final filePaths = await viewModel.exportCsvFiles();
      if (context.mounted) {
        Navigator.pop(context); // Close loading dialog
        showDialog(
          context: context,
          builder:
              (dialogContext) => AlertDialog(
                title: const Text('Xuất CSV thành công'),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Đã xuất thành công 3 tệp CSV (Sessions, Trials, Events):',
                      ),
                      const SizedBox(height: 12),
                      for (final path in filePaths)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 6.0),
                          child: Text(
                            '• ${path.split('/').last}\n  ($path)',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.blueGrey,
                            ),
                          ),
                        ),
                    ],
                  ),
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
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context); // Close loading dialog
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Lỗi khi xuất tệp CSV: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final viewModel = context.watch<StatisticsViewmodel>();
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    final double practiceCompletionRatio =
        viewModel.lessonNumber > 0
            ? viewModel.lessonFinishedNumber / viewModel.lessonNumber
            : 0.0;

    final double testCompletionRatio =
        viewModel.testNumber > 0
            ? viewModel.testFinishedNumber / viewModel.testNumber
            : 0.0;

    if (viewModel.hasError) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        scaffoldMessenger.showSnackBar(
          const SnackBar(content: Text('Lỗi khi tải thống kê.')),
        );
        viewModel.clearError();
      });
    }
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            // Screen Title
            Padding(
              padding: const EdgeInsets.only(top: 30.0, bottom: 20.0),
              child: Text('Thống kê', style: textTheme.displayLarge),
            ),

            Expanded(
              child:
                  viewModel.isLoading
                      ? _buildLoadingScreen(context)
                      : ListView(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 10.0,
                        ),
                        children: <Widget>[
                          _buildCircularProgressCard(
                            context: context,
                            title: 'Hoàn thành Bài luyện tập',
                            percent: practiceCompletionRatio,
                            icon: Icons.model_training, // Example icon
                            subtitle:
                                '${viewModel.lessonFinishedNumber} / ${viewModel.lessonNumber} bài',
                          ),
                          _buildCircularProgressCard(
                            context: context,
                            title: 'Hoàn thành Bài kiểm tra',
                            percent: testCompletionRatio,
                            icon:
                                Icons
                                    .assignment_turned_in_outlined, // Example icon
                            subtitle:
                                '${viewModel.testFinishedNumber} / ${viewModel.testNumber} bài',
                          ),
                          _buildStatisticCard(
                            context: context,
                            title: 'Điểm trung bình Kiểm tra',
                            value: '${viewModel.averageTestScore} điểm',
                            icon: Icons.star_border_outlined,
                            iconColor: Colors.amber[700],
                          ),
                          _buildStatisticCard(
                            context: context,
                            title: 'Thời gian sử dụng',
                            value: viewModel.formattedUsageTime,
                            icon: Icons.timer_outlined,
                          ),
                          Card(
                            elevation: 2.0,
                            margin: const EdgeInsets.symmetric(vertical: 8.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            color: Colors.teal[50],
                            child: InkWell(
                              onTap: () => _handleExportCsv(context, viewModel),
                              borderRadius: BorderRadius.circular(12.0),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.file_download_outlined,
                                      size: 30,
                                      color: Colors.teal[800],
                                    ),
                                    const SizedBox(width: 16.0),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Xuất dữ liệu 3 tệp CSV',
                                            style: textTheme.bodyMedium!
                                                .copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.teal[900],
                                                ),
                                          ),
                                          const SizedBox(height: 4.0),
                                          Text(
                                            'Sessions, Trials & Event Logs',
                                            style: textTheme.bodyMedium!
                                                .copyWith(
                                                  color: Colors.teal[700],
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Icon(
                                      Icons.chevron_right,
                                      color: Colors.teal[800],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
            ),

            // Bottom Navigation Bar
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 16.0,
                horizontal: 24.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[ReturnButton(), SettingButton()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
