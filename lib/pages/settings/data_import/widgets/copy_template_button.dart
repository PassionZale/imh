import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'import_type_selector.dart';

/// 复制模板按钮
class CopyTemplateButton extends StatelessWidget {
  final ImportType importType;

  const CopyTemplateButton({
    super.key,
    required this.importType,
  });

  String _getTemplate() {
    if (importType == ImportType.fuel) {
      return '''{
  "records": [
    {
      "date": "2024-01-15",
      "liters": 45.5,
      "unitPrice": 8.12,
      "totalCost": 369.46,
      "mileage": 15230
    },
    {
      "date": "2024-02-01",
      "liters": 42.0,
      "unitPrice": 8.05,
      "totalCost": 338.10,
      "mileage": 15780
    }
  ]
}''';
    } else {
      return '''{
  "records": [
    { "date": "2024-01-15" },
    { "date": "2024-01-16" },
    { "date": "2024-01-17" }
  ]
}''';
    }
  }

  Future<void> _copyToClipboard(BuildContext context) async {
    final template = _getTemplate();
    await Clipboard.setData(ClipboardData(text: template));

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('模板已复制到剪贴板'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: () => _copyToClipboard(context),
      icon: const Icon(Icons.copy),
      label: const Text('复制模板'),
    );
  }
}
