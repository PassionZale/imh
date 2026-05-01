import 'package:flutter/material.dart';
import '../../../../theme/app_colors.dart';

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text(
            '$year年$month月',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textMain,
            ),
          ),
        ),
        _buildWeekHeader(),
        const SizedBox(height: 8),
        ..._buildWeekRows(),
      ],
    );
  }

  Widget _buildWeekHeader() {
    const labels = ['日', '一', '二', '三', '四', '五', '六'];
    return Row(
      children: labels.map((label) {
        return Expanded(
          child: Center(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textMuted,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  List<Widget> _buildWeekRows() {
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
        ),
      ));

      if (cells.length == 7) {
        rows.add(const SizedBox(height: 8));
        rows.add(Row(children: List.from(cells)));
        cells.clear();
      }
    }

    // Pad last row
    if (cells.isNotEmpty) {
      while (cells.length < 7) {
        cells.add(const Expanded(child: SizedBox.shrink()));
      }
      rows.add(const SizedBox(height: 8));
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

  const _DayCell({
    required this.day,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isCompleted ? AppColors.primary : Colors.transparent,
        ),
        alignment: Alignment.center,
        child: Text(
          '$day',
          style: TextStyle(
            fontSize: 14,
            fontWeight: isCompleted ? FontWeight.w600 : FontWeight.normal,
            color: isCompleted ? Colors.white : AppColors.textMain,
          ),
        ),
      ),
    );
  }
}
