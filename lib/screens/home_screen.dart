import 'package:flutter/material.dart';
import 'package:miaudote/models/pet.dart';
import 'package:miaudote/repositories/pet_repository.dart';
import 'package:miaudote/widgets/pet_grid_view.dart';
import 'package:miaudote/widgets/pet_image_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final List<Pet> petList;

  @override
  void initState() {
    super.initState();
    petList = PetRepository().pets;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('MIAUDOTE')),
      ),
      body: PetsGridView(
        pets: List.from(
          petList.map(
            (Pet pet) => PetImageCard(
              image: pet.imagem,
              nome: pet.nome,
              idade: pet.idade.toString(),
              onTap: () {},
            ),
          ),
        ),
      ),
    );
  }
}
