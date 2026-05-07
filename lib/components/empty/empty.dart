import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

/// Empty state widget for displaying when no data is available
class EmptyWidget extends StatelessWidget {
  final IconData icon;
  final String message;

  const EmptyWidget({
    super.key,
    this.icon = Icons.inbox_outlined,
    this.message = '暂无数据',
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: colorScheme.onSurfaceVariant),
          SizedBox(height: AppTheme.spacing.md),
          Text(
            message,
            style: textTheme.bodyLarge?.copyWith(color: colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}
