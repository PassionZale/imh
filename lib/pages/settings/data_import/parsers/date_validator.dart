/// 日期验证工具
class DateValidator {
  /// 验证日期格式是否为 YYYY-MM-DD
  ///
  /// 返回验证结果，如果格式正确则返回 null，否则返回错误信息
  static String? validateFormat(String dateStr) {
    // 正则表达式匹配 YYYY-MM-DD 格式
    final regex = RegExp(r'^\d{4}-\d{2}-\d{2}$');
    if (!regex.hasMatch(dateStr)) {
      return '日期格式必须为 YYYY-MM-DD';
    }

    return null;
  }

  /// 验证日期是否有效
  ///
  /// 返回验证结果，如果日期有效则返回 null，否则返回错误信息
  static String? validateValid(String dateStr) {
    // 先检查格式
    final formatError = validateFormat(dateStr);
    if (formatError != null) {
      return formatError;
    }

    try {
      // 解析日期
      final parts = dateStr.split('-');
      final year = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final day = int.parse(parts[2]);

      // 验证月份范围
      if (month < 1 || month > 12) {
        return '月份必须在 01-12 之间';
      }

      // 验证日期范围
      if (day < 1 || day > 31) {
        return '日期必须在 01-31 之间';
      }

      // 验证具体的月份日期
      final daysInMonth = _getDaysInMonth(year, month);
      if (day > daysInMonth) {
        return '$year年$month月没有$day日';
      }

      return null;
    } catch (e) {
      return '日期格式无效: $dateStr';
    }
  }

  /// 获取指定年份和月份的天数
  static int _getDaysInMonth(int year, int month) {
    const daysPerMonth = [0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];

    // 处理闰年二月
    if (month == 2 && _isLeapYear(year)) {
      return 29;
    }

    return daysPerMonth[month];
  }

  /// 判断是否为闰年
  static bool _isLeapYear(int year) {
    return (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);
  }
}
