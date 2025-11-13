import 'package:flutter/material.dart';
import 'package:nodyslexia/modules/settings/text_settings.dart';
import 'package:provider/provider.dart';

class AdjustableText extends StatelessWidget {
  final String data;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final int? maxLines;

  // We accept the string and common Text parameters
  const AdjustableText(
      this.data, {
        super.key,
        this.textAlign,
        this.overflow,
        this.maxLines,
      });

  @override
  Widget build(BuildContext context) {
    // 1. Listen to the global settings
    // This triggers a rebuild whenever settings change
    final settings = context.watch<TextStyleSettings>();

    // 2. Return a standard Text widget with the global style applied
    return Text(
      data,
      textAlign: textAlign,
      overflow: overflow,
      maxLines: maxLines,
      style: TextStyle(
        fontSize: settings.fontSize,
        color: settings.color,
        fontFamily: settings.fontFamily,
        letterSpacing: settings.letterSpacing,
        wordSpacing: settings.wordSpacing
      ),
    );
  }
}