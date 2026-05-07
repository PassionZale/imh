import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import '../../../theme/app_page_route.dart';
import '../../../database/models/car.dart';
import '../../../database/models/car_fuel_stats.dart';
import '../../../repositories/car_fuel_record_repository.dart';
import 'fuel_chart.dart';
import '../../home/fuel/fuel_record_list_page.dart';
import '../../home/fuel/fuel_record_form_page.dart';

class CarCard extends StatelessWidget {
  final Car car;
  final CarFuelStats stats;
  final VoidCallback? onDataChanged;

  const CarCard({
    super.key,
    required this.car,
    required this.stats,
    this.onDataChanged,
  });

  List<({String value, String unit, String title})> get _gridItems {
    return [
      (value: stats.formatValue(stats.latestConsumption), unit: 'L/100km', title: '最新油耗'),
      (value: stats.formatValue(stats.averageConsumption), unit: 'L/100km', title: '平均油耗'),
      (value: stats.dailyMileage != null ? stats.dailyMileage!.toStringAsFixed(1) : '-', unit: 'km', title: '日均里程'),
      (value: stats.totalLiters > 0 ? stats.totalLiters.toStringAsFixed(0) : '-', unit: 'L', title: '累计加油'),
      (value: stats.totalCost > 0 ? stats.totalCost.ceil().toString() : '-', unit: '元', title: '累计油费'),
      (value: stats.totalMileage > 0 ? '${stats.totalMileage}' : '-', unit: 'km', title: '总里程'),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: AppTheme.cardDecoration(context),
      padding: EdgeInsets.all(AppTheme.spacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${car.brand} ${car.model}', style: textTheme.titleLarge),
          SizedBox(height: AppTheme.spacing.md),
          Divider(height: 1, color: colorScheme.outline),
          SizedBox(height: AppTheme.spacing.md),
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: AppTheme.spacing.sm,
            crossAxisSpacing: AppTheme.spacing.sm + AppTheme.spacing.xs,
            childAspectRatio: 1.6,
            children: _gridItems.map((item) {
              return _buildGridCell(context, item.value, item.unit, item.title);
            }).toList(),
          ),
          if (car.id != null) ...[
            SizedBox(height: AppTheme.spacing.md),
            Divider(height: 1, color: colorScheme.outline),
            SizedBox(height: AppTheme.spacing.md),
            FuelChart(
              carId: car.id!,
              getRecentRecords: CarFuelRecordRepository().getRecentRecords,
              getMonthlyCost: CarFuelRecordRepository().getMonthlyCost,
            ),
          ],
          SizedBox(height: AppTheme.spacing.md),
          Divider(height: 1, color: colorScheme.outline),
          SizedBox(height: AppTheme.spacing.md),
          _buildActionButtons(context),
        ],
      ),
    );
  }

  Widget _buildGridCell(BuildContext context, String value, String unit, String title) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(value, style: textTheme.titleLarge),
            SizedBox(width: 2),
            Flexible(
              child: Text(
                unit,
                style: textTheme.labelSmall?.copyWith(color: colorScheme.onSurfaceVariant),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        SizedBox(height: AppTheme.spacing.xs),
        Text(title, style: textTheme.labelSmall?.copyWith(color: colorScheme.onSurfaceVariant)),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Expanded(
          child: TextButton(
            onPressed: () async {
              await Navigator.of(context).push(
                AppPageRoute(builder: (_) => FuelRecordListPage(car: car)),
              );
              onDataChanged?.call();
            },
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: AppTheme.spacing.sm + AppTheme.spacing.xs),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppTheme.radius.md),
              ),
            ),
            child: const Text('历史油耗'),
          ),
        ),
        SizedBox(width: AppTheme.spacing.sm + AppTheme.spacing.xs),
        Expanded(
          child: ElevatedButton(
            onPressed: () async {
              final result = await Navigator.of(context).push<bool>(
                AppPageRoute(builder: (_) => FuelRecordFormPage(carId: car.id!)),
              );
              if (result == true) {
                onDataChanged?.call();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              padding: EdgeInsets.symmetric(vertical: AppTheme.spacing.sm + AppTheme.spacing.xs),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppTheme.radius.md),
              ),
              elevation: 0,
            ),
            child: const Text('记油耗'),
          ),
        ),
      ],
    );
  }
}
