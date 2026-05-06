import 'package:flutter/material.dart';

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
    final colorScheme = Theme.of(context).colorScheme;

    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 56),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 16,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              color: colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
