import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nodyslexia/customwigdets/return_button.dart';
import 'package:nodyslexia/customwigdets/settings_button.dart';
import 'package:nodyslexia/models/test.dart';
import 'package:nodyslexia/modules/test/test_screen.dart' hide Test;
import 'package:nodyslexia/modules/test/test_viewmodel.dart';
import 'package:nodyslexia/data/repository_manager.dart';
import 'package:provider/provider.dart';
import 'test_info_viewmodel.dart';

class TestDetailScreen extends StatelessWidget {
  const TestDetailScreen({super.key});

  Widget _buildInfoRow(String label, String value, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.teal[900],
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorTheme = Theme.of(context).colorScheme;
    final viewModel = context.watch<TestDetailViewModel>();
    final test = viewModel.test;
    final maxScore = viewModel.maxScore;

    return Scaffold(
      backgroundColor: Colors.teal.shade50,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 30.0, bottom: 8.0),
              child: Text(
                'Bài kiểm tra',
                style: textTheme.displayLarge?.copyWith(
                  color: colorTheme.primary,
                ),
              ),
            ),
            Expanded(
              child: Row(
                children: <Widget>[
                  // Left Container - Test Information details
                  Expanded(
                    flex: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.grey.shade300,
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.circular(16.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.teal.withOpacity(0.05),
                                  spreadRadius: 2,
                                  blurRadius: 6,
                                )
                              ]
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 20.0),
                            margin: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 20.0),
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  Text(
                                    "Thông tin bài kiểm tra",
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Colors.teal,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const Divider(height: 30, thickness: 1),
                                  _buildInfoRow("Tên bài:", test.name, context),
                                  _buildInfoRow("Thời gian:", "${test.timeLimit} phút", context),
                                  _buildInfoRow("Lượt làm tối đa:", "${test.allowedAttempts}", context),
                                  _buildInfoRow("Lượt đã làm:", "${test.studentStatuses.length}", context),
                                  _buildInfoRow(
                                    "Điểm cao nhất:",
                                    maxScore != null ? "${maxScore.toStringAsFixed(1)} điểm" : "Chưa làm",
                                    context,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: ElevatedButton(
                            onPressed: () async {
                              // Show a loading indicator dialog while initiating session
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) => const Center(child: CircularProgressIndicator()),
                              );
                              try {
                                final testSession = await viewModel.startNewSession();
                                if (context.mounted) {
                                  Navigator.pop(context); // Close loader
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (innerContext) => ChangeNotifierProvider(
                                        create: (providerContext) => TestViewModel(
                                          test: test,
                                          testSession: testSession,
                                          repoManager: providerContext.read<RepoManager>(),
                                        ),
                                        child: const TestScreen(),
                                      ),
                                    ),
                                  );
                                }
                              } catch (e) {
                                if (context.mounted) {
                                  Navigator.pop(context); // Close loader
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Lỗi: $e')),
                                  );
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14.0),
                              textStyle: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                            child: const Text("BẮT ĐẦU"),
                          ),
                        )
                      ],
                    ),
                  ),
                  // Right Container - Previous Attempts History list
                  Expanded(
                    flex: 6,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.grey.shade300,
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(16.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.teal.withOpacity(0.05),
                            spreadRadius: 2,
                            blurRadius: 6,
                          )
                        ]
                      ),
                      padding: const EdgeInsets.all(20.0),
                      margin: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            "Lịch sử làm bài",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.teal,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const Divider(height: 24, thickness: 1),
                          Expanded(
                            child: test.studentStatuses.isEmpty
                                ? Center(
                                    child: Text(
                                      "Bạn chưa thực hiện lượt làm bài nào.",
                                      style: GoogleFonts.poppins(
                                        color: Colors.grey[500],
                                        fontSize: 15,
                                      ),
                                    ),
                                  )
                                : ListView.builder(
                                    itemCount: test.studentStatuses.length,
                                    itemBuilder: (context, index) {
                                      final attempt = test.studentStatuses[index];
                                      return Card(
                                        elevation: 1,
                                        margin: const EdgeInsets.symmetric(vertical: 6.0),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                          side: BorderSide(color: Colors.teal.shade50),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Row(
                                            children: [
                                              CircleAvatar(
                                                backgroundColor: Colors.teal.shade100,
                                                foregroundColor: Colors.teal.shade900,
                                                child: Text(
                                                  "${index + 1}",
                                                  style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
                                                ),
                                              ),
                                              const SizedBox(width: 16),
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "Lần làm thứ ${index + 1}",
                                                      style: GoogleFonts.poppins(
                                                        fontWeight: FontWeight.bold,
                                                        color: Colors.teal[900],
                                                      ),
                                                    ),
                                                    const SizedBox(height: 4),
                                                    Text(
                                                      "Bắt đầu: ${viewModel.formatTimestamp(attempt.startTime)}",
                                                      style: GoogleFonts.poppins(
                                                        fontSize: 12,
                                                        color: Colors.grey[600],
                                                      ),
                                                    ),
                                                    Text(
                                                      "Thời gian làm: ${viewModel.formatDuration(attempt.startTime, attempt.endTime)}",
                                                      style: GoogleFonts.poppins(
                                                        fontSize: 12,
                                                        color: Colors.grey[600],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Text(
                                                "${attempt.score.toStringAsFixed(1)}đ",
                                                style: GoogleFonts.poppins(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20,
                                                  color: Colors.teal,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Bottom Navigation Bar
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  ReturnButton(),
                  const SettingButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
