import 'dart:developer';

import 'package:flutter/material.dart';
//import 'package:miaudote/models/user.dart';
import 'package:miaudote/models/pet.dart';
import 'package:miaudote/repositories/pet_repository.dart';
import 'package:miaudote/repositories/user_repository.dart';
import 'package:miaudote/screens/cadastro_pet_screen.dart';
import 'package:miaudote/screens/perfil_screen.dart';
import 'package:miaudote/screens/pet_details_page.dart';
import 'package:miaudote/screens/report_screen.dart';
import 'package:miaudote/widgets/pet_grid_view.dart';
import 'package:miaudote/widgets/pet_image_card.dart';
import 'package:provider/provider.dart';

import '../models/users.dart';
import '../services/auth_service.dart';

class HomePage extends StatefulWidget {
  //Users? usuario;
  //UserRepository usuario;
  HomePage();

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //late final List<Pet> petList;

  @override
  // void initState() {
  //   super.initState();
  //   petList = PetRepository().pets;

  // }

  ValueNotifier<bool> showDescription = ValueNotifier(true);

  openDetails(Pet pet) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PetDetailsPage(pet: pet),
      ),
    );
  }

  openPetRegister() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const CadastroPetPage()),
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
        builder: (context, repository, _) => repository.pets.isEmpty
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : PetsGridView(
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
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     openPetRegister();
      //   },
      //   child: const Icon(Icons.add),
      // ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        color: Colors.blue,
        child: IconTheme(
          data: IconThemeData(color: Theme.of(context).colorScheme.onPrimary),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () => context.read<AuthService>().logout(),
              ),
              // IconButton(
              //   icon: const Icon(Icons.search),
              //   onPressed: () {},
              // ),
              // //const SizedBox(width: 48),
              IconButton(
                icon: const Icon(Icons.multiline_chart),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          //usuario: widget.usuario
                          builder: (_) => ReportPage()));
                },
              ),
              IconButton(
                icon: const Icon(Icons.person),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        //usuario: widget.usuario
                        builder: (_) => PerfilPage()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          openPetRegister();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
