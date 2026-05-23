import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class SelectionTestScreen extends StatefulWidget {
  const SelectionTestScreen({super.key});

  @override
  State<SelectionTestScreen> createState() => _SelectionTestScreenState();
}

class _SelectionTestScreenState extends State<SelectionTestScreen> {
  String _collectedText = "Chưa có đoạn chữ nào được chọn";

  // Dummy function mimicking your text processing framework actions
  void _processSelectedText(String text) {
    setState(() {
      _collectedText = text.isEmpty ? "Lựa chọn trống" : text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SelectionArea Testing Scene'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Instructional Label
              Text(
                "Thử nghiệm bôi đen đoạn chữ dưới đây:",
                style: TextStyle(fontSize: 16, color: Colors.grey[600], fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              // --- The Selection Test Zone ---
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.teal.shade200, width: 1.5),
                  ),
                  child: SingleChildScrollView(
                    child: SelectionArea(
                      onSelectionChanged: (SelectedContent? content) {
                        if (content != null) {
                          // Collects the plaintext representation of the highlighted matrices
                          _processSelectedText(content.plainText);
                        }
                      },
                      child: const Text(
                        "Chuyện kể rằng: vào đời Hùng Vương thứ 6, ở làng Gióng có hai vợ chồng ông lão chăm làm ăn và có tiếng là phúc đức. Hai ông bà ao ước có một đứa con. "
                            "Một hôm bà ra đồng trông thấy một vết chân to quá, liền đặt bàn chân mình lên ướm thử để xem thua kém bao nhiêu.\n\n"
                            "Không ngờ về nhà bà thụ thai và mười hai tháng sau sinh một thằng bé mặt mũi rất khôi ngô. Hai vợ chồng mừng lắm. "
                            "Nhưng lạ thay! Ðứa trẻ cho đến khi lên ba vẫn không biết nói, biết cười, cũng chẳng biết đi, cứ đặt đâu thì nằm đấy.",
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontSize: 20,
                          height: 1.6,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // --- Output Verification Board ---
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[400]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.analytics_outlined, color: Colors.teal),
                        SizedBox(width: 8),
                        Text(
                          "Dữ liệu nhận diện (Output Callback Data):",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _collectedText,
                      style: TextStyle(
                        fontSize: 16,
                        color: _collectedText.startsWith("Chưa") ? Colors.grey : Colors.teal[900],
                        fontStyle: _collectedText.startsWith("Chưa") ? FontStyle.italic : FontStyle.normal,
                      ),
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}