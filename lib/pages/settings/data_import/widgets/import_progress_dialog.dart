import 'package:flutter/material.dart';

/// 导入状态
enum ImportStatus {
  importing,
  success,
  error,
}

/// 导入进度/结果对话框
class ImportProgressDialog extends StatefulWidget {
  final ImportStatus status;
  final int current;
  final int total;
  final String? errorMessage;

  const ImportProgressDialog({
    super.key,
    required this.status,
    this.current = 0,
    this.total = 0,
    this.errorMessage,
  });

  /// 显示导入中对话框
  static Future<void> showImporting({
    required BuildContext context,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const ImportProgressDialog(
        status: ImportStatus.importing,
      ),
    );
  }

  /// 更新为成功状态
  static void showSuccess(
    BuildContext context, {
    required int count,
  }) {
    Navigator.of(context).pop();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ImportProgressDialog(
        status: ImportStatus.success,
        total: count,
      ),
    );
  }

  /// 更新为失败状态
  static void showError(
    BuildContext context, {
    required String error,
  }) {
    Navigator.of(context).pop();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ImportProgressDialog(
        status: ImportStatus.error,
        errorMessage: error,
      ),
    );
  }

  @override
  State<ImportProgressDialog> createState() => _ImportProgressDialogState();
}

class _ImportProgressDialogState extends State<ImportProgressDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_getTitle()),
      content: _buildContent(),
      actions: _buildActions(),
    );
  }

  String _getTitle() {
    switch (widget.status) {
      case ImportStatus.importing:
        return '导入中...';
      case ImportStatus.success:
        return '导入完成';
      case ImportStatus.error:
        return '导入失败';
    }
  }

  Widget _buildContent() {
    switch (widget.status) {
      case ImportStatus.importing:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const LinearProgressIndicator(),
            const SizedBox(height: 16),
            Text('${widget.current}/${widget.total}'),
          ],
        );
      case ImportStatus.success:
        return Text('成功导入 ${widget.total} 条记录');
      case ImportStatus.error:
        return Text(widget.errorMessage ?? '未知错误');
    }
  }

  List<Widget> _buildActions() {
    switch (widget.status) {
      case ImportStatus.importing:
        return [];
      case ImportStatus.success:
      case ImportStatus.error:
        return [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('确定'),
          ),
        ];
    }
  }
}
