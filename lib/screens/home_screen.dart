import 'package:flutter/material.dart';
import 'package:miaudote/models/user.dart';
import 'package:miaudote/models/pet.dart';
import 'package:miaudote/repositories/pet_repository.dart';
import 'package:miaudote/screens/pet_details_page.dart';
import 'package:miaudote/widgets/pet_grid_view.dart';
import 'package:miaudote/widgets/pet_image_card.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  final User user;

  const HomePage({super.key, required this.user});

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

  ValueNotifier<bool> showDescription = ValueNotifier(true);

  openDetails(Pet pet) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PetDetailsPage(pet: pet),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('MIAUDOTE')),
        automaticallyImplyLeading: false,
      ),
      body: Consumer<PetRepository>(
        builder: (context, repository, _) => PetsGridView(
          pets: List.from(
            repository.pets.map(
              (Pet pet) => PetImageCard(
                image: pet.imagem,
                nome: pet.nome,
                idade: pet.idade.toString(),
                onTap: () {
                  openDetails(pet);
                },
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        color: Colors.blue,
        child: IconTheme(
          data: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              IconButton(
                icon: const Icon(Icons.home),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {},
              ),
              const SizedBox(width: 48),
              IconButton(
                icon: const Icon(Icons.favorite),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.person),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
