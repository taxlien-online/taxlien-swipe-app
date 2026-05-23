import 'package:flutter/material.dart';
import '../models/state_info.dart';

/// Chip for selecting a state
class StateChip extends StatelessWidget {
  final StateInfo stateInfo;
  final bool isSelected;
  final VoidCallback onTap;

  const StateChip({
    super.key,
    required this.stateInfo,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      selected: isSelected,
      onSelected: (_) => onTap(),
      label: Text(stateInfo.name),
      avatar: isSelected
          ? const Icon(Icons.check, size: 18)
          : Text(
              stateInfo.code,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
    );
  }
}
