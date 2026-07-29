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
                    children: const [
                      _ColorButton(color: Colors.black, label: "Đen"),
                      _ColorButton(color: Colors.black87, label: "Xám"),
                      _ColorButton(color: Colors.indigo, label: "Xanh"),
                      _ColorButton(color: Colors.red, label: "Đỏ"),
                      _ColorButton(color: Colors.teal, label: "Tía"),
                    ],
                  ),

                  const Divider(height: 30),
                  Text("Phông chữ", style: textTheme.displayMedium),
                  DropdownButton<String>(
                    value: viewModel.fontFamily,
                    isExpanded: true,
                    items: [
                      DropdownMenuItem(value: 'Roboto', child: Text("Standard (Roboto)", style: textTheme.bodySmall)),
                      DropdownMenuItem(value: 'Courier', child: Text("Monospace (Courier)", style: textTheme.bodySmall)),
                      DropdownMenuItem(value: 'Serif', child: Text("Classic (Serif)", style: textTheme.bodySmall)),
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
            const Padding(
              padding: EdgeInsets.all(20),
              child: AdjustableText(
                "Do bạch kim rất quý nên sẽ dùng để lắp vô xương",
                maxLines: 2,
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