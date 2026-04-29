import 'car_fuel_record.dart';

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

  static CarFuelStats calculate(List<CarFuelRecord> records) {
    if (records.isEmpty) {
      return const CarFuelStats();
    }

    final totalCount = records.length;
    final totalLiters = records.fold<double>(0, (sum, r) => sum + r.liters);
    final totalCost = records.fold<double>(0, (sum, r) => sum + r.totalCost);

    // Total mileage: highest mileage from records
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

    // Sort by mileage ASC for calculations
    final sorted = List<CarFuelRecord>.from(records)
      ..sort((a, b) => a.mileage.compareTo(b.mileage));

    // Latest consumption: use the two records with highest mileage
    final latest = sorted[sorted.length - 1];
    final previous = sorted[sorted.length - 2];
    final distanceDiff = latest.mileage - previous.mileage;
    final latestConsumption =
        distanceDiff > 0 ? (latest.liters / distanceDiff) * 100 : null;

    // Average consumption
    final firstMileage = sorted.first.mileage;
    final lastMileage = sorted.last.mileage;
    final totalDistance = lastMileage - firstMileage;
    final averageConsumption =
        totalDistance > 0 ? (totalLiters / totalDistance) * 100 : null;

    // Daily mileage
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
