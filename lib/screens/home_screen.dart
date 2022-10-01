import 'package:flutter/material.dart';
import 'package:miaudote/models/pet.dart';
import 'package:miaudote/models/user.dart';
import 'package:miaudote/repositories/pet_repository.dart';
import 'package:miaudote/widgets/pet_grid_view.dart';
import 'package:miaudote/widgets/pet_image_card.dart';
import 'package:miaudote/repositories/user_repository.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  final User user;

  const HomePage({super.key, required this.user});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ValueNotifier<bool> showDescription = ValueNotifier(true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text(widget.user.nome)),
      ),
      body: Consumer<PetRepository>(
        builder: (context, repository, _) => PetsGridView(
          pets: List.from(
            repository.pets.map(
              (Pet pet) => PetImageCard(
                image: pet.imagem,
                nome: pet.nome,
                idade: pet.idade.toString(),
                onTap: () {},
              ),
            ),
          ),
        ),
      ),
    );
  }
}
