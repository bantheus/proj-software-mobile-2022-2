import 'dart:collection';
import 'package:collection/src/iterable_extensions.dart';

import 'package:flutter/material.dart';
import 'package:miaudote/models/user.dart';

class UserRepository extends ChangeNotifier {
  List<User> _users = [];

  UnmodifiableListView<User> get users => UnmodifiableListView<User>(_users);

  UserRepository() {
    loadUsers();
  }

  User? findUser(String email) =>
      _users.firstWhereOrNull((user) => user.email == email);

  setStatus(User user) {
    user.status = true;
    notifyListeners();
  }

  createUser(User user){
    _users.add(user);
    notifyListeners();
  }

  loadUsers() {
    _users = [
      User(
          nome: 'Amanda Cristina',
          email: 'amanda@gmail.com',
          celular: '42995674122',
          senha: '123456'),
      User(
          nome: 'Amanda Cristina',
          email: 'amanda@gmail.com',
          celular: '42995674122',
          senha: '123456')
    ];
    notifyListeners();
  }
}
