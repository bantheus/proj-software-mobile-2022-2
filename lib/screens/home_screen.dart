import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//import 'package:miaudote/models/user.dart';
import 'package:miaudote/models/pet.dart';
import 'package:miaudote/repositories/pet_repository.dart';
import 'package:miaudote/repositories/user_repository.dart';
import 'package:miaudote/screens/cadastro_pet_screen.dart';
import 'package:miaudote/screens/favoritos_screen.dart';
import 'package:miaudote/screens/perfil_screen.dart';
import 'package:miaudote/screens/pet_details_page.dart';
import 'package:miaudote/screens/report_screen.dart';
import 'package:miaudote/screens/users_screen.dart';
import 'package:miaudote/widgets/pet_grid_view.dart';
import 'package:miaudote/widgets/pet_image_card.dart';
import 'package:provider/provider.dart';

import '../models/users.dart';
import '../services/auth_service.dart';

class HomePage extends StatefulWidget {
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
        builder: (_) => PetDetailsPage(
          pet: pet,
        ),
      ),
    );
  }

  openPetRegister() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const CadastroPetPage()),
    );
  }

  ValueNotifier<bool> isDog = ValueNotifier(true);
  ValueNotifier<bool> isCat = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    AuthService auth = Provider.of<AuthService>(context);

    double iconSize = 40.0;
    final activeDog = SizedBox(
      height: iconSize,
      child: FaIcon(
        FontAwesomeIcons.dog,
        size: iconSize,
        color: Colors.orange,
      ),
    );

    final hiddenDog = SizedBox(
      height: iconSize,
      child: FaIcon(
        FontAwesomeIcons.dog,
        size: iconSize,
        color: Colors.white,
      ),
    );

    final activeCat = SizedBox(
      height: iconSize,
      child: FaIcon(
        FontAwesomeIcons.cat,
        size: iconSize,
        color: Colors.orange,
      ),
    );

    final hiddenCat = SizedBox(
      height: iconSize,
      child: FaIcon(
        FontAwesomeIcons.cat,
        size: iconSize,
        color: Colors.white,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('MIAUDOTE')),
        automaticallyImplyLeading: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ValueListenableBuilder(
                valueListenable: isDog,
                builder: (context, value, child) {
                  return IconButton(
                    iconSize: iconSize,
                    icon: isDog.value ? activeDog : hiddenDog,
                    onPressed: () {
                      setState(() {
                        isDog.value = true;
                        isCat.value = false;
                      });
                    },
                  );
                },
              ),
              ValueListenableBuilder(
                valueListenable: isCat,
                builder: (context, value, child) {
                  return IconButton(
                    iconSize: iconSize,
                    icon: isCat.value ? activeCat : hiddenCat,
                    onPressed: () {
                      setState(() {
                        isCat.value = true;
                        isDog.value = false;
                      });
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
      body: Consumer<PetRepository>(
        builder: (context, repository, _) => repository.pets.isEmpty
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ValueListenableBuilder(
                valueListenable: isDog,
                builder: (context, bool show, _) {
                  return PetsGridView(
                    pets: List.from(
                      show
                          ? repository.pets
                              .where((pet) =>
                                  pet.especie == "cachorro" &&
                                  (auth.usuario?.email != 'admin@admin.com'
                                      ? pet.status == 0
                                      : pet.status != 2))
                              .map(
                                (Pet pet) => PetImageCard(
                                  image: pet.imagem,
                                  nome: pet.nome,
                                  idade: pet.idade.toString(),
                                  onTap: () {
                                    openDetails(pet);
                                  },
                                ),
                              )
                          : repository.pets
                              .where((pet) =>
                                  pet.especie == "gato" &&
                                  (auth.usuario?.email != 'admin@admin.com'
                                      ? pet.status == 0
                                      : pet.status != 2))
                              .map(
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
                  );
                }),
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
        color: Colors.indigo,
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
                icon: auth.usuario?.email == 'admin@admin.com'
                    ? const Icon(Icons.multiline_chart)
                    : const Icon(Icons.favorite),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          //usuario: widget.usuario
                          builder: (_) =>
                              auth.usuario?.email == 'admin@admin.com'
                                  ? ReportPage()
                                  : FavoritosPage()));
                },
              ),
              IconButton(
                icon: const Icon(Icons.person),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        //usuario: widget.usuario
                        builder: (_) => auth.usuario?.email == 'admin@admin.com'
                            ? UsersPage()
                            : PerfilPage()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: auth.usuario?.email != 'admin@admin.com'
          ? Container()
          : FloatingActionButton(
              onPressed: () {
                openPetRegister();
              },
              child: const Icon(Icons.add),
            ),
    );
  }
}
