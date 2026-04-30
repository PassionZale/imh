import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../database/models/user.dart';

class CurrentUserService extends ChangeNotifier {
  CurrentUserService._internal();
  static final CurrentUserService instance = CurrentUserService._internal();

  static const _key = 'user_profile';

  User? _currentUser;
  User? get currentUser => _currentUser;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(_key);
    if (json != null) {
      _currentUser = User.fromJson(
        Map<String, dynamic>.from(jsonDecode(json)),
      );
    }
  }

  Future<void> save(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(user.toJson()));
    _currentUser = user;
    notifyListeners();
  }

  Future<void> clearCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
    _currentUser = null;
    notifyListeners();
  }
}
