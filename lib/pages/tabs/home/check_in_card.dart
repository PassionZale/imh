import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_theme.dart';
import '../../../database/models/check_in_task.dart';

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
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.9).animate(
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
    return Container(
      decoration: AppTheme.cardDecoration,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title + Button row
          Row(
            children: [
              Expanded(
                child: Text(
                  widget.task.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textMain,
                  ),
                ),
              ),
              ScaleTransition(
                scale: _scaleAnimation,
                child: ElevatedButton(
                  onPressed: _canCheckIn ? _onTap : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        _canCheckIn ? AppColors.primary : AppColors.surfaceRaised,
                    foregroundColor:
                        _canCheckIn ? Colors.white : AppColors.textMuted,
                    disabledBackgroundColor: AppColors.surfaceRaised,
                    disabledForegroundColor: AppColors.textMuted,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    minimumSize: const Size(0, 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                      side: BorderSide(
                        color: _canCheckIn
                            ? AppColors.primary
                            : AppColors.borderDefault,
                      ),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    _buttonText,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Days counter with animation
          TweenAnimationBuilder<int>(
            tween: IntTween(begin: 0, end: widget.totalDays),
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOutCubic,
            builder: (context, value, child) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    '$value',
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textMain,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    '天',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    '已坚持',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
