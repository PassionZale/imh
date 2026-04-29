import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

/// 文件选择区域
class FilePickerArea extends StatefulWidget {
  final String? selectedFileName;
  final ValueChanged<String?> onFileSelected;

  const FilePickerArea({
    super.key,
    this.selectedFileName,
    required this.onFileSelected,
  });

  @override
  State<FilePickerArea> createState() => _FilePickerAreaState();
}

class _FilePickerAreaState extends State<FilePickerArea> {
  bool _isLoading = false;

  Future<void> _pickFile() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        final file = result.files.single;
        widget.onFileSelected(file.path);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('选择文件失败: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          if (widget.selectedFileName != null) ...[
            Icon(
              Icons.description_outlined,
              size: 48,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(height: 12),
            Text(
              widget.selectedFileName!.split('/').last,
              style: const TextStyle(fontSize: 14),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
          ] else
            const Text('点击选择或拖拽 JSON 文件到此处'),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _isLoading ? null : _pickFile,
            icon: _isLoading
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.folder_open),
            label: const Text('选择 JSON 文件'),
          ),
        ],
      ),
    );
  }
}
