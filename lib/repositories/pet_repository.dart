import 'package:miaudote/models/pet.dart';
import 'package:miaudote/models/style-card.dart';

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
        styleCard: StyleCard(
          isBack: false,
        ),
      ),
      Pet(
        id: 1,
        nome: "Luna",
        imagem: "images/pinscher.jpg",
        sexo: ["Fêmea"],
        especie: ["Cachorro"],
        idade: 1,
        styleCard: StyleCard(
          isBack: false,
        ),
      ),
    ];
  }
}
