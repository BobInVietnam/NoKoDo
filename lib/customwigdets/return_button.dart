import "package:flutter/material.dart";

class ReturnButton extends StatelessWidget {
  const ReturnButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.pop(context); // Go back to the previous screen
      },
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(12),
        backgroundColor: Colors.grey[300],
        foregroundColor: Colors.black54,
      ),
      child: const Icon(Icons.arrow_back, size: 28),
    );
  }
}