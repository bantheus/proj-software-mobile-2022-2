import 'package:miaudote/models/pet.dart';
import 'dart:collection';
import 'package:collection/src/iterable_extensions.dart';
import 'package:flutter/material.dart';


class PetRepository extends ChangeNotifier {
  List<Pet> _pets = [];

  UnmodifiableListView<Pet> get pets => UnmodifiableListView<Pet>(_pets);

  PetRepository() {
    loadPets();
  }

  loadPets() {
    _pets = [
      Pet(
        id: 0,
        nome: "Caramelo",
        imagem: "images/caramelo.jpg",
        sexo: ["Macho"],
        especie: ["Cachorro"],
        idade: 1,
      ),
      Pet(
        id: 1,
        nome: "Luna",
        imagem: "images/caramelo.jpg",
        sexo: ["Fêmea"],
        especie: ["Cachorro"],
        idade: 1,
      ),
    ];
    notifyListeners();
  }
}
