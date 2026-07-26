import 'package:flutter/material.dart';
import 'package:nodyslexia/utils/simplifier_service.dart';

class SimplifierViewModel extends ChangeNotifier {
  final SimplifierService simplifierService;

  String _inputText = '';
  String _simplifiedText = '';
  bool _isLoading = false;

  SimplifierViewModel({required this.simplifierService});

  String get inputText => _inputText;
  String get simplifiedText => _simplifiedText;
  bool get isLoading => _isLoading;

  void setInputText(String text) {
    _inputText = text;
    notifyListeners();
  }

  void clearInput() {
    _inputText = '';
    notifyListeners();
  }

  Future<void> simplify() async {
    if (_inputText.trim().isEmpty) return;

    _isLoading = true;
    _simplifiedText = '';
    notifyListeners();

    try {
      final result = await simplifierService.simplifyText(_inputText);
      if (result != null) {
        _simplifiedText = result;
      } else {
        _simplifiedText = "Không thể kết nối đến máy chủ hoặc xảy ra lỗi.";
      }
    } catch (e) {
      _simplifiedText = "Đã xảy ra lỗi khi đơn giản hóa: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
