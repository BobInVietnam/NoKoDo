// modules/editing/editing_screen.dart
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:nodyslexia/customwigdets/return_button.dart';
import 'package:nodyslexia/customwigdets/settings_button.dart';

// Import your ViewModel
import 'package:nodyslexia/modules/editing/editing_viewmodel.dart';

class EditingScreen extends StatelessWidget {
  const EditingScreen({super.key});

  void _showRenameDialog(BuildContext context, EditingViewModel viewModel) {
    // Local controller initialized with current filename to track typing context
    final TextEditingController renameController =
    TextEditingController(text: viewModel.fileName);

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text(
            'Đổi tên tập tin',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal),
          ),
          content: TextField(
            controller: renameController,
            autofocus: true,
            decoration: const InputDecoration(
              labelText: 'Tên tập tin mới',
              hintText: 'Nhập tên...',
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.teal, width: 2),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext), // Close dialog safely
              child: Text('Hủy', style: TextStyle(color: Colors.grey[600])),
            ),
            ElevatedButton(
              onPressed: () {
                final String trimmedName = renameController.text.trim();
                if (trimmedName.isNotEmpty) {
                  // Pass the new name string parameter straight to the viewmodel controller
                  viewModel.renameFile(trimmedName);
                }
                Navigator.pop(dialogContext); // Close dialog overlay
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
              child: const Text('Xác nhận', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final viewModel = context.watch<EditingViewModel>();
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    return Scaffold(
      // Matching the clean layout background of ReadingScreen
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            // --- Top Menu Bar: File Info & Actions ---
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      "Đang chỉnh sửa: ${viewModel.fileName}",
                      style: textTheme.displayMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.edit_note_outlined),
                    label: const Text('Đổi tên'),
                    onPressed: () => _showRenameDialog(context, viewModel),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.undo, color: viewModel.canUndo ? Colors.teal : Colors.grey),
                    onPressed: viewModel.canUndo ? viewModel.undoAction : null,
                  ),
                  IconButton(
                    icon: Icon(Icons.redo, color: viewModel.canRedo ? Colors.teal : Colors.grey),
                    onPressed: viewModel.canRedo ? viewModel.redoAction : null,
                  ),
                ],
              ),
            ),

            // --- Central Editing Area Box (Cloned perfectly from ReadingScreen structure) ---
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
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
                  child: TextField(
                    controller: viewModel.textController,
                    maxLines: null, // Natural multiline vertical growth mapping
                    expands: true,  // Force complete filling of Container limits
                    textAlignVertical: TextAlignVertical.top,
                    style: textTheme.bodyMedium?.copyWith(height: 1.6),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                      hintText: 'Nhập văn bản chỉnh sửa...',
                    ),
                  ),
                ),
              ),
            ),

            // --- Bottom Navigation & Control Action Row ---
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 16),
                  // Core Nav Bar: (Return Button, Action Pill, Settings Button)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      ReturnButton(
                        onReturn: (context) async {
                          final updatedFile = await viewModel.getUpdatedFile();
                          if (context.mounted) {
                            Navigator.pop(context, updatedFile);
                          } else {
                            scaffoldMessenger.showSnackBar(const SnackBar(content: Text('Không thể xử lý ảnh.')));
                          }
                        },
                      ),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.save_as_outlined),
                        label: const Text('Trở về ban đầu'),
                        onPressed: viewModel.resetToDefault,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        ),
                      ),
                      // Central Action Pill (Mirrors the prominent placement of Read All / Stop)
                      ElevatedButton.icon(
                        icon: const Icon(Icons.save_as_outlined),
                        label: const Text('Lưu lại'),
                        onPressed: viewModel.saveDocument,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        ),
                      ),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.save_as_outlined),
                        label: const Text('Lưu thành bản sao'),
                        onPressed: viewModel.createDuplicateCopy,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        ),
                      ),

                      const SettingButton()
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