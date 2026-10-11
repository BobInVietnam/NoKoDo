import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nodyslexia/customwigdets/return_button.dart';
import 'package:nodyslexia/customwigdets/settings_button.dart';
import 'package:nodyslexia/models/test.dart';
import 'package:nodyslexia/modules/settings/text_settings.dart';
import 'package:nodyslexia/modules/test/test_screen.dart' hide Test;
import 'package:nodyslexia/modules/test/test_viewmodel.dart';
import 'package:nodyslexia/data/repository_manager.dart';
import 'package:provider/provider.dart';
import 'test_info_viewmodel.dart';

// ───────────────────────────── Screen ─────────────────────────────

class TestDetailScreen extends StatelessWidget {
  const TestDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    final useVerticalLayout = screenSize.width < screenSize.height;
    final textTheme = Theme.of(context).textTheme;
    final colorTheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Colors.teal.shade50,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 30.0, bottom: 8.0),
              child: Text(
                'Bài kiểm tra',
                style: textTheme.displayLarge?.copyWith(color: colorTheme.primary),
              ),
            ),
            Expanded(
              child: useVerticalLayout
                  ? const _VerticalLayout()
                  : const _HorizontalLayout(),
            ),
            const _BottomBar(),
          ],
        ),
      ),
    );
  }
}

// ───────────────────────────── Layouts ─────────────────────────────

class _VerticalLayout extends StatelessWidget {
  const _VerticalLayout();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: <Widget>[
        Expanded(
          flex: 4,
          child: _TestInfoPanel(
            margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
          ),
        ),
        Expanded(
          flex: 6,
          child: _AttemptsHistoryPanel(
            margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
            showStartButton: true,
          ),
        ),
      ],
    );
  }
}

class _HorizontalLayout extends StatelessWidget {
  const _HorizontalLayout();

  @override
  Widget build(BuildContext context) {
    const margin = EdgeInsets.symmetric(vertical: 30.0, horizontal: 20.0);
    return const Row(
      children: <Widget>[
        Expanded(
          flex: 4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(child: _TestInfoPanel(margin: margin)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: _StartButton(),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 6,
          child: _AttemptsHistoryPanel(margin: margin, showStartButton: false),
        ),
      ],
    );
  }
}

// ───────────────────────────── Panels ─────────────────────────────

/// White rounded card shared by the info and history panels.
class _PanelCard extends StatelessWidget {
  final EdgeInsets padding;
  final EdgeInsets margin;
  final Widget child;

  const _PanelCard({
    required this.padding,
    required this.margin,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300, width: 1.5),
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.teal.withValues(alpha: 0.05),
            spreadRadius: 2,
            blurRadius: 6,
          ),
        ],
      ),
      child: child,
    );
  }
}

class _TestInfoPanel extends StatelessWidget {
  final EdgeInsets margin;

  const _TestInfoPanel({required this.margin});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final viewModel = context.watch<TestDetailViewModel>();
    final test = viewModel.test;
    final maxScore = viewModel.maxScore;

    return _PanelCard(
      padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 20.0),
      margin: margin,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              "Thông tin bài kiểm tra",
              style: textTheme.displayMedium,
              textAlign: TextAlign.center,
            ),
            const Divider(height: 30, thickness: 1),
            _InfoRow(label: "Tên bài:", value: test.name),
            _InfoRow(label: "Thời gian:", value: "${test.timeLimit} giây"),
            _InfoRow(label: "Lượt làm tối đa:", value: "${test.allowedAttempts}"),
            _InfoRow(label: "Lượt đã làm:", value: "${test.studentStatuses.length}"),
            _InfoRow(
              label: "Điểm cao nhất:",
              value: maxScore != null
                  ? "${maxScore.toStringAsFixed(1)} điểm"
                  : "Chưa làm",
            ),
          ],
        ),
      ),
    );
  }
}

class _AttemptsHistoryPanel extends StatelessWidget {
  final EdgeInsets margin;
  final bool showStartButton;

  const _AttemptsHistoryPanel({
    required this.margin,
    required this.showStartButton,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final attempts = context.watch<TestDetailViewModel>().test.studentStatuses;

    return _PanelCard(
      padding: const EdgeInsets.all(20.0),
      margin: margin,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            "Lịch sử làm bài",
            style: textTheme.displayMedium,
            textAlign: TextAlign.center,
          ),
          const Divider(height: 24, thickness: 1),
          Expanded(
            child: attempts.isEmpty
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
              itemCount: attempts.length,
              itemBuilder: (context, index) => _AttemptCard(index: index),
            ),
          ),
          if (showStartButton) ...[
            const Divider(height: 24, thickness: 1),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: _StartButton(),
            ),
          ],
        ],
      ),
    );
  }
}

// ───────────────────────────── Small components ─────────────────────────────

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: textTheme.displayMedium),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: textTheme.bodyLarge!.copyWith(color: Colors.black87),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}

class _AttemptCard extends StatelessWidget {
  final int index;

  const _AttemptCard({required this.index});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final viewModel = context.watch<TestDetailViewModel>();
    final attempt = viewModel.test.studentStatuses[index];

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
                  Text("Lần làm thứ ${index + 1}", style: textTheme.displayMedium),
                  const SizedBox(height: 4),
                  Text(
                    "Bắt đầu: ${viewModel.formatTimestamp(attempt.startTime)}",
                    style: textTheme.bodyMedium,
                  ),
                  Text(
                    "Thời gian làm: ${viewModel.formatDuration(attempt.startTime, attempt.endTime)}",
                    style: textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            Text(
              "${attempt.score.toStringAsFixed(1)}đ",
              style: textTheme.displayMedium!.copyWith(color: Colors.teal),
            ),
          ],
        ),
      ),
    );
  }
}

class _StartButton extends StatelessWidget {
  const _StartButton();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return ElevatedButton(
      onPressed: () => _startTest(context),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 14.0),
        textStyle: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Text(
        "BẮT ĐẦU",
        style: textTheme.displayMedium!.copyWith(color: Colors.white),
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[ReturnButton(), SettingButton()],
      ),
    );
  }
}

// ───────────────────────────── Actions ─────────────────────────────

Future<void> _startTest(BuildContext context) async {
  final viewModel = context.read<TestDetailViewModel>();
  final settings = context.read<NokodoSettings>();
  final test = viewModel.test;

  // Loading indicator while the session is created
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => const Center(child: CircularProgressIndicator()),
  );

  try {
    final testSession = await viewModel.startNewSession();
    if (!context.mounted) return;

    Navigator.pop(context); // close loader
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChangeNotifierProvider(
          create: (providerContext) => TestViewModel(
            test: test,
            testSession: testSession,
            repoManager: providerContext.read<RepoManager>(),
          ),
          child: const TestScreen(),
        ),
      ),
    );
    await settings.updateFromMap(viewModel.repoManager.currentStudent?.settings ?? {});
    await viewModel.refreshDetails();
  } catch (e) {
    if (context.mounted) {
      Navigator.pop(context); // close loader
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$e')));
    }
  }
}