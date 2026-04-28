import 'package:flutter/foundation.dart';
import '../database/models/user.dart';
import '../repositories/user_repository.dart';

class CurrentUserService extends ChangeNotifier {
  CurrentUserService._internal();
  static final CurrentUserService instance = CurrentUserService._internal();

  User? _currentUser;
  User? get currentUser => _currentUser;

  Future<void> init() async {
    final repo = UserRepository();
    final users = await repo.getAll();
    if (users.isNotEmpty) {
      _currentUser = users.first;
    }
  }

  void setCurrentUser(User user) {
    _currentUser = user;
    notifyListeners();
  }

  Future<void> createAndSetUser(User user) async {
    final repo = UserRepository();
    _currentUser = await repo.create(user);
    notifyListeners();
  }

  void clearCurrentUser() {
    _currentUser = null;
    notifyListeners();
  }
}
