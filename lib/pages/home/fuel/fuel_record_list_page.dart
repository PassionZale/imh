import 'package:flutter/material.dart';
import '../../../database/models/car.dart';
import '../../../database/models/car_fuel_record.dart';
import '../../../repositories/car_fuel_record_repository.dart';
import '../../../components/empty/empty.dart';
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
        builder: (_) => FuelRecordFormPage(
          carId: widget.car.id!,
          record: record,
        ),
      ),
    );
    if (result == true) {
      _loadRecords();
    }
  }

  Future<bool?> _deleteRecord(CarFuelRecord record) async {
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
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('删除'),
          ),
        ],
      ),
    );

    if (confirmed == true && record.id != null) {
      await _repository.delete(record.id!);
      _loadRecords();
    }
    return confirmed;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.car.brand} ${widget.car.model}'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _records.isEmpty
              ? const EmptyWidget(
                  icon: Icons.local_gas_station_outlined,
                  message: '暂无油耗记录',
                )
              : ListView.builder(
                  itemCount: _records.length,
                  itemBuilder: (context, index) {
                    final record = _records[index];
                    return Dismissible(
                      key: ValueKey(record.id),
                      direction: DismissDirection.endToStart,
                      confirmDismiss: (_) => _deleteRecord(record),
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
                        title: Text(record.date),
                        subtitle: Text(
                          '${record.liters.toStringAsFixed(1)}L  '
                          '${record.totalCost.toStringAsFixed(1)}元  '
                          '${record.mileage}km',
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => _navigateToForm(record),
                      ),
                    );
                  },
                ),
    );
  }
}
