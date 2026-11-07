import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:nodyslexia/customwigdets/menu_button.dart';
import 'package:nodyslexia/customwigdets/return_button.dart';
import 'package:nodyslexia/customwigdets/settings_button.dart';
import 'package:nodyslexia/data/persistence.dart';
import 'package:nodyslexia/device_size.dart';
import 'package:nodyslexia/modules/practice/unit/practice_categories_screen.dart';

import 'package:flutter/widget_previews.dart';
import 'package:nodyslexia/modules/tools/file_to_text/file_to_text_screen.dart';
import 'package:nodyslexia/modules/tools/file_to_text/file_to_text_viewmodel.dart';
import 'package:nodyslexia/modules/tools/simplifier/simplifier_screen.dart';
import 'package:nodyslexia/modules/tools/simplifier/simplifier_viewmodel.dart';
import 'package:nodyslexia/utils/ocr_service.dart';
import 'package:nodyslexia/utils/simplifier_service.dart';
import 'package:provider/provider.dart';

class ToolsNavigationScreen extends StatelessWidget {
  final _secureStorage = const FlutterSecureStorage();
  final String _token;
  const ToolsNavigationScreen({super.key, token}) : _token = token;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final buttons = <Widget>[
      MenuButton(
          icon: Icons.camera_alt_outlined,
          label: 'Chuyển ảnh sang văn bản',
          verticalPadding: 60,
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChangeNotifierProvider(
                create: (context) => FileToTextViewModel(
                  ocrService: LocalOCRService(token: _token),
                  localDatabase: context.read<LocalDatabase>()),
                child:  const FileToTextScreen()
              ),
            )
          ),
      ),
      MenuButton(
        icon: Icons.abc_outlined,
        label: 'Đơn giản hóa câu từ',
        verticalPadding: 60,
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ChangeNotifierProvider(
              create: (context) => SimplifierViewModel(
                simplifierService: LocalSimplifierService(token: _token)),
              child: const SimplifierScreen()),
            )
          ),
        ),
    ];

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 30.0, bottom: 16.0),
              child: Text('Công cụ', style: textTheme.displayLarge),
            ),
            Expanded(
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                  child: Column(children: buttons)
              )
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[ReturnButton()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// @Preview()
// Widget preview() {
//   return LessonOrCategoryScreen();
// }