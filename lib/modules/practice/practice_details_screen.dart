import 'package:flutter/material.dart';
import 'package:nodyslexia/customwigdets/return_button.dart';
import 'package:nodyslexia/customwigdets/settings_button.dart';
import 'package:nodyslexia/modules/practice/practice_details_viewmodel.dart';
import 'package:provider/provider.dart';

class PracticeDetailsScreen extends StatelessWidget {
  const PracticeDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<PracticeDetailsViewModel>();
    final textTheme = Theme.of(context).textTheme;
    final lesson = viewModel.lesson;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 48),
                  Text(
                    'Bài tập',
                    style: textTheme.displayLarge,
                  ),
                  const SizedBox(height: 12.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      lesson.name,
                      style: textTheme.displayMedium,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 16.0),
                      margin: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 16.0),
                      width: double.infinity,
                      child: SingleChildScrollView(
                        child: Text(
                          lesson.description,
                          style: textTheme.bodyLarge,
                        ),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => viewModel.startLesson(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      textStyle: textTheme.displayMedium,
                    ),
                    child: const Text('Bắt đầu'),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
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
