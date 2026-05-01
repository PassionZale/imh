import 'package:flutter/material.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_theme.dart';
import '../../../database/models/car.dart';
import '../../../database/models/car_fuel_stats.dart';
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
    return Container(
      decoration: AppTheme.cardDecoration,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${car.brand} ${car.model}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textMain,
            ),
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, color: AppColors.borderDefault),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.8,
            children: _gridItems.map((item) {
              return _buildGridCell(item.value, item.unit, item.title);
            }).toList(),
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, color: AppColors.borderDefault),
          const SizedBox(height: 16),
          _buildActionButtons(context),
        ],
      ),
    );
  }

  Widget _buildGridCell(String value, String unit, String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.textMain,
              ),
            ),
            const SizedBox(width: 2),
            Flexible(
              child: Text(
                unit,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textMuted,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            color: AppColors.textMuted,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextButton(
            onPressed: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => FuelRecordListPage(car: car),
                ),
              );
              onDataChanged?.call();
            },
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppTheme.radiusMd),
              ),
            ),
            child: const Text('历史油耗'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: () async {
              final result = await Navigator.of(context).push<bool>(
                MaterialPageRoute(
                  builder: (_) => FuelRecordFormPage(carId: car.id!),
                ),
              );
              if (result == true) {
                onDataChanged?.call();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppTheme.radiusMd),
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
