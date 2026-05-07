import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:imh/database/models/car_fuel_record.dart';
import 'package:imh/repositories/car_fuel_record_repository.dart';
import 'package:imh/services/llm_service.dart';
import 'package:imh/theme/app_theme.dart';

class FuelRecordFormPage extends StatefulWidget {
  final int carId;
  final CarFuelRecord? record;

  const FuelRecordFormPage({super.key, required this.carId, this.record});

  @override
  State<FuelRecordFormPage> createState() => _FuelRecordFormPageState();
}

class _FuelRecordFormPageState extends State<FuelRecordFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _litersController = TextEditingController();
  final _unitPriceController = TextEditingController();
  final _totalCostController = TextEditingController();
  final _mileageController = TextEditingController();
  late DateTime _selectedDate;
  bool _isSubmitting = false;
  bool _isRecognizing = false;
  final _repository = CarFuelRecordRepository();
  final _picker = ImagePicker();

  bool get _isEditing => widget.record != null;

  @override
  void initState() {
    super.initState();
    if (widget.record != null) {
      _litersController.text = widget.record!.liters.toString();
      _unitPriceController.text = widget.record!.unitPrice.toString();
      _totalCostController.text = widget.record!.totalCost.toString();
      _mileageController.text = widget.record!.mileage.toString();
      _selectedDate = DateTime.parse(widget.record!.date);
    } else {
      _selectedDate = DateTime.now();
    }

    _totalCostController.addListener(_autoCalculateUnitPrice);
    _litersController.addListener(_autoCalculateUnitPrice);
  }

  void _autoCalculateUnitPrice() {
    final totalCost = double.tryParse(_totalCostController.text);
    final liters = double.tryParse(_litersController.text);
    if (liters != null && liters > 0 && totalCost != null) {
      _unitPriceController.text = (totalCost / liters).toStringAsFixed(2);
    } else {
      _unitPriceController.text = '';
    }
  }

  @override
  void dispose() {
    _litersController.dispose();
    _unitPriceController.dispose();
    _totalCostController.dispose();
    _mileageController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  String get _dateStr {
    return '${_selectedDate.year.toString().padLeft(4, '0')}-'
        '${_selectedDate.month.toString().padLeft(2, '0')}-'
        '${_selectedDate.day.toString().padLeft(2, '0')}';
  }

  void _showImageSourceSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('拍照'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('从相册选择'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final image = await _picker.pickImage(
      source: source,
      maxWidth: 1024,
      imageQuality: 70,
    );
    if (image == null) return;

    setState(() => _isRecognizing = true);

    try {
      final result = await LlmService.instance
          .extractFuelData(File(image.path));

      if (!mounted) return;

      setState(() {
        if (result.totalCost != null) {
          _totalCostController.text = result.totalCost.toString();
        }
        if (result.liters != null) {
          _litersController.text = result.liters.toString();
        }
        if (result.date != null) {
          final parsed = DateTime.tryParse(result.date!);
          if (parsed != null) {
            _selectedDate = parsed;
          }
        }
      });
    } catch (e, stackTrace) {
      debugPrint('识别失败: $e');
      debugPrint(stackTrace.toString());
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('识别失败: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isRecognizing = false);
      }
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_isSubmitting) return;

    setState(() => _isSubmitting = true);

    final liters = double.parse(_litersController.text);
    final unitPrice = double.tryParse(_unitPriceController.text) ?? 0;
    final totalCost =
        double.tryParse(_totalCostController.text) ?? liters * unitPrice;
    final mileage = int.parse(_mileageController.text);

    if (_isEditing) {
      final updated = widget.record!.copyWith(
        liters: liters,
        unitPrice: unitPrice,
        totalCost: totalCost,
        mileage: mileage,
        date: _dateStr,
      );
      await _repository.update(updated);
    } else {
      final record = CarFuelRecord(
        carId: widget.carId,
        liters: liters,
        unitPrice: unitPrice,
        totalCost: totalCost,
        mileage: mileage,
        date: _dateStr,
      );
      await _repository.create(record);
    }

    if (mounted) {
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final showOcrButton = LlmService.instance.isConfigured;

    return Scaffold(
      appBar: AppBar(title: Text(_isEditing ? '编辑油耗' : '记油耗')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppTheme.spacing.lg),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Date picker
              InkWell(
                onTap: _pickDate,
                borderRadius: BorderRadius.circular(AppTheme.radius.md),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: '日期',
                    prefixIcon: Icon(Icons.calendar_today),
                  ),
                  child: Text(_dateStr, style: textTheme.bodyLarge),
                ),
              ),
              if (showOcrButton) ...[
                SizedBox(height: AppTheme.spacing.md),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _isRecognizing ? null : _showImageSourceSheet,
                    icon: _isRecognizing
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.camera_alt_outlined),
                    label: Text(_isRecognizing ? '识别中...' : '拍照识别'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppTheme.radius.md),
                      ),
                    ),
                  ),
                ),
              ],
              SizedBox(height: AppTheme.spacing.md),
              TextFormField(
                controller: _totalCostController,
                decoration: const InputDecoration(
                  labelText: '总费用（元）',
                  hintText: '如：150',
                  prefixIcon: Icon(Icons.payments_outlined),
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return '请输入总费用';
                  if (double.tryParse(value) == null) return '请输入有效数字';
                  return null;
                },
              ),
              SizedBox(height: AppTheme.spacing.md),
              TextFormField(
                controller: _litersController,
                decoration: const InputDecoration(
                  labelText: '加油量（L）',
                  hintText: '如：20',
                  prefixIcon: Icon(Icons.local_gas_station),
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return '请输入加油量';
                  if (double.tryParse(value) == null) return '请输入有效数字';
                  return null;
                },
              ),
              SizedBox(height: AppTheme.spacing.md),
              TextFormField(
                controller: _unitPriceController,
                decoration: const InputDecoration(
                  labelText: '单价（元/L）',
                  hintText: '自动计算',
                  prefixIcon: Icon(Icons.attach_money),
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                readOnly: true,
              ),
              SizedBox(height: AppTheme.spacing.md),
              TextFormField(
                controller: _mileageController,
                decoration: const InputDecoration(
                  labelText: '当前里程（km）',
                  hintText: '如：50000',
                  prefixIcon: Icon(Icons.speed),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return '请输入里程';
                  if (int.tryParse(value) == null) return '请输入有效数字';
                  return null;
                },
              ),
              SizedBox(height: AppTheme.spacing.xl),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _save,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(52),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppTheme.radius.md),
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
                          _isEditing ? '保存' : '记录',
                          style: textTheme.titleLarge?.copyWith(
                            color: colorScheme.onPrimary,
                          ),
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
