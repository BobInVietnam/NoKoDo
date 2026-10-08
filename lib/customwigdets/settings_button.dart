import "package:flutter/material.dart";
import "package:nodyslexia/modules/settings/settings_screen.dart";
import "package:nodyslexia/utils/tts_service.dart";
import "package:provider/provider.dart";

import "../modules/settings/settings_viewmodel.dart";
import "../modules/settings/text_settings.dart";

class SettingButton extends StatelessWidget {
  final bool syncEnabled;

  const SettingButton({super.key, this.syncEnabled = true});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed:
          () => {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => ChangeNotifierProvider(
                      create:
                          (context) => SettingsViewModel(
                            settings: context.read<NokodoSettings>(),
                            ttsService: context.read<TtsService>(),
                          ),
                      child: SettingsScreen(syncEnabled: syncEnabled),
                    ),
              ),
            ),
          },
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(12),
        backgroundColor: Colors.grey[300],
        foregroundColor: Colors.black54,
      ),
      child: const Icon(Icons.settings, size: 28, color: Colors.black),
    );
  }
}
