import 'package:flutter/material.dart';
import 'package:imh/database/models/check_in_task.dart';
import 'package:imh/repositories/check_in_task_repository.dart';
import 'package:imh/components/empty/empty.dart';
import 'package:imh/theme/app_theme.dart';
import 'package:imh/theme/app_page_route.dart';
import 'package:imh/pages/check_in/check_in_task_form_page.dart';

class CheckInTaskListPage extends StatefulWidget {
  const CheckInTaskListPage({super.key});

  @override
  State<CheckInTaskListPage> createState() => _CheckInTaskListPageState();
}

class _CheckInTaskListPageState extends State<CheckInTaskListPage> {
  final _repository = CheckInTaskRepository();
  List<CheckInTask> _tasks = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final tasks = await _repository.getAll();
    if (mounted) {
      setState(() {
        _tasks = tasks;
        _loading = false;
      });
    }
  }

  Future<void> _navigateToForm([CheckInTask? task]) async {
    final result = await Navigator.of(context).push<bool>(
      AppPageRoute(
        builder: (_) => CheckInTaskFormPage(task: task),
      ),
    );
    if (result == true) {
      _loadTasks();
    }
  }

  Future<bool?> _deleteTask(CheckInTask task) async {
    final colorScheme = Theme.of(context).colorScheme;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认删除'),
        content: Text('确定要删除打卡任务"${task.title}"吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: colorScheme.error,
            ),
            child: const Text('删除'),
          ),
        ],
      ),
    );

    if (confirmed == true && task.id != null) {
      await _repository.delete(task.id!);
      _loadTasks();
    }
    return confirmed;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('打卡任务'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _tasks.isEmpty
              ? const EmptyWidget(
                  icon: Icons.checklist_rtl_outlined,
                  message: '暂无打卡任务',
                )
              : ListView.builder(
                  itemCount: _tasks.length,
                  itemBuilder: (context, index) {
                    final task = _tasks[index];
                    return Dismissible(
                      key: ValueKey(task.id),
                      direction: DismissDirection.endToStart,
                      confirmDismiss: (_) => _deleteTask(task),
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.only(right: AppTheme.spacing.lg),
                        color: colorScheme.error,
                        child: Icon(
                          Icons.delete_outline,
                          color: colorScheme.onError,
                        ),
                      ),
                      child: ListTile(
                        title: Text(task.title),
                        subtitle: Text(
                          '频率: ${task.frequency}  ${task.isEnabled ? "已启用" : "已禁用"}',
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => _navigateToForm(task),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToForm(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
