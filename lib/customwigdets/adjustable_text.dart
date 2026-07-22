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
      List<String> savedHighlights,
      ) {
    final List<_TextRange> ranges = [];

    // 1. Add TTS range
    if (start != -1 && end != -1 && start < fullText.length && end <= fullText.length) {
      ranges.add(_TextRange(start: start, end: end, isTts: true));
    }

    bool isNotLetter(String char) {
      // [^a-zA-Z] means "anything EXCEPT a-z and A-Z"
      return RegExp(r'^[^\p{L}]$', unicode: true).hasMatch(char); // Includes international accents
    }

    bool overlaps(int s, int e) {
      for (final r in ranges) {
        if (!(e <= r.start || s >= r.end)) {
          return true;
        }
      }
      return false;
    }

    // 2. Add database highlights (case-insensitive matching)
    final lowerText = fullText.toLowerCase();
    for (final h in savedHighlights) {
      if (h.isEmpty) continue;
      final lowerH = h.toLowerCase();
      int index = lowerText.indexOf(lowerH);
      while (index != -1) {
        bool blankStart = index <= 0;
        if (!blankStart) {
          blankStart = isNotLetter(lowerText[index - 1]);
        }
        bool blankEnd = index + h.length + 1 >= lowerText.length;
        if (!blankEnd) {
          blankEnd = isNotLetter(lowerText[index + h.length]);
        }
        if (!overlaps(index, index + h.length) && blankStart && blankEnd) {
          ranges.add(_TextRange(start: index, end: index + h.length, isTts: false));
        }
        index = lowerText.indexOf(lowerH, index + 1);
      }
    }

    // Sort by start index
    ranges.sort((a, b) => a.start.compareTo(b.start));

    // Build Spans
    final List<TextSpan> spans = [];
    int currentIdx = 0;
    for (final r in ranges) {
      if (r.start > currentIdx) {
        spans.add(TextSpan(text: fullText.substring(currentIdx, r.start), style: baseStyle));
      }

      final chunkText = fullText.substring(r.start, r.end);
      if (r.isTts) {
        spans.add(TextSpan(
          text: chunkText,
          style: baseStyle.copyWith(
            backgroundColor: highlightColor,
            fontWeight: FontWeight.bold,
          ),
        ));
      } else {
        // Saved highlight matches: yellow background + bold font
        spans.add(TextSpan(
          text: chunkText,
          style: baseStyle.copyWith(
            backgroundColor: Colors.yellow[300],
            fontWeight: FontWeight.bold,
          ),
        ));
      }
      currentIdx = r.end;
    }

    if (currentIdx < fullText.length) {
      spans.add(TextSpan(text: fullText.substring(currentIdx), style: baseStyle));
    }

    return spans;
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
          settings.highlights,
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

        final String selectedText = selection.isCollapsed
            ? ''
            : editableTextState.textEditingValue.text.substring(selection.start, selection.end).trim();
        final bool isAlreadyHighlighted = settings.highlights.contains(selectedText);

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
              label: isAlreadyHighlighted ? 'Bỏ đánh dấu' : 'Đánh dấu',
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

class _TextRange {
  final int start;
  final int end;
  final bool isTts;
  _TextRange({required this.start, required this.end, required this.isTts});
}