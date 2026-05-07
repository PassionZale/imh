import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import '../../../theme/app_page_route.dart';
import '../../../database/models/check_in_task.dart';
import '../../home/check_in/check_in_record_list_page.dart';

class CheckInCard extends StatefulWidget {
  final CheckInTask task;
  final int todayCount;
  final int totalDays;
  final VoidCallback onCheckIn;

  const CheckInCard({
    super.key,
    required this.task,
    required this.todayCount,
    required this.totalDays,
    required this.onCheckIn,
  });

  @override
  State<CheckInCard> createState() => _CheckInCardState();
}

class _CheckInCardState extends State<CheckInCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  bool get _canCheckIn => widget.todayCount < widget.task.frequency;

  String get _buttonText {
    if (widget.todayCount == 0) return '打卡';
    if (widget.task.frequency == 1) return '已打卡';
    if (!_canCheckIn) {
      return '已完成 ${widget.todayCount}/${widget.task.frequency}';
    }
    return '打卡 ${widget.todayCount}/${widget.task.frequency}';
  }

  Future<void> _onTap() async {
    if (!_canCheckIn) return;
    await _scaleController.forward();
    await _scaleController.reverse();
    widget.onCheckIn();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          AppPageRoute(builder: (_) => CheckInRecordListPage(task: widget.task)),
        );
      },
      child: Container(
        decoration: AppTheme.cardDecoration(context),
        padding: EdgeInsets.all(AppTheme.spacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(widget.task.title, style: textTheme.titleLarge),
                ),
                ScaleTransition(
                  scale: _scaleAnimation,
                  child: ElevatedButton(
                    onPressed: _canCheckIn ? _onTap : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          _canCheckIn ? colorScheme.primary : colorScheme.surfaceContainerHighest,
                      foregroundColor:
                          _canCheckIn ? colorScheme.onPrimary : colorScheme.onSurfaceVariant,
                      disabledBackgroundColor: colorScheme.surfaceContainerHighest,
                      disabledForegroundColor: colorScheme.onSurfaceVariant,
                      padding: EdgeInsets.symmetric(
                        horizontal: AppTheme.spacing.md + AppTheme.spacing.xs,
                        vertical: 10,
                      ),
                      minimumSize: const Size(0, 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppTheme.radius.md),
                        side: BorderSide(
                          color: _canCheckIn
                              ? colorScheme.primary
                              : colorScheme.outline,
                        ),
                      ),
                      elevation: 0,
                    ),
                    child: Text(_buttonText),
                  ),
                ),
              ],
            ),
            SizedBox(height: AppTheme.spacing.md),
            TweenAnimationBuilder<int>(
              tween: IntTween(begin: 0, end: widget.totalDays),
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeOutCubic,
              builder: (context, value, child) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text('$value', style: textTheme.displayLarge),
                    SizedBox(width: AppTheme.spacing.xs),
                    Text('天', style: textTheme.bodyLarge?.copyWith(color: colorScheme.onSurfaceVariant)),
                    SizedBox(width: AppTheme.spacing.xs),
                    Text('已坚持', style: textTheme.labelLarge?.copyWith(color: colorScheme.onSurfaceVariant)),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
