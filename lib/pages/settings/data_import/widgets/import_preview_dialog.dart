import 'package:flutter/material.dart';
import '../../../../database/models/car_fuel_record.dart';
import '../../../../database/models/check_in_record.dart';
import '../../../../theme/app_theme.dart';

/// 显示导入预览对话框
///
/// 返回 true 表示用户确认导入，false 表示取消
Future<bool> showImportPreviewDialog({
  required BuildContext context,
  required String importTypeLabel,
  required List<CarFuelRecord> fuelRecords,
  required List<CheckInRecord> checkinRecords,
}) {
  final isFuel = fuelRecords.isNotEmpty;
  final count = isFuel ? fuelRecords.length : checkinRecords.length;

  return showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('确认导入'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('解析成功，共 $count 条记录'),
          SizedBox(height: AppTheme.spacing.md),
          const Text('前 3 条预览：'),
          SizedBox(height: AppTheme.spacing.sm),
          ..._buildPreviewItems(isFuel, fuelRecords, checkinRecords),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('取消'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('确认导入'),
        ),
      ],
    ),
  ).then((value) => value ?? false);
}

List<Widget> _buildPreviewItems(
  bool isFuel,
  List<CarFuelRecord> fuelRecords,
  List<CheckInRecord> checkinRecords,
) {
  final count = isFuel ? fuelRecords.length : checkinRecords.length;
  final previewCount = count > 3 ? 3 : count;

  if (isFuel) {
    return List.generate(previewCount, (i) {
      final r = fuelRecords[i];
      return Padding(
        padding: EdgeInsets.only(bottom: AppTheme.spacing.xs),
        child: Text(
          '${r.date}  ${r.liters.toStringAsFixed(1)}L  '
          '${r.totalCost.toStringAsFixed(1)}元  ${r.mileage}km',
          style: const TextStyle(fontSize: 12),
        ),
      );
    });
  } else {
    return List.generate(previewCount, (i) {
      final r = checkinRecords[i];
      return Padding(
        padding: EdgeInsets.only(bottom: AppTheme.spacing.xs),
        child: Text(
          r.date,
          style: const TextStyle(fontSize: 12),
        ),
      );
    });
  }
}
