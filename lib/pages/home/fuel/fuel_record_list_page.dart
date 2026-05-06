import 'package:flutter/material.dart';
import '../../../database/models/car.dart';
import '../../../database/models/car_fuel_record.dart';
import '../../../repositories/car_fuel_record_repository.dart';
import '../../../components/empty/empty.dart';
import 'widgets/fuel_record_card.dart';
import 'fuel_record_form_page.dart';

class FuelRecordListPage extends StatefulWidget {
  final Car car;

  const FuelRecordListPage({super.key, required this.car});

  @override
  State<FuelRecordListPage> createState() => _FuelRecordListPageState();
}

class _FuelRecordListPageState extends State<FuelRecordListPage> {
  final _repository = CarFuelRecordRepository();
  List<CarFuelRecord> _records = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadRecords();
  }

  Future<void> _loadRecords() async {
    final records = await _repository.getByCar(widget.car.id!);
    if (mounted) {
      setState(() {
        _records = records;
        _loading = false;
      });
    }
  }

  Future<void> _navigateToForm([CarFuelRecord? record]) async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) =>
            FuelRecordFormPage(carId: widget.car.id!, record: record),
      ),
    );
    if (result == true) {
      _loadRecords();
    }
  }

  Future<bool?> _deleteLatestRecord(CarFuelRecord record) async {
    final colorScheme = Theme.of(context).colorScheme;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认删除'),
        content: Text('确定要删除${record.date}的油耗记录吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: colorScheme.error),
            child: const Text('删除'),
          ),
        ],
      ),
    );

    if (confirmed == true && record.id != null) {
      try {
        await _repository.delete(record.id!);
        _loadRecords();
        return true;
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(e.toString())));
        }
        return false;
      }
    }
    return confirmed;
  }

  /// 按月分组记录，返回 Map&lt;String, List&lt;CarFuelRecord&gt;&gt;
  /// key 为 "YYYY-MM" 格式，value 为该月的记录列表
  Map<String, List<CarFuelRecord>> _groupRecordsByMonth() {
    final Map<String, List<CarFuelRecord>> grouped = {};
    for (final record in _records) {
      final month = record.date.substring(0, 7); // "2024-05"
      grouped.putIfAbsent(month, () => []).add(record);
    }
    return grouped;
  }

  /// 将 "2024-05" 格式化为 "2024年05月"
  String _formatMonthTitle(String month) {
    final parts = month.split('-');
    return '${parts[0]}年${parts[1]}月';
  }

  /// 解析日期获取"日"
  String _extractDay(String date) {
    return date.split('-').last;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('历史油耗')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _records.isEmpty
          ? const EmptyWidget(
              icon: Icons.local_gas_station_outlined,
              message: '暂无油耗记录',
            )
          : _buildGroupedList(),
    );
  }

  Widget _buildGroupedList() {
    final colorScheme = Theme.of(context).colorScheme;
    final grouped = _groupRecordsByMonth();
    final sortedMonths = grouped.keys.toList()..sort((a, b) => b.compareTo(a));

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 16),
      itemCount: sortedMonths.length,
      itemBuilder: (context, index) {
        final month = sortedMonths[index];
        final monthRecords = grouped[month]!;
        final isLatestMonth = index == 0;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 分组标题
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: Text(
                _formatMonthTitle(month),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
            ),
            // 该月的所有记录（时间轴布局）
            ...monthRecords.asMap().entries.map((entry) {
              final recordIndex = entry.key;
              final record = entry.value;
              // 判断是否是最新记录（全局第一条）
              final isLatest = isLatestMonth && recordIndex == 0;
              final day = _extractDay(record.date);
              final isLastInMonth = recordIndex == monthRecords.length - 1;

              return _buildTimelineItem(
                record: record,
                day: day,
                isLatest: isLatest,
                isLastInMonth: isLastInMonth,
              );
            }),
            // 月与月之间的间距
            if (index < sortedMonths.length - 1) const SizedBox(height: 16),
          ],
        );
      },
    );
  }

  Widget _buildTimelineItem({
    required CarFuelRecord record,
    required String day,
    required bool isLatest,
    required bool isLastInMonth,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    final card = isLatest
        ? Dismissible(
            key: ValueKey(record.id),
            direction: DismissDirection.endToStart,
            confirmDismiss: (_) => _deleteLatestRecord(record),
            background: Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 24),
              color: colorScheme.error,
              child: Icon(Icons.delete_outline, color: colorScheme.onError),
            ),
            child: FuelRecordCard(
              record: record,
              isLatest: isLatest,
              onTap: () => _navigateToForm(record),
            ),
          )
        : FuelRecordCard(record: record, isLatest: isLatest);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 左侧：时间轴日期区
          SizedBox(
            width: 70,
            child: Column(
              children: [
                // 日期标签 - 与卡片 header 文字中心对齐
                Padding(
                  padding: const EdgeInsets.only(top: 26),
                  child: Text(
                    '$day日',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                      height: 1.5,
                    ),
                  ),
                ),
                // 时间轴线
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 34, vertical: 30),
                    color: isLastInMonth
                        ? Colors.transparent
                        : colorScheme.outline,
                    width: 1,
                  ),
                ),
              ],
            ),
          ),
          // 右侧：卡片
          Expanded(child: card),
        ],
      ),
    );
  }
}
