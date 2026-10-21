// screens/settings_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nodyslexia/customwigdets/adjustable_text.dart';
import 'package:nodyslexia/customwigdets/return_button.dart';
import 'package:nodyslexia/modules/evaluation_test/evaluation_test_screen.dart';
import 'package:nodyslexia/modules/evaluation_test/evaluation_test_viewmodel.dart';

import 'package:nodyslexia/data/repository_manager.dart';
import 'package:nodyslexia/modules/settings/text_settings.dart';
import 'package:nodyslexia/modules/settings/settings_viewmodel.dart';

/// Check if SettingsScreen was opened from ReadingScreen or EditableReadingScreen or TestScreen.
bool isOpenedFromReadingScreen(BuildContext context) {
  bool isFromReading = false;

  Navigator.of(context).popUntil((route) {
    final routeName = route.settings.name;
    if (routeName == 'ReadingScreen'
        || routeName == 'EditableReadingScreen'
        || routeName == 'TestScreen') {
      isFromReading = true;
    }
    return true; // Return true immediately so NO routes are popped
  });

  return isFromReading;
}

class SettingsScreen extends StatelessWidget {
  final bool syncEnabled;

  const SettingsScreen({super.key, this.syncEnabled = true});

  void _syncSettings(
    BuildContext context,
    Map<String, dynamic> initialSettings,
  ) {
    try {
      final textSettings = context.read<NokodoSettings>();
      final repoManager = context.read<RepoManager>();
      final newSettings = textSettings.toMap();
      if (syncEnabled) repoManager.saveStudentSettings(newSettings);

      repoManager.trialLogger.logEvent(
        eventType: 'SETTINGS_CHANGED',
        eventCode: 'settings',
        payload: {'from': initialSettings, 'to': newSettings},
      );
    } catch (e) {
      debugPrint("SETTINGS: Exit sync error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    // Watch the view model for adjustments instead of the raw data class
    final viewModel = context.watch<SettingsViewModel>();
    final initialSettings = context.read<NokodoSettings>().toMap();

    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          _syncSettings(context, initialSettings);
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: <Widget>[
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    Text(
                      "Hệ thống đọc văn bản",
                      style: textTheme.displayMedium!.copyWith(
                        fontSize: 36,
                        color: Colors.teal[800],
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text("Tốc độ đọc", style: textTheme.displayMedium),
                    Slider(
                      min: 0.05,
                      max: 1.2,
                      divisions: 23,
                      value: viewModel.speechRate,
                      onChanged: viewModel.updateSpeechRate,
                      activeColor: Colors.teal,
                    ),
                    Text(
                      "Hiện tại: ${viewModel.speechRate.toStringAsFixed(2)}x",
                      style: textTheme.bodyMedium,
                    ),

                    const SizedBox(height: 15),
                    Text("Âm lượng đọc", style: textTheme.displayMedium),
                    Slider(
                      min: 0.0,
                      max: 1.0,
                      divisions: 20,
                      value: viewModel.volume,
                      onChanged: viewModel.updateVolume,
                      activeColor: Colors.teal,
                    ),
                    Text(
                      "Hiện tại: ${(viewModel.volume * 100).toInt()}%",
                      style: textTheme.bodyMedium,
                    ),

                    const SizedBox(height: 15),

                    ElevatedButton.icon(
                      onPressed: viewModel.playTestSound,
                      icon: const Icon(Icons.volume_up, size: 24),
                      label: const Text(
                        "Nghe thử",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Divider(height: 30),
                    Text(
                      "Định dạng văn bản",
                      style: textTheme.displayMedium!.copyWith(
                        fontSize: 36,
                        color: Colors.teal[800],
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text("Cỡ chữ", style: textTheme.displayMedium),
                    Slider(
                      min: 16,
                      max: 60,
                      value: viewModel.fontSize,
                      onChanged: viewModel.updateFontSize,
                      activeColor: Colors.teal,
                    ),
                    Text(
                      "Hiện tại: ${viewModel.fontSize.toStringAsFixed(1)}",
                      style: textTheme.bodyMedium,
                    ),

                    const SizedBox(height: 15),
                    Text("Độ rõ chữ", style: textTheme.displayMedium),
                    Slider(
                      min: 0.25,
                      max: 1.0,
                      divisions: 15,
                      value: viewModel.fontOpacity.toDouble(),
                      onChanged: (val) => viewModel.updateFontOpacity(val),
                      activeColor: Colors.teal,
                    ),
                    Text(
                      "Hiện tại: ${viewModel.fontOpacity.toStringAsFixed(2)}",
                      style: textTheme.bodyMedium,
                    ),

                    const SizedBox(height: 15),
                    Text("Độ dày chữ", style: textTheme.displayMedium),
                    Slider(
                      min: 100,
                      max: 900,
                      divisions: 8,
                      value: viewModel.fontWeightValue.toDouble(),
                      onChanged:
                          (val) => viewModel.updateFontWeight(val.toInt()),
                      activeColor: Colors.teal,
                    ),
                    Text(
                      "Hiện tại: w${viewModel.fontWeightValue}",
                      style: textTheme.bodyMedium,
                    ),

                    const SizedBox(height: 15),
                    Text("Dãn cách chữ", style: textTheme.displayMedium),
                    Slider(
                      min: 0,
                      max: 20,
                      value: viewModel.letterSpacing,
                      onChanged: viewModel.updateLetterSpacing,
                      activeColor: Colors.teal,
                    ),
                    Text(
                      "Hiện tại: ${viewModel.letterSpacing.toStringAsFixed(1)}",
                    ),

                    const SizedBox(height: 15),
                    Text("Dãn cách từ", style: textTheme.displayMedium),
                    Slider(
                      min: 0,
                      max: 20,
                      value: viewModel.wordSpacing,
                      onChanged: viewModel.updateWordSpacing,
                      activeColor: Colors.teal,
                    ),
                    Text(
                      "Hiện tại: ${viewModel.wordSpacing.toStringAsFixed(1)}",
                    ),

                    const SizedBox(height: 15),

                    Text("Màu chữ", style: textTheme.displayMedium),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 10,
                      children: [
                        _ColorButton(color: Colors.black, label: "Đen"),
                        _ColorButton(
                          color: Color.fromARGB(255, 10, 10, 10),
                          label: "Xám",
                        ),
                        _ColorButton(
                          color: Color.fromARGB(255, 0, 0, 125),
                          label: "Xanh",
                        ),
                        _ColorButton(color: Colors.red.shade900, label: "Đỏ"),
                        _ColorButton(color: Colors.teal.shade900, label: "Tía"),
                      ],
                    ),

                    const SizedBox(height: 15),

                    Text("Màu nền đọc sách", style: textTheme.displayMedium),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 10,
                      children: const [
                        _BgColorButton(color: Colors.white, label: "Trắng"),
                        _BgColorButton(
                          color: Color.fromARGB(255, 255, 255, 229),
                          label: "Xám nhạt",
                        ),
                        _BgColorButton(
                          color: Color.fromARGB(255, 250, 250, 200),
                          label: "Vàng nhạt",
                        ),
                        _BgColorButton(
                          color: Color.fromARGB(255, 255, 255, 0),
                          label: "Vàng",
                        ),
                      ],
                    ),

                    const SizedBox(height: 15),

                    Text("Phông chữ", style: textTheme.displayMedium),
                    DropdownButton<String>(
                      value: viewModel.fontFamily,
                      isExpanded: true,
                      items: [
                        DropdownMenuItem(
                          value: 'VniAvo',
                          child: Text("VNI Avo", style: textTheme.bodySmall),
                        ),
                        DropdownMenuItem(
                          value: 'Roboto',
                          child: Text("Roboto", style: textTheme.bodySmall),
                        ),
                        DropdownMenuItem(
                          value: 'Serif',
                          child: Text("Serif", style: textTheme.bodySmall),
                        ),
                      ],
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          viewModel.updateFontFamily(newValue);
                        }
                      },
                    ),
                  ],
                ),
              ),

              // Live Preview Card
              Padding(
                padding: const EdgeInsets.all(20),
                child: Container(
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: viewModel.backgroundColor,
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: Colors.grey.shade300),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withValues(alpha: 0.1),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: const AdjustableText(
                    "Do bạch kim rất quý nên sẽ dùng để lắp vô xương",
                    maxLines: 2,
                  ),
                ),
              ),

              // Footer Navigation Bar
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 16.0,
                  horizontal: 24.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const ReturnButton(),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => ChangeNotifierProvider(
                                  create:
                                      (context) => EvaluationTestViewModel(
                                        repoManager:
                                            context.read<RepoManager>(),
                                      ),
                                  child: const EvaluationTestScreen(),
                                ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.assignment_turned_in, size: 24),
                      label: const Text(
                        "Kiểm tra đầu vào",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ColorButton extends StatelessWidget {
  final Color color;
  final String label;

  const _ColorButton({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<SettingsViewModel>();
    final bool isSelected = viewModel.color == color;
    final textTheme = Theme.of(context).textTheme;

    return ActionChip(
      avatar: CircleAvatar(backgroundColor: color),
      label: Text(
        label,
        style: textTheme.bodySmall!.copyWith(fontWeight: FontWeight.bold),
      ),
      backgroundColor: isSelected ? color.withValues(alpha: 0.2) : null,
      side: isSelected ? BorderSide(color: color, width: 2) : null,
      onPressed: () => viewModel.updateColor(color),
    );
  }
}

class _BgColorButton extends StatelessWidget {
  final Color color;
  final String label;

  const _BgColorButton({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<SettingsViewModel>();
    final bool isSelected = viewModel.backgroundColor.toARGB32() == color.toARGB32();
    final textTheme = Theme.of(context).textTheme;

    return ActionChip(
      avatar: CircleAvatar(
        backgroundColor: color,
        radius: 10,
        // child: CircleBorder(side: BorderSide(color: Colors.grey.shade400)),
      ),
      label: Text(
        label,
        style: textTheme.bodySmall!.copyWith(fontWeight: FontWeight.bold),
      ),
      backgroundColor: isSelected ? Colors.teal.withAlpha(52) : null,
      side: isSelected ? const BorderSide(color: Colors.teal, width: 2) : null,
      onPressed: () => viewModel.updateBackgroundColor(color),
    );
  }
}
