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
  final void Function(String?, int)? onTextSelected;
  final int start;
  final int end;

  // --- New Callback Function Dependencies ---
  final void Function()? onReadPressed;
  final void Function()? onDefinePressed; // Giải nghĩa
  final void Function()? onHighlightPressed;

  const SelectableAdjustableText(
      this.data,
      this.start,
      this.end,
      {
        super.key,
        this.textAlign,
        this.maxLines,
        this.onTextSelected,
        this.onReadPressed,
        this.onDefinePressed,
        this.onHighlightPressed,
      });

  List<TextSpan> _buildHighlightSpans(
      String fullText,
      int start,
      int end,
      TextStyle baseStyle,
      Color highlightColor,
      ) {
    // If no word is actively processing, return the text frame un-highlighted
    if (start == -1 || end == -1 || start >= fullText.length || end > fullText.length) {
      return [TextSpan(text: fullText, style: baseStyle)];
    }

    return [
      // 1. Strings before the highlighted keyword token
      TextSpan(
        text: fullText.substring(0, start),
        style: baseStyle,
      ),
      // 2. The active matching keyword token painted with custom background properties
      TextSpan(
        text: fullText.substring(start, end),
        style: baseStyle.copyWith(
          backgroundColor: highlightColor,
          fontWeight: FontWeight.bold
        ),
      ),
      // 3. Trailing strings remaining after the highlighted keyword token
      TextSpan(
        text: fullText.substring(end),
        style: baseStyle,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    // 1. Listen to the global settings
    final settings = context.watch<TextStyleSettings>();

    // 2. Return a SelectableText.rich widget
    return SelectableText.rich(
      TextSpan(
        children: _buildHighlightSpans(
          data,
          start, // tracked by progress indices
          end,   // tracked by progress indices
          TextStyle(
            fontSize: settings.fontSize,
            color: settings.color,
            fontFamily: settings.fontFamily,
            letterSpacing: settings.letterSpacing,
            wordSpacing: settings.wordSpacing,
          ),
          Colors.yellow[400]!, // Custom marker tint
        ),
      ),
      textAlign: textAlign ?? TextAlign.justify,
      onSelectionChanged: (TextSelection selection, SelectionChangedCause? cause) {
        if (selection.isCollapsed || selection.start == -1 || selection.end == -1) {
          onTextSelected!(null, 0);
        } else {
          // Safely extract the slice directly from the source text using indices
          final String selectedString = data.substring(selection.start, selection.end);
          onTextSelected!(selectedString, selection.start);
        }
      },

      // --- Custom Context Menu Builder Pipeline ---
      contextMenuBuilder: (BuildContext context, EditableTextState editableTextState) {
        final TextSelection selection = editableTextState.textEditingValue.selection;

        // Build our 5 explicit custom ContextMenuButtonItems
        final List<ContextMenuButtonItem> buttonItems =
            editableTextState.contextMenuButtonItems;
        buttonItems.clear();

        buttonItems.addAll([
            ContextMenuButtonItem(
              label: 'Sao chép',
              onPressed: () {
                editableTextState.copySelection(SelectionChangedCause.toolbar);
                editableTextState.hideToolbar();
              },
            ),
            ContextMenuButtonItem(
              label: 'Chọn tất cả',
              onPressed: () {
                editableTextState.selectAll(SelectionChangedCause.toolbar);
              },
            ),
            ContextMenuButtonItem(
              label: 'Đọc',
              onPressed: () {
                if (!selection.isCollapsed) {
                  onReadPressed?.call();
                }
                editableTextState.hideToolbar();
              },
            ),
            ContextMenuButtonItem(
              label: 'Giải nghĩa',
              onPressed: () {
                if (!selection.isCollapsed) {
                  onDefinePressed?.call();
                }
                editableTextState.hideToolbar();
              },
            ),
            ContextMenuButtonItem(
              label: 'Đánh dấu',
              onPressed: () {
                if (!selection.isCollapsed) {
                  onHighlightPressed?.call();
                }
                editableTextState.hideToolbar();
              },
            ),
          ]
        );

        // Return a completely rewritten, platform-adaptive toolbar container
        return AdaptiveTextSelectionToolbar.buttonItems(
          anchors: editableTextState.contextMenuAnchors,
          buttonItems: buttonItems,
        );
      },
    );
  }
}