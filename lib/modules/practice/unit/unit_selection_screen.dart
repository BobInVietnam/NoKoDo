// item_grid_screen.dart
import 'package:flutter/material.dart';
import 'package:nodyslexia/customwigdets/return_button.dart';
import 'package:nodyslexia/customwigdets/settings_button.dart';
import 'package:nodyslexia/data/repository_manager.dart';
import 'package:nodyslexia/models/unit.dart';
import 'package:nodyslexia/modules/practice/unit/practice_categories_screen.dart';
import 'package:nodyslexia/modules/practice/unit/unit_selection_viewmodel.dart';
import 'package:nodyslexia/modules/practice/unit/unit_viewmodel.dart';
import 'package:provider/provider.dart';

class UnitSelectionScreen extends StatelessWidget {
  const UnitSelectionScreen({super.key});

  void _navigateToPracticeCategories(BuildContext context, Unit unit) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider(
          create: (innerContext) => UnitViewModel(
            unit: unit,
            repoManager: innerContext.read<RepoManager>(),
          ),
          child: const PracticeCategoriesScreen(),
        ),
      ),
    );
  }

  Widget _buildUnitCard(BuildContext context, int index) {
    final viewModel = context.watch<UnitSelectionViewModel>();
    final textTheme = Theme.of(context).textTheme;

    final isEven = index % 2 == 0;
    final backgroundColor = isEven ? Colors.white : Colors.teal.shade50;

    return ElevatedButton(
      onPressed: () => _navigateToPracticeCategories(context, viewModel.units[index]),
      style: ElevatedButton.styleFrom(
        elevation: 3.0,
        backgroundColor: backgroundColor,
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
          side: const BorderSide(color: Colors.teal, width: 8),
        ),
      ),
      child: Center(
        child: Text(
          viewModel.units[index].name,
          style: textTheme.displayMedium,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final viewModel = context.watch<UnitSelectionViewModel>();
    return  Scaffold(
        body: SafeArea(
          child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Danh sách chủ đề',
                      textAlign: TextAlign.center,
                      style: textTheme.displayLarge,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: viewModel.loading
                        ? const Center(child: CircularProgressIndicator())
                        : GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 16.0,
                        mainAxisSpacing: 16.0,
                        childAspectRatio: 2.5,
                      ),
                      itemCount: viewModel.units.length,
                      itemBuilder: (context, index) => _buildUnitCard(context, index)
                    ),
                  ),
                  const SizedBox(height: 16), // Spacer before bottom bar
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
            )
          ),
        );
  }
}