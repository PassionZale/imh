import 'package:flutter/material.dart';
import '../../../../database/models/car_fuel_record.dart';
import '../../../../theme/app_colors.dart';

class FuelRecordCard extends StatelessWidget {
  final CarFuelRecord record;
  final bool isLatest;
  final VoidCallback? onTap;

  const FuelRecordCard({
    super.key,
    required this.record,
    required this.isLatest,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLatest ? onTap : null,
      child: Container(
        margin: const EdgeInsets.only(left: 8, right: 16, top: 6, bottom: 6),
        decoration: BoxDecoration(
          color: AppColors.surfaceBase,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.borderDefault),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [_buildHeaderRow(), _buildDataGrid(), _buildFooterRow()],
        ),
      ),
    );
  }

  Widget _buildHeaderRow() {
    // 第一条记录：显示占位文案
    if (record.mileageDelta == null) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          '加满两次即可计算最新油耗',
          style: TextStyle(fontSize: 14, color: AppColors.textMuted),
        ),
      );
    }

    // 正常记录：显示两个核心指标
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(child: _buildMetric(record.consumption, 'L/100km')),
          Expanded(child: _buildMetric(record.costPerKm, '元/km')),
        ],
      ),
    );
  }

  Widget _buildMetric(double? value, String unit) {
    if (value == null) {
      return Text(
        '-',
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.textMain,
        ),
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          value.toStringAsFixed(2),
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          unit,
          style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
        ),
      ],
    );
  }

  Widget _buildDataGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: _buildDataItem(record.mileage.toString(), 'km', '车辆总里程')),
              Expanded(
                child: _buildDataItem(
                  record.unitPrice.toStringAsFixed(2),
                  '元/L',
                  '单价',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildDataItem(
                  record.liters.toStringAsFixed(2),
                  'L',
                  '加油量',
                ),
              ),
              Expanded(
                child: _buildDataItem(
                  record.totalCost.toStringAsFixed(2),
                  '元',
                  '加油金额',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDataItem(String number, String unit, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              number,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.textMain,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              unit,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textMuted,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
        ),
      ],
    );
  }

  Widget _buildFooterRow() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Text(
        '+${record.mileageDelta ?? 0}km',
        style: const TextStyle(fontSize: 14, color: AppColors.textMain),
      ),
    );
  }
}
