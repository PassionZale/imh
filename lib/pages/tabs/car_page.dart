import 'package:flutter/material.dart';
import 'package:imh/database/models/car.dart';
import 'package:imh/database/models/car_fuel_stats.dart';
import 'package:imh/repositories/car_repository.dart';
import 'package:imh/repositories/car_fuel_record_repository.dart';
import 'package:imh/components/empty/empty.dart';
import 'package:imh/theme/app_theme.dart';
import 'package:imh/pages/car/widgets/car_card.dart';

class CarPage extends StatefulWidget {
  const CarPage({super.key});

  @override
  State<CarPage> createState() => CarPageState();
}

class CarPageState extends State<CarPage> {
  final _carRepo = CarRepository();
  final _fuelRepo = CarFuelRecordRepository();
  final _refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  List<Car> _cars = [];
  Map<int, CarFuelStats> _fuelStatsMap = {};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final cars = await _carRepo.getAll();

    final fuelStatsFutures = cars
        .where((c) => c.id != null)
        .map((car) async {
      final records = await _fuelRepo.getByCar(car.id!);
      return MapEntry(car.id!, CarFuelStats.calculate(records));
    }).toList();

    final fuelStatsEntries = await Future.wait(fuelStatsFutures);
    final fuelStatsMap = Map<int, CarFuelStats>.fromEntries(fuelStatsEntries);

    if (mounted) {
      setState(() {
        _cars = cars;
        _fuelStatsMap = fuelStatsMap;
        _loading = false;
      });
    }
  }

  void refresh() {
    _refreshIndicatorKey.currentState?.show();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('车辆'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              colorScheme.surface,
              colorScheme.surfaceContainerHighest,
            ],
          ),
        ),
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                key: _refreshIndicatorKey,
                onRefresh: loadData,
                child: ListView(
                  padding: EdgeInsets.all(AppTheme.spacing.md),
                  children: _buildCarCards(),
                ),
              ),
      ),
    );
  }

  List<Widget> _buildCarCards() {
    if (_cars.isEmpty) {
      return const [
        SizedBox(
          height: 200,
          child: EmptyWidget(
            icon: Icons.directions_car_outlined,
            message: '暂无车辆',
          ),
        ),
      ];
    }
    return _cars.map((car) {
      return Padding(
        padding: EdgeInsets.only(bottom: AppTheme.spacing.md),
        child: CarCard(
          car: car,
          stats: _fuelStatsMap[car.id!] ?? const CarFuelStats(),
          onDataChanged: loadData,
        ),
      );
    }).toList();
  }
}
