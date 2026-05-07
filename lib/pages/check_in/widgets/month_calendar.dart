import 'package:flutter/material.dart';
import 'package:imh/theme/app_theme.dart';

class MonthCalendar extends StatelessWidget {
  final int year;
  final int month;
  final Map<String, int> dateCountMap;
  final int frequency;

  const MonthCalendar({
    super.key,
    required this.year,
    required this.month,
    required this.dateCountMap,
    required this.frequency,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: AppTheme.spacing.sm),
          child: Text(
            '$year年$month月',
            style: textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
        ),
        _buildWeekHeader(colorScheme, textTheme),
        SizedBox(height: AppTheme.spacing.sm),
        ..._buildWeekRows(colorScheme, textTheme),
      ],
    );
  }

  Widget _buildWeekHeader(ColorScheme colorScheme, TextTheme textTheme) {
    const labels = ['日', '一', '二', '三', '四', '五', '六'];
    return Row(
      children: labels.map((label) {
        return Expanded(
          child: Center(
            child: Text(
              label,
              style: textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  List<Widget> _buildWeekRows(ColorScheme colorScheme, TextTheme textTheme) {
    final firstDay = DateTime(year, month, 1);
    final daysInMonth = DateTime(year, month + 1, 0).day;
    final startWeekday = firstDay.weekday % 7; // Sunday = 0
    final rows = <Widget>[];
    final cells = <Widget>[];

    // Empty cells before first day
    for (int i = 0; i < startWeekday; i++) {
      cells.add(const Expanded(child: SizedBox.shrink()));
    }

    for (int day = 1; day <= daysInMonth; day++) {
      final dateStr = _formatDate(DateTime(year, month, day));
      final count = dateCountMap[dateStr] ?? 0;
      final isCompleted = count >= frequency;

      cells.add(Expanded(
        child: _DayCell(
          day: day,
          isCompleted: isCompleted,
          colorScheme: colorScheme,
          textTheme: textTheme,
        ),
      ));

      if (cells.length == 7) {
        rows.add(SizedBox(height: AppTheme.spacing.sm));
        rows.add(Row(children: List.from(cells)));
        cells.clear();
      }
    }

    // Pad last row
    if (cells.isNotEmpty) {
      while (cells.length < 7) {
        cells.add(const Expanded(child: SizedBox.shrink()));
      }
      rows.add(SizedBox(height: AppTheme.spacing.sm));
      rows.add(Row(children: List.from(cells)));
    }

    return rows;
  }

  String _formatDate(DateTime date) {
    return '${date.year.toString().padLeft(4, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }
}

class _DayCell extends StatelessWidget {
  final int day;
  final bool isCompleted;
  final ColorScheme colorScheme;
  final TextTheme textTheme;

  const _DayCell({
    required this.day,
    required this.isCompleted,
    required this.colorScheme,
    required this.textTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: AppTheme.spacing.xl,
        height: AppTheme.spacing.xl,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isCompleted ? colorScheme.primary : Colors.transparent,
        ),
        alignment: Alignment.center,
        child: Text(
          '$day',
          style: textTheme.labelLarge?.copyWith(
            fontWeight: isCompleted ? FontWeight.w600 : FontWeight.normal,
            color: isCompleted ? colorScheme.onPrimary : colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}
