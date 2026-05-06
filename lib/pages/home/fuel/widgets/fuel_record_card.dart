import 'package:flutter/material.dart';
import '../../../../database/models/car_fuel_record.dart';

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
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: isLatest ? onTap : null,
      child: Container(
        margin: const EdgeInsets.only(left: 8, right: 16, top: 6, bottom: 6),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: colorScheme.outline),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [_buildHeaderRow(context), _buildDataGrid(context), _buildFooterRow(context)],
        ),
      ),
    );
  }

  Widget _buildHeaderRow(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // 第一条记录：显示占位文案
    if (record.mileageDelta == null) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Text(
          '加满两次即可计算最新油耗',
          style: TextStyle(fontSize: 14, color: colorScheme.onSurfaceVariant),
        ),
      );
    }

    // 正常记录：显示两个核心指标
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(child: _buildMetric(context, record.consumption, 'L/100km')),
          Expanded(child: _buildMetric(context, record.costPerKm, '元/km')),
        ],
      ),
    );
  }

  Widget _buildMetric(BuildContext context, double? value, String unit) {
    final colorScheme = Theme.of(context).colorScheme;

    if (value == null) {
      return Text(
        '-',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: colorScheme.onSurface,
        ),
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          value.toStringAsFixed(2),
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: colorScheme.primary,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          unit,
          style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant),
        ),
      ],
    );
  }

  Widget _buildDataGrid(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: _buildDataItem(context, record.mileage.toString(), 'km', '车辆总里程')),
              Expanded(
                child: _buildDataItem(
                  context,
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
                  context,
                  record.liters.toStringAsFixed(2),
                  'L',
                  '加油量',
                ),
              ),
              Expanded(
                child: _buildDataItem(
                  context,
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

  Widget _buildDataItem(BuildContext context, String number, String unit, String label) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              number,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: colorScheme.onSurface,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              unit,
              style: TextStyle(
                fontSize: 12,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant),
        ),
      ],
    );
  }

  Widget _buildFooterRow(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Text(
        '+${record.mileageDelta ?? 0}km',
        style: TextStyle(fontSize: 14, color: colorScheme.onSurface),
      ),
    );
  }
}
