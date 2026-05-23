import 'package:flutter/material.dart';

/// Skip button for onboarding screens
class SkipButton extends StatelessWidget {
  final VoidCallback onSkip;
  final String label;

  const SkipButton({
    super.key,
    required this.onSkip,
    this.label = 'Пропустить',
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onSkip,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label),
          const SizedBox(width: 4),
          const Icon(Icons.arrow_forward, size: 16),
        ],
      ),
    );
  }
}
