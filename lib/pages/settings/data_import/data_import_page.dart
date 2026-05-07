import 'package:flutter/material.dart';
import 'package:imh/database/models/car_fuel_record.dart';
import 'package:imh/database/models/check_in_record.dart';
import 'package:imh/repositories/car_fuel_record_repository.dart';
import 'package:imh/repositories/check_in_record_repository.dart';
import 'package:imh/repositories/car_repository.dart';
import 'package:imh/repositories/check_in_task_repository.dart';
import 'package:imh/database/models/car.dart';
import 'package:imh/database/models/check_in_task.dart';
import 'package:imh/theme/app_theme.dart';
import 'package:imh/pages/settings/data_import/widgets/import_type_selector.dart';
import 'package:imh/pages/settings/data_import/widgets/json_paste_area.dart';
import 'package:imh/pages/settings/data_import/widgets/copy_template_button.dart';
import 'package:imh/pages/settings/data_import/widgets/import_preview_dialog.dart';
import 'package:imh/pages/settings/data_import/widgets/import_progress_dialog.dart';
import 'package:imh/pages/settings/data_import/parsers/fuel_import_parser.dart';
import 'package:imh/pages/settings/data_import/parsers/checkin_import_parser.dart';

class DataImportPage extends StatefulWidget {
  const DataImportPage({super.key});

  @override
  State<DataImportPage> createState() => _DataImportPageState();
}

class _DataImportPageState extends State<DataImportPage> {
  final _carRepository = CarRepository();
  final _checkInTaskRepository = CheckInTaskRepository();
  final _fuelRecordRepository = CarFuelRecordRepository();
  final _checkInRecordRepository = CheckInRecordRepository();

  // 导入类型
  ImportType _importType = ImportType.fuel;

  // 车辆/任务列表和选择
  List<Car> _cars = [];
  List<CheckInTask> _tasks = [];
  Car? _selectedCar;
  CheckInTask? _selectedTask;

  // 文件和内容
  String _pastedJson = '';

  // 加载状态
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final cars = await _carRepository.getAll();
    final tasks = await _checkInTaskRepository.getAll();

    if (mounted) {
      setState(() {
        _cars = cars;
        _tasks = tasks;
        _selectedCar = cars.isNotEmpty ? cars.first : null;
        _selectedTask = tasks.isNotEmpty ? tasks.first : null;
        _isLoading = false;
      });
    }
  }

  Future<void> _handleImportTypeChanged(ImportType type) async {
    setState(() {
      _importType = type;
      _pastedJson = '';
    });
  }

  void _handlePasteChanged(String content) {
    setState(() {
      _pastedJson = content;
    });
  }

  Future<String?> _getJsonContent() async {
    if (_pastedJson.trim().isNotEmpty) {
      return _pastedJson.trim();
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请粘贴 JSON 内容')),
      );
    }
    return null;
  }

  Future<void> _handleStartImport() async {
    // 验证选择
    if (_importType == ImportType.fuel && _selectedCar == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请选择车辆')),
      );
      return;
    }

    if (_importType == ImportType.checkIn && _selectedTask == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请选择打卡任务')),
      );
      return;
    }

    // 获取 JSON 内容
    final jsonContent = await _getJsonContent();
    if (jsonContent == null) return;

    // 解析和验证
    if (_importType == ImportType.fuel) {
      await _importFuelRecords(jsonContent);
    } else {
      await _importCheckInRecords(jsonContent);
    }
  }

  Future<void> _importFuelRecords(String jsonContent) async {
    final result = FuelImportParser.parse(jsonContent, _selectedCar!.id!);

    if (!result.isValid) {
      _showValidationErrors(result.errors);
      return;
    }

    // 显示预览
    final confirmed = await showImportPreviewDialog(
      context: context,
      importTypeLabel: '加油记录',
      fuelRecords: result.records,
      checkinRecords: const [],
    );

    if (!confirmed) return;

    // 执行导入
    if (!mounted) return;
    ImportProgressDialog.showImporting(context: context);

    try {
      await _performFuelImport(result.records);

      if (mounted) {
        ImportProgressDialog.showSuccess(context, count: result.records.length);
      }
    } catch (e) {
      if (mounted) {
        ImportProgressDialog.showError(context, error: e.toString());
      }
    }
  }

  Future<void> _importCheckInRecords(String jsonContent) async {
    final result = CheckInImportParser.parse(jsonContent, _selectedTask!.id!);

    if (!result.isValid) {
      _showValidationErrors(result.errors);
      return;
    }

    // 显示预览
    final confirmed = await showImportPreviewDialog(
      context: context,
      importTypeLabel: '打卡记录',
      fuelRecords: const [],
      checkinRecords: result.records,
    );

    if (!confirmed) return;

    // 执行导入
    if (!mounted) return;
    ImportProgressDialog.showImporting(context: context);

    try {
      await _performCheckInImport(result.records);

      if (mounted) {
        ImportProgressDialog.showSuccess(context, count: result.records.length);
      }
    } catch (e) {
      if (mounted) {
        ImportProgressDialog.showError(context, error: e.toString());
      }
    }
  }

  Future<void> _performFuelImport(List<CarFuelRecord> records) async {
    // 实际执行导入
    await _fuelRecordRepository.deleteByCar(_selectedCar!.id!);

    for (final record in records) {
      await _fuelRecordRepository.create(record);
    }
  }

  Future<void> _performCheckInImport(List<CheckInRecord> records) async {
    await _checkInRecordRepository.deleteByTask(_selectedTask!.id!);

    for (final record in records) {
      await _checkInRecordRepository.create(record);
    }
  }

  void _showValidationErrors(List<String> errors) {
    final textTheme = Theme.of(context).textTheme;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('数据验证失败'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: errors.map((e) => Padding(
            padding: EdgeInsets.only(bottom: AppTheme.spacing.xs),
            child: Text('• $e', style: textTheme.labelSmall),
          )).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final hasNoData = (_importType == ImportType.fuel && _cars.isEmpty) ||
        (_importType == ImportType.checkIn && _tasks.isEmpty);

    return Scaffold(
      appBar: AppBar(
        title: const Text('数据导入'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppTheme.spacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 导入类型选择
            ImportTypeSelector(
              selectedType: _importType,
              onChanged: _handleImportTypeChanged,
            ),
            SizedBox(height: AppTheme.spacing.md),

            // 车辆/任务选择
            if (_importType == ImportType.fuel)
              _buildCarSelector()
            else
              _buildTaskSelector(),
            SizedBox(height: AppTheme.spacing.lg),

            // JSON 粘贴区域
            JsonPasteArea(
              content: _pastedJson,
              onChanged: _handlePasteChanged,
            ),
            SizedBox(height: AppTheme.spacing.md),

            // 复制模板按钮
            Row(
              children: [
                CopyTemplateButton(importType: _importType),
              ],
            ),
            SizedBox(height: AppTheme.spacing.lg),

            // 警告信息
            Container(
              padding: EdgeInsets.all(AppTheme.spacing.sm),
              decoration: BoxDecoration(
                color: colorScheme.tertiaryContainer,
                borderRadius: BorderRadius.circular(AppTheme.radius.sm),
                border: Border.all(color: colorScheme.tertiary),
              ),
              child: Row(
                children: [
                  Icon(Icons.warning_amber_rounded, color: colorScheme.tertiary),
                  SizedBox(width: AppTheme.spacing.sm),
                  Expanded(
                    child: Text(
                      _importType == ImportType.fuel
                          ? '警告: 导入将覆盖该车辆的所有加油数据!'
                          : '警告: 导入将覆盖该任务的所有打卡数据!',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: colorScheme.onTertiaryContainer,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: AppTheme.spacing.lg),

            // 开始导入按钮
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: hasNoData ? null : _handleStartImport,
                child: const Text('开始导入'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCarSelector() {
    if (_cars.isEmpty) {
      return Card(
        child: Padding(
          padding: EdgeInsets.all(AppTheme.spacing.md),
          child: const Text('暂无车辆，请先添加车辆'),
        ),
      );
    }

    return DropdownButtonFormField<Car>(
      initialValue: _selectedCar,
      decoration: const InputDecoration(
        labelText: '选择车辆',
        border: OutlineInputBorder(),
      ),
      items: _cars.map((car) {
        return DropdownMenuItem(
          value: car,
          child: Text('${car.brand} ${car.model}'),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedCar = value;
        });
      },
    );
  }

  Widget _buildTaskSelector() {
    if (_tasks.isEmpty) {
      return Card(
        child: Padding(
          padding: EdgeInsets.all(AppTheme.spacing.md),
          child: const Text('暂无打卡任务，请先添加打卡任务'),
        ),
      );
    }

    return DropdownButtonFormField<CheckInTask>(
      initialValue: _selectedTask,
      decoration: const InputDecoration(
        labelText: '选择打卡任务',
        border: OutlineInputBorder(),
      ),
      items: _tasks.map((task) {
        return DropdownMenuItem(
          value: task,
          child: Text(task.title),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedTask = value;
        });
      },
    );
  }
}
