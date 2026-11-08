import 'package:flutter/material.dart';
import 'package:nodyslexia/customwigdets/menu_button.dart';
import 'package:nodyslexia/customwigdets/return_button.dart';
import 'package:nodyslexia/modules/practice/unit/unit_selection_screen.dart';
import 'package:provider/provider.dart';


class LessonOrCategoryScreen extends StatelessWidget {
  const LessonOrCategoryScreen({super.key});

  // Reuses the already-fetched unit instead of fetching it again
  void _openCategories(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChangeNotifierProvider(
          create: (BuildContext context) {  },
          child: const UnitSelectionScreen(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final buttons = <Widget>[
      MenuButton(
        icon: Icons.topic_outlined,
        label: 'Học tập theo\ntuần/chủ đề',
        verticalPadding: 60,
        expand: true,
        onPressed: () => _openCategories(context)
      ),
      MenuButton(
        icon: Icons.psychology_outlined,
        label: 'Học tập theo\nnhóm năng lực',
        verticalPadding: 60,
        expand: true,
        onPressed: () => _openCategories(context), // TODO: TO CHANGE!!
      ),
    ];

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 30.0, bottom: 16.0),
              child: Text('Học tập', style: textTheme.displayLarge),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                  child: Column(children: buttons)
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[ReturnButton()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// @Preview()
// Widget preview() {
//   return LessonOrCategoryScreen();
// }