import 'package:flutter/material.dart';
import 'package:imh/services/llm_service.dart';
import 'package:imh/theme/app_theme.dart';

class EnvSettingsPage extends StatefulWidget {
  const EnvSettingsPage({super.key});

  @override
  State<EnvSettingsPage> createState() => _EnvSettingsPageState();
}

class _EnvSettingsPageState extends State<EnvSettingsPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _baseUrlController;
  late final TextEditingController _modelIdController;
  late final TextEditingController _apiKeyController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final llm = LlmService.instance;
    _baseUrlController = TextEditingController(text: llm.baseUrl);
    _modelIdController = TextEditingController(text: llm.modelId);
    _apiKeyController = TextEditingController(text: llm.apiKey);
  }

  @override
  void dispose() {
    _baseUrlController.dispose();
    _modelIdController.dispose();
    _apiKeyController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_isSaving) return;

    setState(() => _isSaving = true);

    await LlmService.instance.save(
      baseUrl: _baseUrlController.text.trim(),
      modelId: _modelIdController.text.trim(),
      apiKey: _apiKeyController.text.trim(),
    );

    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('环境变量')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppTheme.spacing.lg),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _baseUrlController,
                decoration: const InputDecoration(
                  labelText: 'LLM_BASE_URL',
                  hintText: '如：https://api.openai.com/v1',
                  prefixIcon: Icon(Icons.link),
                ),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? '请输入 Base URL' : null,
              ),
              SizedBox(height: AppTheme.spacing.md),
              TextFormField(
                controller: _modelIdController,
                decoration: const InputDecoration(
                  labelText: 'LLM_MODEL_ID',
                  hintText: '如：gpt-4o',
                  prefixIcon: Icon(Icons.model_training),
                ),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? '请输入 Model ID' : null,
              ),
              SizedBox(height: AppTheme.spacing.md),
              TextFormField(
                controller: _apiKeyController,
                decoration: const InputDecoration(
                  labelText: 'LLM_API_KEY',
                  hintText: '如：sk-xxx',
                  prefixIcon: Icon(Icons.key),
                ),
                obscureText: true,
                validator: (v) =>
                    v == null || v.trim().isEmpty ? '请输入 API Key' : null,
              ),
              SizedBox(height: AppTheme.spacing.xl),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _save,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(52),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppTheme.radius.md),
                    ),
                  ),
                  child: _isSaving
                      ? SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: colorScheme.onPrimary,
                          ),
                        )
                      : Text('保存', style: textTheme.titleLarge?.copyWith(
                          color: colorScheme.onPrimary,
                        )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
