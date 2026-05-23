import 'package:flutter/material.dart';
import '../constants/swipe_constants.dart';

/// Action buttons for manual swiping
///
/// Provides buttons for pass, like, super like, and undo actions
class ActionButtons extends StatelessWidget {
  final VoidCallback onPass;
  final VoidCallback onLike;
  final VoidCallback onSuperLike;
  final VoidCallback? onUndo;

  const ActionButtons({
    super.key,
    required this.onPass,
    required this.onLike,
    required this.onSuperLike,
    this.onUndo,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Undo button
        _buildActionButton(
          icon: Icons.undo,
          color: Colors.amber,
          size: SwipeConstants.smallActionButtonSize,
          onPressed: onUndo,
        ),
        const SizedBox(width: 20),

        // Pass button
        _buildActionButton(
          icon: Icons.close,
          color: Color(SwipeConstants.passColor),
          size: SwipeConstants.actionButtonSize,
          onPressed: onPass,
        ),
        const SizedBox(width: 20),

        // Super Like button (Save to Watchlist)
        _buildActionButton(
          icon: Icons.star,
          color: Color(SwipeConstants.superLikeColor),
          size: SwipeConstants.smallActionButtonSize,
          onPressed: onSuperLike,
        ),
        const SizedBox(width: 20),

        // Like button
        _buildActionButton(
          icon: Icons.favorite,
          color: Color(SwipeConstants.likeColor),
          size: SwipeConstants.actionButtonSize,
          onPressed: onLike,
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required double size,
    VoidCallback? onPressed,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, color: onPressed != null ? color : Colors.grey),
        iconSize: size * 0.5,
        onPressed: onPressed,
      ),
    );
  }
}
