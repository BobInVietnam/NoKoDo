import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nodyslexia/customwigdets/return_button.dart';
import 'package:nodyslexia/customwigdets/settings_button.dart';
import 'package:nodyslexia/utils/tts_service.dart'; // Import your TTS service

class TextResultScreen extends StatefulWidget {
  final String extractedText;

  const TextResultScreen({super.key, required this.extractedText});

  @override
  State<TextResultScreen> createState() => _TextResultScreenState();
}

class _TextResultScreenState extends State<TextResultScreen> {
  final TtsService _ttsService = TtsService();
  TextSelection _currentSelection = const TextSelection.collapsed(offset: -1);
  OverlayEntry? _selectionMenuOverlay;
  final GlobalKey _textKey = GlobalKey(); // To get position for overlay

  double _currentReadingSpeed = 0.5; // Matches TTS service default

  @override
  void initState() {
    super.initState();
    _currentReadingSpeed = _ttsService.speechRate;
    _ttsService.setLanguage("vi-VN"); // Set to Vietnamese
  }


  @override
  void dispose() {
    _ttsService.stop(); // Stop TTS when screen is disposed
    _removeSelectionMenu();
    super.dispose();
  }

  void _handleReadAll() {
    _ttsService.speak(widget.extractedText, onComplete: () {
      if (mounted) setState(() {}); // To update UI if needed after speaking
    });
    if (mounted) setState(() {}); // To update button state immediately
  }

  void _handleReadSelected(String selectedText) {
    _ttsService.speak(selectedText, onComplete: () {
      if (mounted) setState(() {});
    });
    if (mounted) setState(() {});
  }

  void _handleStopReading() {
    _ttsService.stop();
    if (mounted) setState(() {});
  }

  void _handleSpeedChange(double speed) {
    setState(() {
      _currentReadingSpeed = speed;
    });
    _ttsService.setSpeechRate(speed);
  }

  void _showSelectionMenu(BuildContext context, TextSelection selection, Offset textPosition) {
    _removeSelectionMenu(); // Remove any existing menu

    if (selection.isCollapsed || _textKey.currentContext == null) return;

    final RenderBox renderBox = _textKey.currentContext!.findRenderObject() as RenderBox;
    // Attempt to get a reasonable position for the menu above the selection
    // This is a simplified positioning logic.
    final Offset menuPosition = renderBox.localToGlobal(
        Offset(
            (selection.start + (selection.end - selection.start) / 2) * (Theme.of(context).textTheme.bodyMedium?.fontSize ?? 16) * 0.5, // Rough horizontal center
            selection.baseOffset * (Theme.of(context).textTheme.bodyMedium?.fontSize ?? 16) * 1.5 - 100 // Above the line
        )
    );


    _selectionMenuOverlay = OverlayEntry(
      builder: (context) {
        final selectedText = widget.extractedText.substring(selection.start, selection.end);
        return Positioned(
          left: menuPosition.dx - 50, // Adjust to center the menu
          top: menuPosition.dy - 50,  // Adjust vertical position
          child: Material(
            elevation: 4.0,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextButton(
                    child: const Text('Read', style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      _handleReadSelected(selectedText);
                      _removeSelectionMenu();
                    },
                  ),
                  TextButton(
                    child: const Text('Highlight', style: TextStyle(color: Colors.white)),
                    onPressed: () {
                      // Placeholder for highlighting logic
                      print('Highlight: "$selectedText"');
                      // In a real app, you'd modify the text state or use a rich text editor
                      _removeSelectionMenu();
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
    Overlay.of(context).insert(_selectionMenuOverlay!);
  }

  void _removeSelectionMenu() {
    _selectionMenuOverlay?.remove();
    _selectionMenuOverlay = null;
  }


  @override
  Widget build(BuildContext context) {
    final TextStyle? contentStyle = GoogleFonts.notoSans( // A good font for readability
      fontSize: 18, // Adjust as per theme or settings
      height: 1.6,    // Line spacing
      color: Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black87,
    );

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            // Text Display Area
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: GestureDetector( // To dismiss menu on tap outside
                  onTap: _removeSelectionMenu,
                  child: Container(
                    padding: const EdgeInsets.all(12.0),
                    decoration: BoxDecoration(
                      color: Colors.white, // Or theme background
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
                    child: SingleChildScrollView(
                      child: SelectableText(
                        key: _textKey,
                        widget.extractedText,
                        style: contentStyle,
                        textAlign: TextAlign.justify,
                        onSelectionChanged: (selection, cause) {
                          if (cause == SelectionChangedCause.longPress || cause == SelectionChangedCause.tap) {
                            if (!selection.isCollapsed) {
                              setState(() {
                                _currentSelection = selection;
                              });
                              // Get text widget position
                              final RenderBox? renderBox = _textKey.currentContext?.findRenderObject() as RenderBox?;
                              if (renderBox != null) {
                                final textPosition = renderBox.localToGlobal(Offset.zero);
                                _showSelectionMenu(context, selection, textPosition);
                              }
                            } else {
                              _removeSelectionMenu();
                            }
                          }
                        },
                        // toolbarOptions: ToolbarOptions(copy: true, selectAll: true), // Default toolbar
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Bottom Control Bar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Reading Speed Slider
                  Row(
                    children: [
                      const Icon(Icons.speed, color: Colors.grey),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Slider(
                          value: _currentReadingSpeed,
                          min: 0.1, // Slower
                          max: 1.5, // Faster (adjust max based on TTS engine capabilities)
                          divisions: 14, // (1.5 - 0.1) / 0.1 = 14
                          label: 'Speed: ${_currentReadingSpeed.toStringAsFixed(1)}x',
                          onChanged: _handleSpeedChange,
                          activeColor: Colors.teal,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Action Buttons (Read All, Return, Settings)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      // Return Button
                      ReturnButton(),
                      // Read All / Stop Button
                      ElevatedButton.icon(
                        icon: Icon(_ttsService.ttsState == TtsState.playing
                            ? Icons.stop_circle_outlined
                            : Icons.play_circle_outline),
                        label: Text(_ttsService.ttsState == TtsState.playing ? 'Stop' : 'Read All'),
                        onPressed: _ttsService.ttsState == TtsState.playing
                            ? _handleStopReading
                            : _handleReadAll,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _ttsService.ttsState == TtsState.playing ? Colors.redAccent : Colors.teal,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        ),
                      ),
                      // Settings Button
                      SettingButton()
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
