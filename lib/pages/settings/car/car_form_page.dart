import 'package:flutter/material.dart';
import '../../../database/models/car.dart';
import '../../../repositories/car_repository.dart';
import '../../../theme/app_theme.dart';

class CarFormPage extends StatefulWidget {
  final Car? car;

  const CarFormPage({super.key, this.car});

  @override
  State<CarFormPage> createState() => _CarFormPageState();
}

class _CarFormPageState extends State<CarFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _brandController = TextEditingController();
  final _modelController = TextEditingController();
  final _plateNumberController = TextEditingController();
  final _colorController = TextEditingController();
  final _yearController = TextEditingController();
  bool _isSubmitting = false;
  final _repository = CarRepository();

  bool get _isEditing => widget.car != null;

  @override
  void initState() {
    super.initState();
    if (widget.car != null) {
      _brandController.text = widget.car!.brand;
      _modelController.text = widget.car!.model;
      _plateNumberController.text = widget.car!.plateNumber;
      _colorController.text = widget.car!.color ?? '';
      _yearController.text =
          widget.car!.year?.toString() ?? '';
    }
  }

  @override
  void dispose() {
    _brandController.dispose();
    _modelController.dispose();
    _plateNumberController.dispose();
    _colorController.dispose();
    _yearController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_isSubmitting) return;

    setState(() => _isSubmitting = true);

    if (_isEditing) {
      final updated = widget.car!.copyWith(
        brand: _brandController.text,
        model: _modelController.text,
        plateNumber: _plateNumberController.text,
        color: _colorController.text.isEmpty ? null : _colorController.text,
        year: int.tryParse(_yearController.text),
      );
      await _repository.update(updated);
    } else {
      final car = Car(
        brand: _brandController.text,
        model: _modelController.text,
        plateNumber: _plateNumberController.text,
        color: _colorController.text.isEmpty ? null : _colorController.text,
        year: int.tryParse(_yearController.text),
      );
      await _repository.create(car);
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
        title: Text(_isEditing ? '编辑车辆' : '新增车辆'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _brandController,
                decoration: const InputDecoration(
                  labelText: '品牌',
                  hintText: '如：特斯拉',
                  prefixIcon: Icon(Icons.branding_watermark),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '请输入品牌';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _modelController,
                decoration: const InputDecoration(
                  labelText: '型号',
                  hintText: '如：Model Y',
                  prefixIcon: Icon(Icons.model_training),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '请输入型号';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _plateNumberController,
                decoration: const InputDecoration(
                  labelText: '车牌号',
                  hintText: '如：沪A12345',
                  prefixIcon: Icon(Icons.pin),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '请输入车牌号';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _colorController,
                decoration: const InputDecoration(
                  labelText: '颜色（选填）',
                  hintText: '如：白色',
                  prefixIcon: Icon(Icons.palette_outlined),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _yearController,
                decoration: const InputDecoration(
                  labelText: '年份（选填）',
                  hintText: '如：2024',
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                keyboardType: TextInputType.number,
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
