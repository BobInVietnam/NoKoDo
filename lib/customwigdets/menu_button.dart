import 'package:flutter/material.dart';

class MenuButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final double verticalPadding;
  final bool expand; // true inside a Row, false = full width

  const MenuButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
    this.backgroundColor = Colors.white,
    this.verticalPadding = 36.0,
    this.expand = false,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final button = Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton.icon(
        icon: Icon(icon, size: 42),
        label: Padding(
          padding: EdgeInsets.symmetric(vertical: verticalPadding, horizontal: 20.0),
          child: Text(
            label,
            style: textTheme.displayMedium,
            textAlign: TextAlign.center,
          ),
        ),
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.black,
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: const BorderSide(color: Colors.teal, width: 8),
          ),
          elevation: 3,
        ),
      ),
    );

    return expand
        ? Expanded(child: SizedBox(width: double.infinity, child: button))
        : SizedBox(width: double.infinity, child: button);
  }
}