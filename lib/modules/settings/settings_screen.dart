import 'package:flutter/material.dart';
import 'package:nodyslexia/customwigdets/adjustable_text.dart';
import 'package:nodyslexia/modules/settings/text_settings.dart';
import 'package:provider/provider.dart';

import 'package:nodyslexia/customwigdets/return_button.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final settings = context.watch<TextStyleSettings>();

    return Scaffold(
      body: SafeArea(
        child: Column (
          children: <Widget>[
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  const Text("Cỡ chữ", style: TextStyle(fontWeight: FontWeight.bold)),
                  Slider(
                    min: 20,
                    max: 60,
                    value: settings.fontSize,
                    onChanged: (value) {
                      context.read<TextStyleSettings>().setFontSize(value);
                    },
                  ),
                  Text("Hiện tại: ${settings.fontSize.toStringAsFixed(1)}"),
                  const Text("Dãn cách chữ", style: TextStyle(fontWeight: FontWeight.bold)),
                  Slider(
                    min: 1,
                    max: 20,
                    value: settings.letterSpacing,
                    onChanged: (value) {
                      context.read<TextStyleSettings>().setLetterSpacing(value);
                    },
                  ),
                  Text("Hiện tại: ${settings.letterSpacing.toStringAsFixed(1)}"),
                  const Text("Dãn cách từ", style: TextStyle(fontWeight: FontWeight.bold)),
                  Slider(
                    min: 1,
                    max: 20,
                    value: settings.wordSpacing,
                    onChanged: (value) {
                      context.read<TextStyleSettings>().setWordSpacing(value);
                    },
                  ),
                  Text("Hiện tại: ${settings.wordSpacing.toStringAsFixed(1)}"),
                  const Divider(height: 30),
                  Text("Màu chữ", style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    children: [
                      _ColorButton(color: Colors.black, label: "Đen"),
                      _ColorButton(color: Colors.blue, label: "Xanh"),
                      _ColorButton(color: Colors.red, label: "Đỏ"),
                      _ColorButton(color: Colors.teal, label: "Tía"),
                    ],
                  ),

                  const Divider(height: 30),

                  const Text("Phông chữ", style: TextStyle(fontWeight: FontWeight.bold)),
                  DropdownButton<String>(
                    value: settings.fontFamily,
                    isExpanded: true,
                    items: const [
                      DropdownMenuItem(value: 'Roboto', child: Text("Standard (Roboto)")),
                      DropdownMenuItem(value: 'Courier', child: Text("Monospace (Courier)")),
                      DropdownMenuItem(value: 'Serif', child: Text("Classic (Serif)")),
                    ],
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        context.read<TextStyleSettings>().setFontFamily(newValue);
                      }
                    },
                  ),
                  // const AdjustableText("The quick, brown fox jumps over the lazy dog!? Wow.")
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(20),
              child: const AdjustableText(
                  "The quick, brown fox jumps over the lazy dog!? Wow.",
                  maxLines: 2)),
            const Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  // Return Button
                  ReturnButton()

                ],
              ),
            ),
          ],
        )
      )
    );
  }
}

class _ColorButton extends StatelessWidget {
  final Color color;
  final String label;

  const _ColorButton({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<TextStyleSettings>();
    bool isSelected = settings.color == color;

    return ActionChip(
      avatar: CircleAvatar(backgroundColor: color),
      label: Text(label),
      backgroundColor: isSelected ? color.withOpacity(0.2) : null,
      side: isSelected ? BorderSide(color: color, width: 2) : null,
      onPressed: () {
        context.read<TextStyleSettings>().setColor(color);
      },
    );
  }
}