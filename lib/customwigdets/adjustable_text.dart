import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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

class SelectableAdjustableText extends StatelessWidget {
  final String data;
  final TextAlign? textAlign;
  final int? maxLines;
  final void Function(String?)? onTextSelected;

  const SelectableAdjustableText(
      this.data, {
        super.key,
        this.textAlign,
        this.maxLines,
        this.onTextSelected,
      });

  @override
  Widget build(BuildContext context) {
    // 1. Listen to the global settings
    final settings = context.watch<TextStyleSettings>();

    // 2. Return a SelectableText widget
    return SelectionArea(
        onSelectionChanged: (SelectedContent? content) {
          if (content == null || content.plainText.isEmpty) {
            // Collects the plaintext representation of the highlighted matrices
            onTextSelected!(null);
          } else {
            onTextSelected!(content.plainText);
          }
        },
        child: Text(
          data,
          textAlign: textAlign,
          style: TextStyle(
            fontSize: settings.fontSize,
            color: settings.color,
            fontFamily: settings.fontFamily,
            letterSpacing: settings.letterSpacing,
            wordSpacing: settings.wordSpacing,
          )
        )
    );
  }
}