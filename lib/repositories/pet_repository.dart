import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:miaudote/models/pet.dart';
import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../database/db_firestore.dart';

class PetRepository extends ChangeNotifier {
  late FirebaseFirestore db;
  List<Pet> _pets = [];

  UnmodifiableListView<Pet> get pets => UnmodifiableListView<Pet>(_pets);

  PetRepository() {
    loadPets();
  }

  loadPets() async {
    await _startFirestore();
    await readPets();
  }

  _startFirestore() {
    db = DBFirestore.get();
  }

  readPets() async {
    if (_pets.isEmpty) {
      final snapshot = await db.collection('pets').get();

      snapshot.docs.forEach((doc) {
        final pet = Pet(
            id: doc.get('id'),
            nome: doc.get('nome'),
            imagem: doc.get('imagem'),
            descricao: doc.get('descricao'),
            sexo: doc.get('sexo'),
            especie: doc.get('especie'),
            idade: doc.get('idade'),
            dataEntrada: doc.get('dataEntrada'),
            dataAdocao: doc.get('dataAdocao'),
            status: doc.get('status'));

        _pets.add(pet);
        notifyListeners();
      });
    }
  }

  Future<bool> createPet(Pet pet) async {
    if (!_pets.any((atual) => atual.id == pet.id)) {
      _pets.add(pet);
      await db.collection('pets').doc(pet.id).set({
        'id': pet.id,
        'nome': pet.nome,
        'imagem': pet.imagem,
        'descricao': pet.descricao,
        'sexo': pet.sexo,
        'especie': pet.especie,
        'idade': pet.idade,
        'dataEntrada': pet.dataEntrada,
        'dataAdocao': pet.dataAdocao,
        'status': pet.status
      });
      notifyListeners();
      return true;
    } else {
      return false;
    }
  }

  changeStatus(String id) async {
    _pets[_pets.indexWhere((item) => item.id == id)].status = 1;
    await db.collection('pets').doc(id).update({'status': 1});
    notifyListeners();
  }

  getHistoricoPet() {
    final entradas = SplayTreeMap<DateTime, double>();

    for (var pet in _pets) {
      DateTime parseDt = DateTime.parse(pet.dataEntrada);
      var newFormat = DateFormat("yyyy/MM/01");
      String updatedDt = newFormat.format(parseDt);
      DateTime data = DateFormat('yyyy/MM/dd').parse(updatedDt);
      //"${parseDt.month}/${parseDt.year}";
      if (!entradas.containsKey(data)) {
        entradas[data] = 1;
      } else {
        entradas.update(data, (value) => value + 1);
      }
    }
    return entradas;
  }
}
