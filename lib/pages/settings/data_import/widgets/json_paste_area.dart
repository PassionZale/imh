import 'package:flutter/material.dart';

/// JSON 粘贴区域
class JsonPasteArea extends StatelessWidget {
  final String content;
  final ValueChanged<String> onChanged;

  const JsonPasteArea({
    super.key,
    required this.content,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('或直接粘贴 JSON 内容：'),
        const SizedBox(height: 8),
        TextField(
          maxLines: 10,
          decoration: const InputDecoration(
            hintText: '在此处粘贴 JSON...',
            border: OutlineInputBorder(),
          ),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
