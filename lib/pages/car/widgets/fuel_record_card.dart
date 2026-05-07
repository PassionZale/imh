import 'package:flutter/material.dart';
import 'package:imh/database/models/car_fuel_record.dart';
import 'package:imh/theme/app_theme.dart';

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
        margin: EdgeInsets.only(
          left: AppTheme.spacing.sm,
          right: AppTheme.spacing.md,
          top: 6,
          bottom: 6,
        ),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(AppTheme.radius.sm),
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
    final textTheme = Theme.of(context).textTheme;

    if (record.mileageDelta == null) {
      return Padding(
        padding: EdgeInsets.all(AppTheme.spacing.md),
        child: Text(
          '加满两次即可计算最新油耗',
          style: textTheme.labelLarge?.copyWith(color: colorScheme.onSurfaceVariant),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.all(AppTheme.spacing.md),
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
    final textTheme = Theme.of(context).textTheme;

    if (value == null) {
      return Text(
        '-',
        style: textTheme.titleLarge?.copyWith(color: colorScheme.onSurface),
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          value.toStringAsFixed(2),
          style: textTheme.headlineMedium?.copyWith(color: colorScheme.primary),
        ),
        SizedBox(width: AppTheme.spacing.xs),
        Text(
          unit,
          style: textTheme.labelSmall?.copyWith(color: colorScheme.onSurfaceVariant),
        ),
      ],
    );
  }

  Widget _buildDataGrid(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppTheme.spacing.md),
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
          SizedBox(height: AppTheme.spacing.sm + AppTheme.spacing.xs),
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
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              number,
              style: textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w500,
                color: colorScheme.onSurface,
              ),
            ),
            SizedBox(width: AppTheme.spacing.xs),
            Text(
              unit,
              style: textTheme.labelSmall?.copyWith(color: colorScheme.onSurfaceVariant),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: textTheme.labelSmall?.copyWith(color: colorScheme.onSurfaceVariant),
        ),
      ],
    );
  }

  Widget _buildFooterRow(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.all(AppTheme.spacing.md),
      child: Text(
        '+${record.mileageDelta ?? 0}km',
        style: textTheme.labelLarge?.copyWith(color: colorScheme.onSurface),
      ),
    );
  }
}
