import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';

/// CardWidget component for grouping related content
///
/// Features:
/// - Optional title displayed at the top
/// - Optional tap handler for entire card
/// - Uses AppTheme.cardDecoration for consistent styling
class CardWidget extends StatelessWidget {
  /// Optional title to display at the top of the card
  final String? title;

  /// Optional callback when the card is tapped
  final VoidCallback? onTap;

  /// The content to display inside the card
  final Widget child;

  const CardWidget({
    super.key,
    this.title,
    this.onTap,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final cardContent = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
            child: Text(
              title!,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1F2937),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Divider(height: 1, color: Color(0xFFE5E7EB)),
          ),
        ],
        Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: title == null ? 24 : 16,
            bottom: 24,
          ),
          child: child,
        ),
      ],
    );

    return Container(
      decoration: AppTheme.cardDecoration,
      child: onTap != null
          ? InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(AppTheme.radiusMd),
              child: cardContent,
            )
          : cardContent,
    );
  }
}
