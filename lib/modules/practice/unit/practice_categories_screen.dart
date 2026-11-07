import 'package:flutter/material.dart';
import 'package:nodyslexia/customwigdets/menu_button.dart';
import 'package:nodyslexia/customwigdets/return_button.dart';
import 'package:nodyslexia/customwigdets/settings_button.dart';
import 'package:nodyslexia/data/repository_manager.dart';
import 'package:nodyslexia/models/unit.dart';
import 'package:nodyslexia/modules/practice/practice_selection_screen.dart';
import 'package:nodyslexia/modules/practice/practice_selection_viewmodel.dart';
import 'package:nodyslexia/modules/practice/unit/unit_viewmodel.dart';
import 'package:nodyslexia/modules/test/test_selection_screen.dart';
import 'package:nodyslexia/modules/test/test_selection_viewmodel.dart';
import 'package:provider/provider.dart';

enum PracticeCategory {
  readAloud('Đọc thành tiếng', Icons.record_voice_over_outlined, 0),
  readComprehension('Đọc hiểu', Icons.menu_book_outlined, 1),
  speaking('Nói - Kể chuyện', Icons.mic_none_outlined, 2),
  wordsAndSentences('Luyện từ và câu', Icons.spellcheck, 3),
  dictation('Viết chính tả', Icons.edit_outlined, 4),
  writing('Viết đoạn - bài văn', Icons.description_outlined, 5),
  test('Bài kiểm tra', Icons.quiz_outlined, 6);

  final String label;
  final IconData icon;
  final int code;
  const PracticeCategory(this.label, this.icon, this.code);
}

class PracticeCategoriesScreen extends StatelessWidget {
  void _onCategorySelected(BuildContext context, PracticeCategory category) {
    final viewModel = context.read<UnitViewModel>();

    if (category.code == 6) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChangeNotifierProvider(
            create: (innerContext) => TestSelectionViewModel(
              repoManager: innerContext.read<RepoManager>(),
              unitId: viewModel.unit.id,
            ),
            child: const TestSelectionScreen(),
          )
        )
      );
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ChangeNotifierProvider(
                create: (innerContext) => PracticeSelectionViewModel(
                    repoManager: innerContext.read<RepoManager>(),
                    unitId: viewModel.unit.id,
                    category: category.code,
                    categoryName: category.label
                ),
                child: const PracticeSelectionScreen(),
              )
          )
      );
    }
  }

  const PracticeCategoriesScreen({
    super.key
  });

  // Light rainbow, red -> pink, one per category
  static final List<Color> _rainbow = [
    Colors.red.shade100,
    Colors.orange.shade100,
    Colors.yellow.shade100,
    Colors.green.shade100,
    Colors.blue.shade100,
    Colors.purple.shade100,
    Colors.pink.shade100,
  ];

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final viewModel = context.watch<UnitViewModel>();
    const categories = PracticeCategory.values;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 30.0, bottom: 16.0),
              child: Text(viewModel.unit.name ?? "PLACEHOLDER", style: textTheme.displayLarge),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      for (int i = 0; i < categories.length; i++) ...[
                        if (i > 0) const SizedBox(height: 10),
                        MenuButton(
                          icon: categories[i].icon,
                          label: categories[i].label,
                          backgroundColor: _rainbow[i],
                          verticalPadding: 24,
                          onPressed: () => _onCategorySelected(context, categories[i]),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 24.0),
              child: Row(
                children: <Widget>[
                  ReturnButton(),
                  Expanded(
                    child: Center(
                      child: _ProgressLabel(progress: viewModel.unit.progress),
                    ),
                  ),
                  const SizedBox(width: 32)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgressLabel extends StatelessWidget {
  final double progress;

  const _ProgressLabel({required this.progress});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Tiến độ: ${(progress * 100).round()}%', style: textTheme.bodyMedium),
        const SizedBox(height: 6),
        SizedBox(
          width: 200,
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
            color: Colors.teal,
            backgroundColor: Colors.white,
          ),
        ),
      ],
    );
  }
}