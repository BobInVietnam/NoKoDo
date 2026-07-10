// viewmodels/editing_viewmodel.dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:nodyslexia/data/persistence.dart';
import 'package:nodyslexia/models/converted_file.dart';

class EditingViewModel extends ChangeNotifier {
  late TextEditingController textController;
  final LocalDatabase localDatabase;

  String _fileName = ""; // Initial template file state placeholder
  int _fileId = 0;
  bool _showRenameDialog = false;

  // --- History Management State ---
  final List<String> _undoStack = [];
  final List<String> _redoStack = [];
  final int _maxHistorySteps = 10;

  Timer? _debounceTimer;
  String _lastUpdatedText = "";
  String _lastSavedText = "";

  // Getters
  String get fileName => _fileName;
  int get fileId => _fileId;
  bool get canUndo => _undoStack.isNotEmpty && _undoStack.length < _maxHistorySteps;
  bool get canRedo => _redoStack.isNotEmpty;
  bool get showRenameDialog => _showRenameDialog;

  EditingViewModel({
    required ConvertedFile file,
    required this.localDatabase
  }) {
    _fileName = file.fileName;
    _fileId = file.id!;
    _lastUpdatedText = file.extractedText;
    _lastSavedText = file.extractedText;

    textController = TextEditingController(text: file.extractedText);
    textController.addListener(_onTextChanged);
  }

  void _onTextChanged() {

    if (textController.text == _lastUpdatedText) return;

    // Reset the debounce timer on every single keystroke
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(seconds: 1), () {
      _saveToHistory(textController.text);
    });
    notifyListeners();
  }

  void _saveToHistory(String newText) {
    // 1. Push the PREVIOUS stable text state onto the undo stack before accepting new changes
    if (_undoStack.isEmpty || _undoStack.last != _lastUpdatedText) {
      _undoStack.add(_lastUpdatedText);
    }

    // 2. Enforce the 10-step history threshold boundary (FIFO)
    if (_undoStack.length > _maxHistorySteps) {
      _undoStack.removeAt(0); // Drops oldest state token
    }

    // 3. Clear the redo stack because a brand new typed action breaks the redo timeline branch
    _redoStack.clear();

    _lastUpdatedText = newText;
    notifyListeners();
  }

  // --- Button Action Placeholders ---
  Future<ConvertedFile?> getUpdatedFile() {
    return localDatabase.getConvertedFileById(fileId);
  }

  void renameFile(String newName) {
    debugPrint("ACTION: Trigger rename dialog scenario.");
    // Example: Update state via a text submission dialog box
    _fileName = newName;
    notifyListeners();
  }

  void undoAction() {
    if (!canUndo) return;

    // Cancel any active typing timers so pending entries don't overwrite current state adjustments
    _debounceTimer?.cancel();

    // 1. Save the current text into the redo stack before stepping backward
    _redoStack.add(textController.text);

    // 2. Pop the last state item out of the undo stack
    final String previousState = _undoStack.removeLast();
    _lastUpdatedText = previousState;

    // 3. Update the text controller temporarily without re-triggering history tracking metrics
    textController.removeListener(_onTextChanged);
    textController.text = previousState;
    textController.selection = TextSelection.collapsed(offset: previousState.length); // Put cursor at end
    textController.addListener(_onTextChanged);

    notifyListeners();
  }

  void redoAction() {
    if (!canRedo) return;

    _debounceTimer?.cancel();

    // 1. Push current stable text frame down onto the undo stack
    _undoStack.add(textController.text);

    // 2. Extract forward target state from the redo stack
    final String nextState = _redoStack.removeLast();
    _lastUpdatedText = nextState;

    // 3. Apply state modification smoothly to text view node
    textController.removeListener(_onTextChanged);
    textController.text = nextState;
    textController.selection = TextSelection.collapsed(offset: nextState.length);
    textController.addListener(_onTextChanged);

    notifyListeners();
  }

  //TODO will be implemented way later
  void simplifyText() {
    debugPrint("ACTION: Trigger NLP / LLM Simplification engine request.");
    localDatabase.test();
  }

  void resetToDefault() {
    debugPrint("ACTION: Reverting modifications back to original OCR raw text layout.");
    _debounceTimer?.cancel();
    textController.text = _lastSavedText;
    _saveToHistory(textController.text);
  }

  bool get hasUnsavedChanges => textController.text != _lastSavedText;

  void saveDocument() {
    debugPrint("ACTION: Writing text data mutations into LocalDatabase / remote stream.");
    _debounceTimer?.cancel();
    _saveToHistory(textController.text);
    _lastSavedText = _lastUpdatedText;
    localDatabase.insertConvertedFile(
      ConvertedFile(
          id: fileId,
          fileName: fileName,
          extractedText: textController.text,
          dateConverted: DateTime.now()
      )
    );
  }

  Future<int> createDuplicateCopy(String newName) async {
    debugPrint("ACTION: Writing deep copy snapshot copy into persistence layer.");
    _debounceTimer?.cancel();
    final newId = await localDatabase.insertConvertedFile(
      ConvertedFile(
          fileName: newName,
          extractedText: textController.text,
          dateConverted: DateTime.now()
      )
    );
    return newId;
  }

  @override
  void dispose() {
    textController.removeListener(_onTextChanged);
    textController.dispose();
    super.dispose();
  }
}