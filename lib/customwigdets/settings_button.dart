import "package:flutter/material.dart";
import "package:nodyslexia/modules/settings_screen.dart";

class SettingButton extends StatelessWidget {
  const SettingButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const SettingsScreen()),
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