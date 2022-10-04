import 'package:miaudote/models/pet.dart';

class PetRepository {
  List<Pet> pets = [];

  PetRepository() {
    pets = [
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
  }
}
