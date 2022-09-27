import 'package:miaudote/models/pet.dart';

class PetRepository {
  List<Pet> pets = [];

  PetRepository() {
    pets = [
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
  }
}
