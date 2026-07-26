import "package:flutter/material.dart";

class ReturnButton extends StatelessWidget {
  // 1. Make the callback optional and final for stateless immutability
  final void Function(BuildContext context)? onReturn;

  const ReturnButton({
    super.key,
    this.onReturn,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (onReturn != null) {
          onReturn!(context);
        } else {
          Navigator.pop(context); // Default native fallback
        }
      },
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(12),
        backgroundColor: Colors.grey[300],
        foregroundColor: Colors.black54,
        elevation: 2, // Minor shadow adjustment matching ReadingScreen layouts
      ),
      child: const Icon(Icons.arrow_back, size: 28),
    );
  }
}