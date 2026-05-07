import 'package:imh/database/models/car_fuel_record.dart';

class CarFuelStats {
  final double? latestConsumption;
  final double? averageConsumption;
  final double? dailyMileage;
  final double totalLiters;
  final int totalCount;
  final double totalCost;
  final int totalMileage;

  const CarFuelStats({
    this.latestConsumption,
    this.averageConsumption,
    this.dailyMileage,
    this.totalLiters = 0,
    this.totalCount = 0,
    this.totalCost = 0,
    this.totalMileage = 0,
  });

  /// 计算车辆油耗统计数据
  ///
  /// 返回6个指标：
  /// 1. 最新油耗 (L/100km) - 最近两次加油之间的油耗
  /// 2. 平均油耗 (L/100km) - 总体平均油耗（排除第一次加油）
  /// 3. 日均里程 (km) - 平均每天行驶里程
  /// 4. 累计加油 (L) - 所有加油记录总和
  /// 5. 累计油费 (元) - 所有油费记录总和
  /// 6. 总里程 (km) - 当前里程表读数
  static CarFuelStats calculate(List<CarFuelRecord> records) {
    if (records.isEmpty) {
      return const CarFuelStats();
    }

    // --- 基础统计：至少需要1条记录 ---
    final totalCount = records.length;
    // 累计加油 = Σ每次加油量
    final totalLiters = records.fold<double>(0, (sum, r) => sum + r.liters);
    // 累计油费 = Σ每次油费
    final totalCost = records.fold<double>(0, (sum, r) => sum + r.totalCost);
    // 总里程 = max(所有记录的里程) = 最近一次里程表读数
    final totalMileage =
        records.map((r) => r.mileage).reduce((a, b) => a > b ? a : b);

    if (totalCount < 2) {
      return CarFuelStats(
        totalLiters: totalLiters,
        totalCount: totalCount,
        totalCost: totalCost,
        totalMileage: totalMileage,
      );
    }

    // --- 复杂统计：至少需要2条记录 ---
    // 按里程升序排序，便于计算
    final sorted = List<CarFuelRecord>.from(records)
      ..sort((a, b) => a.mileage.compareTo(b.mileage));

    // 【最新油耗】最近两次加油之间的油耗
    // 公式：(最新加油量 / 最新里程 - 上次里程) × 100
    final latest = sorted[sorted.length - 1];
    final previous = sorted[sorted.length - 2];
    final distanceDiff = latest.mileage - previous.mileage;
    final latestConsumption =
        distanceDiff > 0 ? (latest.liters / distanceDiff) * 100 : null;

    // 【平均油耗】总体平均油耗，排除第一次加油（因初始里程可能不为0）
    // 公式：((累计加油 - 第一次加油量) / 累计里程) × 100
    // 累计里程 = 最后里程 - 第一次里程
    final firstMileage = sorted.first.mileage;
    final lastMileage = sorted.last.mileage;
    final totalDistance = lastMileage - firstMileage;
    final consumableLiters = totalLiters - sorted.first.liters;
    final averageConsumption =
        totalDistance > 0 ? (consumableLiters / totalDistance) * 100 : null;

    // 【日均里程】平均每天行驶里程
    // 公式：累计里程 / 天数差
    // 天数差 = 第一次加油日期 ~ 最后一次加油日期
    final dates = records.map((r) => r.date).toList()..sort();
    final firstDate = DateTime.parse(dates.first);
    final lastDate = DateTime.parse(dates.last);
    final daysDiff = lastDate.difference(firstDate).inDays;
    final dailyMileage = daysDiff > 0
        ? (lastMileage - firstMileage) / daysDiff
        : null;

    return CarFuelStats(
      latestConsumption: latestConsumption,
      averageConsumption: averageConsumption,
      dailyMileage: dailyMileage,
      totalLiters: totalLiters,
      totalCount: totalCount,
      totalCost: totalCost,
      totalMileage: totalMileage,
    );
  }

  String formatValue(double? value) {
    return value != null ? value.toStringAsFixed(1) : '-';
  }
}
