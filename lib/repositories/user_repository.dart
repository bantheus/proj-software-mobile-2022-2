import 'dart:collection';
// ignore: implementation_imports
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/src/iterable_extensions.dart';

import 'package:flutter/material.dart';
import 'package:miaudote/models/users.dart';

import '../database/db_firestore.dart';
import '../services/auth_service.dart';

class UserRepository extends ChangeNotifier {
  late FirebaseFirestore db;
  late AuthService auth;
  Users? user;

  // UnmodifiableListView<User> get users => UnmodifiableListView<User>(_users);

  UserRepository({required this.auth}) {
    loadUser();
  }

  // User? findUser(String email) =>
  //     _users.firstWhereOrNull((user) => user.email == email);

  createUser(Users user) async {
    await db.collection('usuarios').doc(auth.usuario!.uid).set({
      'nome': user.nome,
      'email': user.email,
      'celular': user.celular,
      'foto': user.foto,
      'estado': user.estado,
      'cidade': user.cidade,
      'rua': user.rua,
      'numero': user.numero
    });
    notifyListeners();
  }

  updateUser(String estado, String cidade, String rua, String numero) async {
    await db.collection('usuarios').doc(auth.usuario!.uid).update(
        {'estado': estado, 'cidade': cidade, 'rua': rua, 'numero': numero});
    notifyListeners();
  }

  findUser() async {
    if (auth.usuario != null) {
      final snapshot =
          await db.collection('usuarios').doc(auth.usuario!.uid).get();

      if (snapshot != null) {
        user = Users(
            nome: snapshot.get('nome'),
            email: snapshot.get('email'),
            celular: snapshot.get('celular'));
      }

      notifyListeners();
    }
  }

  loadUser() async {
    await _startFirestore();
    await findUser();
  }

  _startFirestore() {
    db = DBFirestore.get();
  }
}
