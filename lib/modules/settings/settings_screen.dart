import 'package:flutter/material.dart';
import 'app_settings.dart';
import '../../customwigdets/return_button.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final settings = AppSettings.instance;

  late TextEditingController _nameController;
  late TextEditingController _classController;
  bool _isEditingInfo = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: settings.studentName);
    _classController = TextEditingController(text: settings.studentClass);
  }

  /// Lưu thông tin học sinh
  void _saveStudentInfo() async {
    settings.studentName = _nameController.text;
    settings.studentClass = _classController.text;
    await settings.save();
    setState(() => _isEditingInfo = false);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Đã lưu thông tin học sinh")));
  }

  /// Lưu cấu hình giao diện
  void _saveUISettings() async {
    await settings.save();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Đã lưu cấu hình giao diện")));
  }

  Widget _buildCard({required String title, required Widget child}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.teal, // màu chữ teal
              ),
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: DefaultTextStyle(
          style: const TextStyle(
            color: Colors.teal,
          ), // áp dụng cho toàn bộ text
          child: Column(
            children: [
              const SizedBox(height: 16),
              const Center(
                child: Text(
                  "Cài đặt",
                  style: TextStyle(
                    fontSize: 28, // to hơn
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Galindo', // font Galindo
                    color: Colors.teal,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              Expanded(
                child: ListView(
                  children: [
                    // Thông tin học sinh
                    _buildCard(
                      title: "Thông tin học sinh",
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (_isEditingInfo) ...[
                            TextField(
                              controller: _nameController,
                              decoration: const InputDecoration(
                                labelText: "Tên học sinh",
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 12),
                            TextField(
                              controller: _classController,
                              decoration: const InputDecoration(
                                labelText: "Lớp",
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ] else ...[
                            Text("Tên: ${settings.studentName}"),
                            const SizedBox(height: 6),
                            Text("Lớp: ${settings.studentClass}"),
                          ],
                          const SizedBox(height: 12),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (_isEditingInfo) ...[
                                  ElevatedButton(
                                    onPressed: _saveStudentInfo,
                                    child: const Text("Lưu"),
                                  ),
                                  const SizedBox(width: 8),
                                ],
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      _isEditingInfo = !_isEditingInfo;
                                    });
                                  },
                                  child: Text(
                                    _isEditingInfo ? "Hủy" : "Đổi thông tin",
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Cấu hình giao diện
                    _buildCard(
                      title: "Cấu hình giao diện",
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DropdownButton<AppFont>(
                            value: settings.fontFamily,
                            items:
                                AppFont.values.map((f) {
                                  return DropdownMenuItem(
                                    value: f,
                                    child: Text(f.toString().split('.').last),
                                  );
                                }).toList(),
                            onChanged: (f) {
                              if (f != null) {
                                setState(() => settings.fontFamily = f);
                                settings.save();
                              }
                            },
                          ),
                          const SizedBox(height: 20),
                          Text("Kích thước chữ: ${settings.fontSize.round()}"),
                          Slider(
                            value: settings.fontSize,
                            min: 12,
                            max: 32,
                            divisions: 10,
                            onChanged:
                                (v) => setState(() => settings.fontSize = v),
                            onChangeEnd: (_) => settings.save(),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            "Khoảng cách chữ: ${settings.letterSpacing.toStringAsFixed(1)}",
                          ),
                          Slider(
                            value: settings.letterSpacing,
                            min: 0,
                            max: 5,
                            divisions: 10,
                            onChanged:
                                (v) =>
                                    setState(() => settings.letterSpacing = v),
                            onChangeEnd: (_) => settings.save(),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            "Khoảng cách dòng: ${settings.lineSpacing.toStringAsFixed(1)}",
                          ),
                          Slider(
                            value: settings.lineSpacing,
                            min: 1,
                            max: 3,
                            divisions: 10,
                            onChanged:
                                (v) => setState(() => settings.lineSpacing = v),
                            onChangeEnd: (_) => settings.save(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Chỉ còn lưu cấu hình giao diện
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const ReturnButton(),
                    ElevatedButton(
                      onPressed: _saveUISettings,
                      child: const Text("Lưu"),
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
