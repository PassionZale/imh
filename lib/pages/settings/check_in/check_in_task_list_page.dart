import 'package:flutter/material.dart';
import '../../../database/models/check_in_task.dart';
import '../../../repositories/check_in_task_repository.dart';
import '../../../components/empty/empty.dart';
import 'check_in_task_form_page.dart';

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
      MaterialPageRoute(
        builder: (_) => CheckInTaskFormPage(task: task),
      ),
    );
    if (result == true) {
      _loadTasks();
    }
  }

  Future<bool?> _deleteTask(CheckInTask task) async {
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
              foregroundColor: Colors.red,
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
                        padding: const EdgeInsets.only(right: 24),
                        color: Colors.red,
                        child: const Icon(
                          Icons.delete_outline,
                          color: Colors.white,
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
