import 'package:miaudote/models/pet.dart';
import 'dart:collection';
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
        descricao:
            "Caramelo é um cachorro muito carinhoso e brincalhão. Ele adora brincar com bolinhas e com os donos. Ele é muito carinhoso e adora dormir no colo dos donos.",
        sexo: ["Macho"],
        especie: ["Cachorro"],
        idade: 2,
      ),
      Pet(
        id: 1,
        nome: "Luna",
        imagem: "images/caramelo.jpg",
        descricao:
            "Luna é um cachorro muito carinhoso e brincalhão. Ele adora brincar com bolinhas e com os donos. Ele é muito carinhoso e adora dormir no colo dos donos.",
        sexo: ["Fêmea"],
        especie: ["Cachorro"],
        idade: 1,
      ),
    ];
    notifyListeners();
  }
}
