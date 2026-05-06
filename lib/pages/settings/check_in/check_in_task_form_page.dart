import 'package:flutter/material.dart';
import '../../../database/models/check_in_task.dart';
import '../../../repositories/check_in_task_repository.dart';
import '../../../theme/app_theme.dart';

class CheckInTaskFormPage extends StatefulWidget {
  final CheckInTask? task;

  const CheckInTaskFormPage({super.key, this.task});

  @override
  State<CheckInTaskFormPage> createState() => _CheckInTaskFormPageState();
}

class _CheckInTaskFormPageState extends State<CheckInTaskFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _frequencyController = TextEditingController();
  bool _isEnabled = true;
  bool _isSubmitting = false;
  final _repository = CheckInTaskRepository();

  bool get _isEditing => widget.task != null;

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _titleController.text = widget.task!.title;
      _frequencyController.text = widget.task!.frequency.toString();
      _isEnabled = widget.task!.isEnabled;
    } else {
      _frequencyController.text = '1';
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _frequencyController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_isSubmitting) return;

    setState(() => _isSubmitting = true);

    if (_isEditing) {
      final updated = widget.task!.copyWith(
        title: _titleController.text,
        frequency: int.tryParse(_frequencyController.text) ?? 1,
        isEnabled: _isEnabled,
      );
      await _repository.update(updated);
    } else {
      final task = CheckInTask(
        title: _titleController.text,
        frequency: int.tryParse(_frequencyController.text) ?? 1,
        isEnabled: _isEnabled,
      );
      await _repository.create(task);
    }

    if (mounted) {
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? '编辑打卡任务' : '新建打卡任务'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: '任务名称',
                  hintText: '请输入任务名称',
                  prefixIcon: Icon(Icons.title),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '请输入任务名称';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _frequencyController,
                decoration: const InputDecoration(
                  labelText: '频率',
                  hintText: '请输入频率',
                  prefixIcon: Icon(Icons.repeat),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: const Text('启用'),
                value: _isEnabled,
                onChanged: (value) => setState(() => _isEnabled = value),
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(AppTheme.radiusMd),
                  side: BorderSide(color: colorScheme.outline),
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _save,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(52),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppTheme.radiusMd),
                    ),
                  ),
                  child: _isSubmitting
                      ? SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: colorScheme.onPrimary,
                          ),
                        )
                      : Text(
                          _isEditing ? '保存' : '创建',
                          style: const TextStyle(fontSize: 18),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
