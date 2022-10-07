// ignore_for_file: depend_on_referenced_packages

import 'dart:collection';
// ignore: implementation_imports
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

  createUser(User user) {
    _users.add(user);
    notifyListeners();
  }

  loadUsers() {
    _users = [
      User(
        nome: 'Amanda Cristina',
        email: 'amanda@gmail.com',
        celular: '42995674122',
        senha: '123456',
      ),
      User(
        nome: 'Matheus Schmidt',
        email: 'matheus@gmail.com',
        celular: '15996916596',
        senha: '123456',
      ),
      User(
        nome: 'Marcos Correa',
        email: 'marcos@gmail.com',
        celular: '41996104989',
        senha: '123456',
      ),
      User(
        nome: 'Admin',
        email: 'a@a.com',
        celular: '42999999999',
        senha: '123456',
      ),
    ];
    notifyListeners();
  }
}
