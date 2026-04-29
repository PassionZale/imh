import 'package:flutter/material.dart';

/// 导入类型枚举
enum ImportType {
  fuel('加油记录'),
  checkIn('打卡记录');

  final String label;
  const ImportType(this.label);
}

/// 导入类型选择器
class ImportTypeSelector extends StatelessWidget {
  final ImportType selectedType;
  final ValueChanged<ImportType> onChanged;

  const ImportTypeSelector({
    super.key,
    required this.selectedType,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<ImportType>(
      initialValue: selectedType,
      decoration: const InputDecoration(
        labelText: '导入类型',
        border: OutlineInputBorder(),
      ),
      items: ImportType.values.map((type) {
        return DropdownMenuItem(
          value: type,
          child: Text(type.label),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) {
          onChanged(value);
        }
      },
    );
  }
}
