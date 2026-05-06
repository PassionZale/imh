import 'package:flutter/material.dart';

/// Empty state widget for displaying when no data is available
///
/// Features:
/// - Centered icon and message layout
/// - Customizable icon and message
/// - Default "no data" display
class EmptyWidget extends StatelessWidget {
  /// The icon to display (defaults to Icons.inbox_outlined)
  final IconData icon;

  /// The message to display below the icon
  final String message;

  const EmptyWidget({
    super.key,
    this.icon = Icons.inbox_outlined,
    this.message = '暂无数据',
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: colorScheme.onSurfaceVariant),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 16,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
