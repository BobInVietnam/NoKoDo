// modules/editing/editing_screen.dart
import 'package:flutter/material.dart';
import 'package:nodyslexia/data/repository_manager.dart';
import 'package:provider/provider.dart';
import 'package:nodyslexia/customwigdets/return_button.dart';
import 'package:nodyslexia/customwigdets/settings_button.dart';

// Import your ViewModel
import 'package:nodyslexia/modules/editing/editing_viewmodel.dart';

import '../../device_size.dart';

class EditingScreen extends StatelessWidget {
  const EditingScreen({super.key});

  void _showRenameDialog(BuildContext context, EditingViewModel viewModel) {
    // Local controller initialized with current filename to track typing context
    final TextEditingController renameController = TextEditingController(
      text: viewModel.fileName,
    );

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
              onPressed:
                  () => Navigator.pop(dialogContext), // Close dialog safely
              child: Text('Hủy', style: const TextStyle(color: Colors.black87)),
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
              child: const Text(
                'Xác nhận',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<bool> _showExitConfirmation(BuildContext context) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Rời khỏi màn hình?'),
          content: const Text(
            'Bạn có những thay đổi chưa được lưu. Rời đi sẽ mất các thay đổi này.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: Text('Hủy', style: const TextStyle(color: Colors.black87)),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text(
                'Rời đi',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
    return result ?? false;
  }

  void _showSaveAsCopyDialog(BuildContext context, EditingViewModel viewModel) {
    final TextEditingController renameController = TextEditingController(
      text: '${viewModel.fileName} - Bản sao',
    );

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text(
            'Lưu thành bản sao',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal),
          ),
          content: TextField(
            controller: renameController,
            autofocus: true,
            decoration: const InputDecoration(
              labelText: 'Tên bản sao mới',
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.teal, width: 2),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text('Hủy', style: const TextStyle(color: Colors.black87)),
            ),
            ElevatedButton(
              onPressed: () async {
                final String trimmedName = renameController.text.trim();
                if (trimmedName.isNotEmpty) {
                  await viewModel.createDuplicateCopy(trimmedName);
                  if (context.mounted) {
                    Navigator.pop(dialogContext); // Close naming dialog
                    showDialog(
                      context: context,
                      builder: (BuildContext successContext) {
                        return AlertDialog(
                          title: const Text('Thành công'),
                          content: const Text(
                            'Bản sao đã được lưu thành công vào thư viện!',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(successContext),
                              child: const Text('Đồng ý'),
                            ),
                          ],
                        );
                      },
                    );
                  }
                }
              },
              child: const Text(
                'Lưu bản sao',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showSaveToServerDialog(BuildContext context, EditingViewModel viewModel) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final repoManager = context.read<RepoManager>();
    final messenger = ScaffoldMessenger.of(context);
    bool isLoading = false;
    bool obscurePassword = true;
    String? errorText;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (_, setState) {
            return AlertDialog(
              title: const Text(
                'Lưu trên hệ thống',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal),
              ),
              content: SizedBox(
                width: 400,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: emailController,
                      enabled: !isLoading,
                      autofocus: true,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: passwordController,
                      enabled: !isLoading,
                      obscureText: obscurePassword,
                      decoration: InputDecoration(
                        labelText: 'Mật khẩu',
                        border: const OutlineInputBorder(),
                        errorText: errorText,
                        suffixIcon: IconButton(
                          icon: Icon(obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility),
                          onPressed: () =>
                              setState(() => obscurePassword = !obscurePassword),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: isLoading ? null : () => Navigator.pop(dialogContext),
                  child: const Text('Đóng', style: TextStyle(color: Colors.black87)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                  onPressed: isLoading
                      ? null
                      : () async {
                    final email = emailController.text.trim();
                    final password = passwordController.text;
                    if (email.isEmpty || password.isEmpty) {
                      setState(() => errorText = 'Vui lòng nhập email và mật khẩu');
                      return;
                    }

                    setState(() {
                      isLoading = true;
                      errorText = null;
                    });

                    String message;
                    try {
                      await repoManager.sendCustomLesson(
                        viewModel.toConvertedFile(),
                        email,
                        password,
                      );
                      message = 'Đã lưu bài học lên hệ thống!';
                    } catch (e) {
                      message = 'Lỗi: $e';
                    }

                    if (dialogContext.mounted) Navigator.pop(dialogContext);
                    messenger.showSnackBar(SnackBar(content: Text(message)));
                  },
                  child: isLoading
                      ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                      : const Text('Xác nhận', style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        );
      },
    ).then((_) {
      emailController.dispose();
      passwordController.dispose();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = getSize(context);
    final isSmall =
        screenSize == ScreenSize.Compact || screenSize == ScreenSize.Medium;
    debugPrint("SCREENSIZE: editing_screen screen size: $screenSize");
    final textTheme = Theme.of(context).textTheme;
    final viewModel = context.watch<EditingViewModel>();
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    bool isKeyboardOpen = MediaQuery.viewInsetsOf(context).bottom > 0;

    return PopScope(
      canPop: !viewModel.hasUnsavedChanges,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldPop = await _showExitConfirmation(context);
        if (shouldPop && context.mounted) {
          final updatedFile = await viewModel.getUpdatedFile();
          if (context.mounted) {
            Navigator.pop(context, updatedFile);
          }
        }
      },
      child: Scaffold(
        // Matching the clean layout background of ReadingScreen
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(
          child: Column(
            children: <Widget>[
              // --- Top Menu Bar: File Info & Actions ---
              isKeyboardOpen
                  ? Container()
                  : Padding(
                    padding: const EdgeInsets.only(
                      left: 16.0,
                      right: 16.0,
                      top: 16.0,
                    ),
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
                          onPressed:
                              () => _showRenameDialog(context, viewModel),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.undo,
                            color:
                                viewModel.canUndo ? Colors.teal : Colors.grey,
                          ),
                          onPressed:
                              viewModel.canUndo ? viewModel.undoAction : null,
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.redo,
                            color:
                                viewModel.canRedo ? Colors.teal : Colors.grey,
                          ),
                          onPressed:
                              viewModel.canRedo ? viewModel.redoAction : null,
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
                          color: Colors.grey.withValues(alpha: 0.1),
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: viewModel.textController,
                      maxLines:
                          null, // Natural multiline vertical growth mapping
                      expands:
                          true, // Force complete filling of Container limits
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
                            if (viewModel.hasUnsavedChanges) {
                              final shouldPop = await _showExitConfirmation(
                                context,
                              );
                              if (shouldPop && context.mounted) {
                                final updatedFile =
                                    await viewModel.getUpdatedFile();
                                if (context.mounted) {
                                  Navigator.pop(context, updatedFile);
                                }
                              }
                            } else {
                              final updatedFile =
                                  await viewModel.getUpdatedFile();
                              if (context.mounted) {
                                Navigator.pop(context, updatedFile);
                              }
                            }
                          },
                        ),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.restore),
                          label: Text(isSmall ? "" : 'Trở về ban đầu'),
                          onPressed: () async {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (BuildContext dialogContext) {
                                return AlertDialog(
                                  title: const Text('Trở về ban đầu?'),
                                  content: const Text(
                                    'Bạn có chắc chắn muốn hủy mọi thay đổi và quay về nội dung ban đầu?',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed:
                                          () => Navigator.pop(
                                            dialogContext,
                                            false,
                                          ),
                                      child: Text(
                                        'Hủy',
                                        style: const TextStyle(
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed:
                                          () => Navigator.pop(
                                            dialogContext,
                                            true,
                                          ),
                                      child: const Text(
                                        'Đồng ý',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                            if (confirm == true) {
                              viewModel.resetToDefault();
                            }
                          },
                        ),
                        // Central Action Pill (Mirrors the prominent placement of Read All / Stop)
                        ElevatedButton.icon(
                          icon: const Icon(Icons.save_as_outlined),
                          label: Text(isSmall ? "" : 'Lưu lại'),
                          onPressed: () {
                            viewModel.saveDocument();
                            showDialog(
                              context: context,
                              builder: (BuildContext dialogContext) {
                                return AlertDialog(
                                  title: const Text('Lưu tài liệu'),
                                  content: const Text(
                                    'Tài liệu đã được lưu thành công!',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed:
                                          () => Navigator.pop(dialogContext),
                                      child: const Text('Đồng ý'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.copy_outlined),
                          label: Text(isSmall ? "" : 'Lưu thành bản sao'),
                          onPressed:
                              () => _showSaveAsCopyDialog(context, viewModel),
                        ),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.cloud_upload_outlined),
                          label: Text(isSmall ? "" : 'Lưu trên hệ thống'),
                          onPressed: () => _showSaveToServerDialog(context, viewModel),
                        ),
                        SettingButton(),
                      ],
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
