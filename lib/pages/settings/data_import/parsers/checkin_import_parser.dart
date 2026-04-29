import 'dart:convert';
import '../../../../database/models/check_in_record.dart';
import 'date_validator.dart';

/// 打卡记录导入结果
class CheckInImportResult {
  final List<CheckInRecord> records;
  final List<String> errors;

  CheckInImportResult({
    required this.records,
    this.errors = const [],
  });

  bool get isValid => errors.isEmpty;
}

/// 打卡记录 JSON 解析器
class CheckInImportParser {
  /// 解析 JSON 字符串并返回打卡记录列表
  ///
  /// [jsonStr] JSON 字符串
  /// [taskId] 关联的任务 ID
  static CheckInImportResult parse(String jsonStr, int taskId) {
    final errors = <String>[];

    try {
      // 解析 JSON
      final jsonData = jsonDecode(jsonStr) as Map<String, dynamic>;

      // 验证结构
      if (!jsonData.containsKey('records')) {
        return CheckInImportResult(
          records: [],
          errors: ['JSON 必须包含 "records" 字段'],
        );
      }

      final recordsList = jsonData['records'] as List;
      if (recordsList.isEmpty) {
        return CheckInImportResult(
          records: [],
          errors: ['记录列表不能为空'],
        );
      }

      // 解析每条记录并验证日期唯一性
      final dates = <String>[];
      final records = <CheckInRecord>[];

      for (int i = 0; i < recordsList.length; i++) {
        final item = recordsList[i];
        if (item is! Map<String, dynamic>) {
          errors.add('第 ${i + 1} 条记录格式无效');
          continue;
        }

        // 验证必需字段
        if (!item.containsKey('date')) {
          errors.add('第 ${i + 1} 条记录缺少字段: date');
          continue;
        }

        final date = item['date'] as String;

        // 验证日期格式
        final dateError = DateValidator.validateValid(date);
        if (dateError != null) {
          errors.add('第 ${i + 1} 条记录日期无效: $dateError');
          continue;
        }

        // 验证日期唯一性
        if (dates.contains(date)) {
          errors.add('日期重复: $date');
          continue;
        }
        dates.add(date);

        records.add(CheckInRecord(
          taskId: taskId,
          date: date,
        ));
      }

      // 如果有错误，返回
      if (errors.isNotEmpty) {
        return CheckInImportResult(records: [], errors: errors);
      }

      return CheckInImportResult(records: records);
    } on FormatException catch (e) {
      return CheckInImportResult(
        records: [],
        errors: ['JSON 格式错误: ${e.message}'],
      );
    } catch (e) {
      return CheckInImportResult(
        records: [],
        errors: ['解析失败: $e'],
      );
    }
  }
}
