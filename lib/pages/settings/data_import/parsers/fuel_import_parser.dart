import 'dart:convert';
import '../../../../database/models/car_fuel_record.dart';
import 'date_validator.dart';

/// 加油记录导入结果
class FuelImportResult {
  final List<CarFuelRecord> records;
  final List<String> errors;

  FuelImportResult({
    required this.records,
    this.errors = const [],
  });

  bool get isValid => errors.isEmpty;
}

/// 加油记录 JSON 解析器
class FuelImportParser {
  /// 解析 JSON 字符串并返回加油记录列表
  ///
  /// [jsonStr] JSON 字符串
  /// [carId] 关联的车辆 ID
  static FuelImportResult parse(String jsonStr, int carId) {
    final errors = <String>[];

    try {
      // 解析 JSON
      final jsonData = jsonDecode(jsonStr) as Map<String, dynamic>;

      // 验证结构
      if (!jsonData.containsKey('records')) {
        return FuelImportResult(
          records: [],
          errors: ['JSON 必须包含 "records" 字段'],
        );
      }

      final recordsList = jsonData['records'] as List;
      if (recordsList.isEmpty) {
        return FuelImportResult(
          records: [],
          errors: ['记录列表不能为空'],
        );
      }

      // 解析每条记录
      final rawRecords = <_RawFuelRecord>[];
      for (int i = 0; i < recordsList.length; i++) {
        final item = recordsList[i];
        if (item is! Map<String, dynamic>) {
          errors.add('第 ${i + 1} 条记录格式无效');
          continue;
        }

        final recordErrors = _validateRecordItem(item, i + 1);
        if (recordErrors.isNotEmpty) {
          errors.addAll(recordErrors);
          continue;
        }

        rawRecords.add(_RawFuelRecord(
          date: item['date'] as String,
          liters: (item['liters'] as num).toDouble(),
          unitPrice: (item['unitPrice'] as num).toDouble(),
          totalCost: (item['totalCost'] as num).toDouble(),
          mileage: item['mileage'] as int,
        ));
      }

      // 如果有错误，返回
      if (errors.isNotEmpty) {
        return FuelImportResult(records: [], errors: errors);
      }

      // 按日期排序
      rawRecords.sort((a, b) => a.date.compareTo(b.date));

      // 验证里程严格递增
      final mileageErrors = _validateMileageIncreasing(rawRecords);
      if (mileageErrors.isNotEmpty) {
        return FuelImportResult(records: [], errors: mileageErrors);
      }

      // 计算增量字段并创建 CarFuelRecord
      final records = _calculateAndCreateRecords(rawRecords, carId);

      return FuelImportResult(records: records);
    } on FormatException catch (e) {
      return FuelImportResult(
        records: [],
        errors: ['JSON 格式错误: ${e.message}'],
      );
    } catch (e) {
      return FuelImportResult(
        records: [],
        errors: ['解析失败: $e'],
      );
    }
  }

  /// 验证单条记录
  static List<String> _validateRecordItem(
    Map<String, dynamic> item,
    int index,
  ) {
    final errors = <String>[];

    // 验证必需字段
    final requiredFields = ['date', 'liters', 'unitPrice', 'totalCost', 'mileage'];
    for (final field in requiredFields) {
      if (!item.containsKey(field)) {
        errors.add('第 $index 条记录缺少字段: $field');
      }
    }

    if (errors.isNotEmpty) return errors;

    // 验证日期
    final date = item['date'] as String;
    final dateError = DateValidator.validateValid(date);
    if (dateError != null) {
      errors.add('第 $index 条记录日期无效: $dateError');
    }

    // 验证数值
    final liters = (item['liters'] as num).toDouble();
    if (liters <= 0) {
      errors.add('第 $index 条记录加油量必须大于 0');
    }

    final unitPrice = (item['unitPrice'] as num).toDouble();
    if (unitPrice <= 0) {
      errors.add('第 $index 条记录单价必须大于 0');
    }

    final totalCost = (item['totalCost'] as num).toDouble();
    if (totalCost <= 0) {
      errors.add('第 $index 条记录总额必须大于 0');
    }

    final mileage = item['mileage'] as int;
    if (mileage < 0) {
      errors.add('第 $index 条记录里程不能为负数');
    }

    return errors;
  }

  /// 验证里程严格递增
  static List<String> _validateMileageIncreasing(List<_RawFuelRecord> records) {
    final errors = <String>[];

    for (int i = 1; i < records.length; i++) {
      if (records[i].mileage <= records[i - 1].mileage) {
        errors.add(
          '里程必须严格递增: ${records[i - 1].date} (${records[i - 1].mileage}km) '
          '→ ${records[i].date} (${records[i].mileage}km)',
        );
      }
    }

    return errors;
  }

  /// 计算增量字段并创建记录
  static List<CarFuelRecord> _calculateAndCreateRecords(
    List<_RawFuelRecord> rawRecords,
    int carId,
  ) {
    final records = <CarFuelRecord>[];

    for (int i = 0; i < rawRecords.length; i++) {
      final raw = rawRecords[i];

      int? mileageDelta;
      double? consumption;
      double? costPerKm;

      if (i > 0) {
        final prev = rawRecords[i - 1];
        mileageDelta = raw.mileage - prev.mileage;

        if (mileageDelta > 0) {
          consumption = (raw.liters / mileageDelta) * 100;
          costPerKm = raw.totalCost / mileageDelta;
        }
      }

      records.add(CarFuelRecord(
        carId: carId,
        liters: raw.liters,
        unitPrice: raw.unitPrice,
        totalCost: raw.totalCost,
        mileage: raw.mileage,
        mileageDelta: mileageDelta,
        consumption: consumption,
        costPerKm: costPerKm,
        date: raw.date,
      ));
    }

    return records;
  }
}

/// 原始加油记录（未计算增量字段）
class _RawFuelRecord {
  final String date;
  final double liters;
  final double unitPrice;
  final double totalCost;
  final int mileage;

  _RawFuelRecord({
    required this.date,
    required this.liters,
    required this.unitPrice,
    required this.totalCost,
    required this.mileage,
  });
}
