// screens/settings_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nodyslexia/customwigdets/adjustable_text.dart';
import 'package:nodyslexia/customwigdets/return_button.dart';

// Import your new ViewModel
import 'package:nodyslexia/modules/settings/settings_viewmodel.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    // Watch the view model for adjustments instead of the raw data class
    final viewModel = context.watch<SettingsViewModel>();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  Text("Cỡ chữ", style: textTheme.displayMedium),
                  Slider(
                    min: 20,
                    max: 60,
                    value: viewModel.fontSize,
                    onChanged: viewModel.updateFontSize,
                    activeColor: Colors.teal,
                  ),
                  Text("Hiện tại: ${viewModel.fontSize.toStringAsFixed(1)}",
                  style: textTheme.bodyMedium),

                  const Divider(height: 30),
                  Text("Độ dày chữ", style: textTheme.displayMedium),
                  Slider(
                    min: 100,
                    max: 900,
                    divisions: 8,
                    value: viewModel.fontWeightValue.toDouble(),
                    onChanged: (val) => viewModel.updateFontWeight(val.toInt()),
                    activeColor: Colors.teal,
                  ),
                  Text("Hiện tại: w${viewModel.fontWeightValue}", style: textTheme.bodyMedium),

                  const SizedBox(height: 15),
                  Text("Dãn cách chữ", style: textTheme.displayMedium),
                  Slider(
                    min: 1,
                    max: 20,
                    value: viewModel.letterSpacing,
                    onChanged: viewModel.updateLetterSpacing,
                    activeColor: Colors.teal,
                  ),
                  Text("Hiện tại: ${viewModel.letterSpacing.toStringAsFixed(1)}"),

                  const SizedBox(height: 15),
                  Text("Dãn cách từ", style: textTheme.displayMedium),
                  Slider(
                    min: 1,
                    max: 20,
                    value: viewModel.wordSpacing,
                    onChanged: viewModel.updateWordSpacing,
                    activeColor: Colors.teal,
                  ),
                  Text("Hiện tại: ${viewModel.wordSpacing.toStringAsFixed(1)}"),

                  const Divider(height: 30),
                  Text("Màu chữ", style: textTheme.displayMedium),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    children: [
                      _ColorButton(color: Colors.black, label: "Đen"),
                      _ColorButton(color: Colors.black87, label: "Xám"),
                      _ColorButton(color: Colors.indigo.shade800, label: "Xanh"),
                      _ColorButton(color: Colors.red.shade900, label: "Đỏ"),
                      _ColorButton(color: Colors.teal.shade900, label: "Tía"),
                    ],
                  ),

                  const Divider(height: 30),
                  Text("Màu nền đọc sách", style: textTheme.displayMedium),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    children: const [
                      _BgColorButton(color: Colors.white, label: "Trắng"),
                      _BgColorButton(color: Color(0xFFF2F2F2), label: "Xám nhạt"),
                      _BgColorButton(color: Color(0xFFFFFCE4), label: "Vàng nhạt"),
                    ],
                  ),

                  const Divider(height: 30),
                  Text("Phông chữ", style: textTheme.displayMedium),
                  DropdownButton<String>(
                    value: viewModel.fontFamily,
                    isExpanded: true,
                    items: [
                      DropdownMenuItem(value: 'VniAvo', child: Text("VNI Avo", style: textTheme.bodySmall)),
                      DropdownMenuItem(value: 'Roboto', child: Text("Roboto", style: textTheme.bodySmall)),
                      DropdownMenuItem(value: 'Serif', child: Text("Serif", style: textTheme.bodySmall)),
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
                      color: Colors.grey.withOpacity(0.1),
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
              padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const <Widget>[
                  ReturnButton(),
                ],
              ),
            ),
          ],
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
      label: Text(label,
          style: textTheme.bodySmall!.copyWith(
              fontWeight: FontWeight.bold,
          )),
      backgroundColor: isSelected ? color.withOpacity(0.2) : null,
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
    final bool isSelected = viewModel.backgroundColor.value == color.value;
    final textTheme = Theme.of(context).textTheme;

    return ActionChip(
      avatar: CircleAvatar(
        backgroundColor: color,
        radius: 10,
        // child: CircleBorder(side: BorderSide(color: Colors.grey.shade400)),
      ),
      label: Text(label,
          style: textTheme.bodySmall!.copyWith(
              fontWeight: FontWeight.bold,
          )),
      backgroundColor: isSelected ? Colors.teal.withAlpha(52) : null,
      side: isSelected ? const BorderSide(color: Colors.teal, width: 2) : null,
      onPressed: () => viewModel.updateBackgroundColor(color),
    );
  }
}