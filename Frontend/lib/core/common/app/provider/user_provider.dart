import 'package:flutter/foundation.dart';

import '../../entities/user.dart';

class UserProvider extends ChangeNotifier {
  UserProvider._internal();

  static final instance = UserProvider._internal();
  User? _currentUser;

  User? get currentUser => _currentUser;

  void setUser(User? user) {
    if (_currentUser != user) _currentUser = user;
  }

  void updateUser(User user) {
    if (_currentUser != user) _currentUser = user;
    notifyListeners();
  }
}
