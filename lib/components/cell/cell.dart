import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

/// CellWidget component for displaying label-value pairs in a card
///
/// Features:
/// - Left-aligned label with muted color
/// - Right-aligned value with primary color
/// - Fixed minimum height for consistency
class CellWidget extends StatelessWidget {
  /// The label text displayed on the left
  final String label;

  /// The value text displayed on the right
  final String value;

  const CellWidget({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 56),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.textMuted,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              color: AppColors.textMain,
            ),
          ),
        ],
      ),
    );
  }
}
