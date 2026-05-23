import "package:flutter/material.dart";
import "package:nodyslexia/modules/settings/settings_screen.dart";
import "package:provider/provider.dart";

import "../modules/settings/settings_viewmodel.dart";
import "../modules/settings/text_settings.dart";

class SettingButton extends StatelessWidget {
  const SettingButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChangeNotifierProvider(
              create: (context) => SettingsViewModel(
                settings: context.read<TextStyleSettings>(),
              ),
              child: const SettingsScreen(),
            ),
          ),
        )
      },
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(12),
        backgroundColor: Colors.grey[300],
        foregroundColor: Colors.black54,
      ),
      child: const Icon(
        Icons.settings,
        size: 28,
        color: Colors.black,
      )
    );
  }
}