import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FuelOcrResult {
  final String? date;
  final double? totalCost;
  final double? liters;

  FuelOcrResult({this.date, this.totalCost, this.liters});
}

class LlmService extends ChangeNotifier {
  LlmService._internal();
  static final LlmService instance = LlmService._internal();

  static const _keyBaseUrl = 'LLM_BASE_URL';
  static const _keyModelId = 'LLM_MODEL_ID';
  static const _keyApiKey = 'LLM_API_KEY';

  String _baseUrl = '';
  String _modelId = '';
  String _apiKey = '';

  String get baseUrl => _baseUrl;
  String get modelId => _modelId;
  String get apiKey => _apiKey;

  bool get isConfigured =>
      _baseUrl.isNotEmpty && _modelId.isNotEmpty && _apiKey.isNotEmpty;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _baseUrl = prefs.getString(_keyBaseUrl) ?? '';
    _modelId = prefs.getString(_keyModelId) ?? '';
    _apiKey = prefs.getString(_keyApiKey) ?? '';
  }

  Future<void> save({
    required String baseUrl,
    required String modelId,
    required String apiKey,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyBaseUrl, baseUrl);
    await prefs.setString(_keyModelId, modelId);
    await prefs.setString(_keyApiKey, apiKey);
    _baseUrl = baseUrl;
    _modelId = modelId;
    _apiKey = apiKey;
    notifyListeners();
  }

  static const _prompt = '''你是一个加油信息提取助手。请分析图片，提取以下字段：

- date: 加油日期，格式 YYYY-MM-DD。没有则返回 null
- total_cost: 实付金额（元），纯数字。没有则返回 null
- liters: 加油量（升），纯数字。没有则返回 null

严格以如下 JSON 格式返回，不要包含任何其他文字：
{"date": "2024-01-15", "total_cost": 150.00, "liters": 20.45}

无法识别的字段值设为 null。''';

  Future<FuelOcrResult> extractFuelData(File imageFile) async {
    final bytes = await imageFile.readAsBytes();
    final base64Image = base64Encode(bytes);

    final uri = Uri.parse('$_baseUrl/chat/completions');
    final client = HttpClient();

    try {
      final request = await client.postUrl(uri);
      request.headers.set('Content-Type', 'application/json');
      request.headers.set('Authorization', 'Bearer $_apiKey');

      final body = jsonEncode({
        'model': _modelId,
        'thinking': {'type': 'disabled'},
        'stream': false,
        'messages': [
          {
            'role': 'user',
            'content': [
              {'type': 'text', 'text': _prompt},
              {
                'type': 'image_url',
                'image_url': {
                  'url': 'data:image/jpeg;base64,$base64Image',
                },
              },
            ],
          },
        ],
      });

      request.add(utf8.encode(body));
      final response = await request.close();
      final responseBody =
          await response.transform(utf8.decoder).join();

      debugPrint('API 响应: ${response.statusCode}');
      debugPrint('响应体: $responseBody');

      if (response.statusCode != 200) {
        throw Exception('API 请求失败: ${response.statusCode}');
      }

      final json = jsonDecode(responseBody) as Map<String, dynamic>;
      final content =
          json['choices'][0]['message']['content'] as String;

      // Extract JSON from content (may be wrapped in markdown code block)
      final jsonStr = _extractJson(content);
      final data = jsonDecode(jsonStr) as Map<String, dynamic>;
      debugPrint('解析结果: $data');

      return FuelOcrResult(
        date: data['date'] as String?,
        totalCost: (data['total_cost'] as num?)?.toDouble(),
        liters: (data['liters'] as num?)?.toDouble(),
      );
    } finally {
      client.close();
    }
  }

  String _extractJson(String content) {
    // Try to extract JSON from markdown code block
    final match = RegExp(r'```(?:json)?\s*([\s\S]*?)```').firstMatch(content);
    if (match != null) {
      return match.group(1)!.trim();
    }
    return content.trim();
  }
}
