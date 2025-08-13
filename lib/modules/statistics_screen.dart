import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart'; // For circular progress
import 'package:nodyslexia/customwigdets/return_button.dart';
import 'package:nodyslexia/customwigdets/settings_button.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  // --- Placeholder Data ---
  final double practiceCompletion = 0.75; // 75%
  final double testCompletion = 0.50; // 50%
  final double averageTestScore = 82.5; // Average score
  final Duration totalUsageTime = const Duration(hours: 12, minutes: 35);
  // -------------------------

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    // String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)} giờ ${twoDigitMinutes} phút";
  }

  Widget _buildStatisticCard(
      {required BuildContext context,
        required String title,
        required String value,
        IconData? icon,
        Color? iconColor}) {
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
                  Text(title, style: textTheme.titleMedium),
                  const SizedBox(height: 4.0),
                  Text(value,
                      style: textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold, color: colorScheme.primary)),
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
                  Text(title, style: textTheme.titleMedium),
                  const SizedBox(height: 4.0),
                  Text(
                    '${(percent * 100).toStringAsFixed(0)}%',
                    style: textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold, color: colorScheme.primary),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    // final colorScheme = Theme.of(context).colorScheme; // Not directly used here, but good to have

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            // Screen Title
            Padding(
              padding: const EdgeInsets.only(top: 30.0, bottom: 20.0),
              child: Text(
                'Thống kê',
                style: textTheme.displayLarge,
              ),
            ),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                children: <Widget>[
                  _buildCircularProgressCard(
                    context: context,
                    title: 'Hoàn thành Bài luyện tập',
                    percent: practiceCompletion,
                    icon: Icons.model_training, // Example icon
                  ),
                  _buildCircularProgressCard(
                    context: context,
                    title: 'Hoàn thành Bài kiểm tra',
                    percent: testCompletion,
                    icon: Icons.assignment_turned_in_outlined, // Example icon
                  ),
                  _buildStatisticCard(
                    context: context,
                    title: 'Điểm trung bình Kiểm tra',
                    value: '${averageTestScore.toStringAsFixed(1)} điểm',
                    icon: Icons.star_border_outlined,
                    iconColor: Colors.amber[700],
                  ),
                  _buildStatisticCard(
                    context: context,
                    title: 'Thời gian sử dụng',
                    value: _formatDuration(totalUsageTime),
                    icon: Icons.timer_outlined,
                  ),
                  // You can add more statistics cards here
                ],
              ),
            ),

            // Bottom Navigation Bar
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
