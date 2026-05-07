import 'package:flutter/material.dart';
import 'package:imh/theme/app_theme.dart';

/// CardWidget component for grouping related content
class CardWidget extends StatelessWidget {
  final String? title;
  final VoidCallback? onTap;
  final Widget child;

  const CardWidget({
    super.key,
    this.title,
    this.onTap,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final cardContent = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Padding(
            padding: EdgeInsets.fromLTRB(
              AppTheme.spacing.lg,
              AppTheme.spacing.lg,
              AppTheme.spacing.lg,
              AppTheme.spacing.md,
            ),
            child: Text(title!, style: textTheme.headlineMedium),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: AppTheme.spacing.lg),
            child: Divider(height: 1, color: colorScheme.outline),
          ),
        ],
        Padding(
          padding: EdgeInsets.only(
            left: AppTheme.spacing.lg,
            right: AppTheme.spacing.lg,
            top: title == null ? AppTheme.spacing.lg : AppTheme.spacing.md,
            bottom: AppTheme.spacing.lg,
          ),
          child: child,
        ),
      ],
    );

    return Container(
      decoration: AppTheme.cardDecoration(context),
      child: onTap != null
          ? InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(AppTheme.radius.md),
              child: cardContent,
            )
          : cardContent,
    );
  }
}
