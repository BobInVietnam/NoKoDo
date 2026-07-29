import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:nodyslexia/customwigdets/return_button.dart';
import 'package:nodyslexia/customwigdets/settings_button.dart';
import 'package:nodyslexia/modules/simplifier/simplifier_viewmodel.dart';

class SimplifierScreen extends StatefulWidget {
  const SimplifierScreen({super.key});

  @override
  State<SimplifierScreen> createState() => _SimplifierScreenState();
}

class _SimplifierScreenState extends State<SimplifierScreen> {
  late final TextEditingController _inputController;

  @override
  void initState() {
    super.initState();
    _inputController = TextEditingController();
    // Keep text field in sync with viewmodel if changed
    _inputController.addListener(() {
      context.read<SimplifierViewModel>().setInputText(_inputController.text);
    });
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  void _copyToClipboard(String text) {
    if (text.isEmpty) return;
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Đã sao chép kết quả vào bộ nhớ tạm!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<SimplifierViewModel>();
    final textTheme = Theme.of(context).textTheme;

    // Sync from viewmodel text if needed (e.g. if cleared)
    if (viewModel.inputText != _inputController.text) {
      _inputController.text = viewModel.inputText;
    }

    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // Title "Đơn giản hóa câu từ"
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Text(
                  'Đơn giản hóa câu từ',
                  style: textTheme.displayLarge,
                  textAlign: TextAlign.center,
                ),
              ),

              // Side-by-side Input and Output Panel
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Left Box (Input Panel)
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.blueAccent.withOpacity(0.5), width: 2),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _inputController,
                                maxLines: null,
                                decoration: const InputDecoration(
                                  hintText: 'Câu chưa được đơn giản hóa được viết ở đây',
                                  border: InputBorder.none,
                                ),
                                style: textTheme.bodyMedium,
                              ),
                            ),
                            if (viewModel.inputText.isNotEmpty)
                              Align(
                                alignment: Alignment.bottomRight,
                                child: TextButton.icon(
                                  icon: const Icon(Icons.clear, size: 18),
                                  label: const Text('Xóa'),
                                  onPressed: () {
                                    viewModel.clearInput();
                                  },
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),

                    // Central Arrow Icon/Button
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Center(
                        child: Container(
                          width: 60,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.blueAccent.withOpacity(0.5), width: 2),
                          ),
                          child: Center(
                            child: IconButton(
                              icon: const Icon(Icons.arrow_forward, size: 32, color: Colors.black87),
                              onPressed: () => viewModel.simplify(),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Right Box (Output Panel)
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.blueAccent.withOpacity(0.5), width: 2),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: viewModel.isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Expanded(
                                    child: SingleChildScrollView(
                                      child: SelectionArea(
                                        child: Text(
                                          viewModel.simplifiedText.isNotEmpty
                                              ? viewModel.simplifiedText
                                              : 'Câu đã được đơn giản hóa',
                                          style: textTheme.bodyMedium!.copyWith(
                                            color: viewModel.simplifiedText.isNotEmpty
                                                ? Colors.grey[700] : Colors.grey[400]
                                          )
                                        ),
                                      ),
                                    ),
                                  ),
                                  if (viewModel.simplifiedText.isNotEmpty)
                                    Align(
                                      alignment: Alignment.bottomRight,
                                      child: ElevatedButton.icon(
                                        onPressed: () => _copyToClipboard(viewModel.simplifiedText),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.teal[50],
                                          foregroundColor: Colors.teal[800],
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                        ),
                                        icon: const Icon(Icons.copy, size: 16),
                                        label: const Text('Sao chép kết quả'),
                                      ),
                                    ),
                                ],
                              ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Bottom Navigation & Actions Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const ReturnButton(),
                  ElevatedButton(
                    onPressed: viewModel.isLoading ? null : () => viewModel.simplify(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal[600],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(color: Colors.green, width: 2),
                      ),
                    ),
                    child: Text(
                      'Đơn giản hóa câu',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SettingButton(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
