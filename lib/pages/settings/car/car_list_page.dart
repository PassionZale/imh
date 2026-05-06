import 'package:flutter/material.dart';
import '../../../database/models/car.dart';
import '../../../repositories/car_repository.dart';
import '../../../components/empty/empty.dart';
import 'car_form_page.dart';

class CarListPage extends StatefulWidget {
  const CarListPage({super.key});

  @override
  State<CarListPage> createState() => _CarListPageState();
}

class _CarListPageState extends State<CarListPage> {
  final _repository = CarRepository();
  List<Car> _cars = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadCars();
  }

  Future<void> _loadCars() async {
    final cars = await _repository.getAll();
    if (mounted) {
      setState(() {
        _cars = cars;
        _loading = false;
      });
    }
  }

  Future<void> _navigateToForm([Car? car]) async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) => CarFormPage(car: car),
      ),
    );
    if (result == true) {
      _loadCars();
    }
  }

  Future<bool?> _deleteCar(Car car) async {
    final colorScheme = Theme.of(context).colorScheme;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认删除'),
        content: Text('确定要删除车辆"${car.brand} ${car.model}"吗？'),
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

    if (confirmed == true && car.id != null) {
      await _repository.delete(car.id!);
      _loadCars();
    }
    return confirmed;
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('我的车辆'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _cars.isEmpty
              ? const EmptyWidget(
                  icon: Icons.directions_car_outlined,
                  message: '暂无车辆',
                )
              : ListView.builder(
                  itemCount: _cars.length,
                  itemBuilder: (context, index) {
                    final car = _cars[index];
                    return Dismissible(
                      key: ValueKey(car.id),
                      direction: DismissDirection.endToStart,
                      confirmDismiss: (_) => _deleteCar(car),
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 24),
                        color: colorScheme.error,
                        child: Icon(
                          Icons.delete_outline,
                          color: colorScheme.onError,
                        ),
                      ),
                      child: ListTile(
                        title: Text('${car.brand} ${car.model}'),
                        subtitle: Text(car.plateNumber),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => _navigateToForm(car),
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
