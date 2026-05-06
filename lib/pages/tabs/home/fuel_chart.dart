import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../database/models/car_fuel_record.dart';

/// 图表数据范围配置（月数）
const int maxChartMonths = 8;

enum FuelChartTab { consumption, cost }

class FuelChart extends StatefulWidget {
  final int carId;
  final Future<List<CarFuelRecord>> Function(int carId, int months)
      getRecentRecords;
  final Future<List<({String month, double totalCost})>> Function(
      int carId, int months) getMonthlyCost;

  const FuelChart({
    super.key,
    required this.carId,
    required this.getRecentRecords,
    required this.getMonthlyCost,
  });

  @override
  State<FuelChart> createState() => _FuelChartState();
}

class _FuelChartState extends State<FuelChart> {
  FuelChartTab _currentTab = FuelChartTab.consumption;

  // 油耗数据
  List<CarFuelRecord>? _consumptionData;

  // 油费数据
  List<({String month, double totalCost})>? _costData;

  // 柱状图触摸高亮
  int? _touchedBarIndex;

  bool get _isLoading =>
      (_currentTab == FuelChartTab.consumption &&
          _consumptionData == null) ||
      (_currentTab == FuelChartTab.cost && _costData == null);

  @override
  void initState() {
    super.initState();
    _loadConsumption();
  }

  Future<void> _loadConsumption() async {
    final data =
        await widget.getRecentRecords(widget.carId, maxChartMonths);
    if (mounted) {
      setState(() => _consumptionData = data);
    }
  }

  Future<void> _loadCost() async {
    final data = await widget.getMonthlyCost(widget.carId, maxChartMonths);
    if (mounted) {
      setState(() {
        _costData = data;
      });
    }
  }

  void _onTabChanged(FuelChartTab tab) {
    if (tab == _currentTab) return;
    setState(() => _currentTab = tab);
    if (tab == FuelChartTab.consumption) {
      _loadConsumption();
    } else {
      _loadCost();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTabs(),
        const SizedBox(height: 20),
        _buildChartArea(),
      ],
    );
  }

  Widget _buildTabs() {
    return Row(
      children: [
        _buildTab('油耗', FuelChartTab.consumption),
        const SizedBox(width: 8),
        _buildTab('油费', FuelChartTab.cost),
      ],
    );
  }

  Widget _buildTab(String label, FuelChartTab tab) {
    final colorScheme = Theme.of(context).colorScheme;
    final selected = _currentTab == tab;
    return GestureDetector(
      onTap: () => _onTabChanged(tab),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? colorScheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? colorScheme.primary : colorScheme.outline,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: selected ? colorScheme.onPrimary : colorScheme.onSurfaceVariant,
          ),
        ),
      ),
    );
  }

  Widget _buildChartArea() {
    if (_isLoading) {
      return const SizedBox(
        height: 180,
        child: Center(
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }

    if (_currentTab == FuelChartTab.consumption) {
      final data = _consumptionData ?? [];
      if (data.isEmpty) return const SizedBox.shrink();
      return _buildConsumptionChart(data);
    } else {
      final data = _costData ?? [];
      if (data.isEmpty) return const SizedBox.shrink();
      return _buildCostChart(data);
    }
  }

  Widget _buildConsumptionChart(List<CarFuelRecord> records) {
    final colorScheme = Theme.of(context).colorScheme;
    final spots = <FlSpot>[];
    final labels = <int, String>{};
    // tooltip 用的完整日期
    final tooltipLabels = <int, String>{};
    // 追踪已显示的月份，同月只标一次
    final shownMonths = <String>{};
    for (int i = 0; i < records.length; i++) {
      final r = records[i];
      if (r.consumption != null) {
        spots.add(FlSpot(i.toDouble(), r.consumption!));
        tooltipLabels[i] = _formatDateLabel(r.date);
        final monthKey = r.date.substring(0, 7); // YYYY-MM
        if (shownMonths.add(monthKey)) {
          labels[i] = _formatMonthLabel(r.date);
        }
      }
    }

    if (spots.isEmpty) return const SizedBox.shrink();

    final yValues = spots.map((s) => s.y).toList();
    final minY = (yValues.reduce((a, b) => a < b ? a : b) * 0.8).floorToDouble();
    final maxY = (yValues.reduce((a, b) => a > b ? a : b) * 1.2).ceilToDouble();

    return SizedBox(
      height: 180,
      child: LineChart(
        LineChartData(
          minY: minY,
          maxY: maxY,
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: (maxY - minY) > 5 ? ((maxY - minY) / 4) : 1,
            getDrawingHorizontalLine: (value) => FlLine(
              color: colorScheme.outline.withValues(alpha: 0.5),
              strokeWidth: 1,
            ),
          ),
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 36,
                getTitlesWidget: (value, meta) => Text(
                  value.toStringAsFixed(value == value.roundToDouble() ? 0 : 1),
                  style: TextStyle(
                    fontSize: 10,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 18,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  final label = labels[value.toInt()];
                  if (label == null) return const SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      label,
                      style: TextStyle(
                        fontSize: 10,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: colorScheme.primary,
              barWidth: 2,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) =>
                    FlDotCirclePainter(
                  radius: 3,
                  color: colorScheme.primary,
                  strokeWidth: 1.5,
                  strokeColor: colorScheme.onPrimary,
                ),
              ),
              belowBarData: BarAreaData(
                show: true,
                color: colorScheme.primary.withValues(alpha: 0.08),
              ),
            ),
          ],
          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              getTooltipColor: (_) => colorScheme.onSurface,
              getTooltipItems: (spots) => spots.map((spot) {
                final label = tooltipLabels[spot.x.toInt()] ?? '';
                return LineTooltipItem(
                  '$label\n油耗 ${spot.y.toStringAsFixed(2)}',
                  TextStyle(
                    color: colorScheme.surface,
                    fontSize: 12,
                    height: 1.5,
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCostChart(List<({String month, double totalCost})> data) {
    final colorScheme = Theme.of(context).colorScheme;
    final barGroups = <BarChartGroupData>[];
    for (int i = 0; i < data.length; i++) {
      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: data[i].totalCost,
              color: i == _touchedBarIndex
                  ? colorScheme.primary
                  : colorScheme.primary.withValues(alpha: 0.3),
              width: data.length > 8 ? 16 : 24,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(4),
              ),
            ),
          ],
        ),
      );
    }

    if (barGroups.isEmpty) return const SizedBox.shrink();

    final maxY = data
            .map((d) => d.totalCost)
            .reduce((a, b) => a > b ? a : b) *
        1.2;

    return SizedBox(
      height: 180,
      child: BarChart(
        BarChartData(
          maxY: maxY,
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: maxY > 4 ? maxY / 4 : 1,
            getDrawingHorizontalLine: (value) => FlLine(
              color: colorScheme.outline.withValues(alpha: 0.5),
              strokeWidth: 1,
            ),
          ),
          titlesData: FlTitlesData(
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) => Text(
                  value >= 1000 ? '${(value / 1000).toStringAsFixed(1)}k' : value.round().toString(),
                  style: TextStyle(
                    fontSize: 10,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 22,
                getTitlesWidget: (value, meta) {
                  final i = value.toInt();
                  if (i < 0 || i >= data.length) return const SizedBox.shrink();
                  final parts = data[i].month.split('-');
                  final month = int.parse(parts[1]);
                  return Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      '$month月',
                      style: TextStyle(
                        fontSize: 10,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          barGroups: barGroups,
          barTouchData: BarTouchData(
            touchCallback: (event, response) {
              if (event is FlPanEndEvent || event is FlPanCancelEvent) {
                setState(() => _touchedBarIndex = null);
              } else {
                final index = response?.spot?.touchedBarGroupIndex;
                if (index != null && index != _touchedBarIndex) {
                  setState(() => _touchedBarIndex = index);
                }
              }
            },
            touchTooltipData: BarTouchTooltipData(
              getTooltipColor: (_) => colorScheme.onSurface,
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                final parts = data[groupIndex].month.split('-');
                final month = int.parse(parts[1]);
                return BarTooltipItem(
                  '$month月\n油费 ${rod.toY.toStringAsFixed(2)}',
                  TextStyle(
                    color: colorScheme.surface,
                    fontSize: 12,
                    height: 1.5,
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  /// 将 YYYY-MM-DD 格式化为 M月D日（不补零）
  String _formatDateLabel(String date) {
    final parts = date.split('-');
    final month = int.parse(parts[1]);
    final day = int.parse(parts[2]);
    return '$month月$day日';
  }

  /// 将 YYYY-MM-DD 格式化为 M月（不补零）
  String _formatMonthLabel(String date) {
    final parts = date.split('-');
    final month = int.parse(parts[1]);
    return '$month月';
  }
}
