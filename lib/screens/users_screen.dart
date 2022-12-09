import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:miaudote/models/users.dart';
import 'package:miaudote/repositories/user_repository.dart';
import 'package:miaudote/screens/cadastro_pet_screen.dart';
import 'package:miaudote/widgets/pet_grid_view.dart';
import 'package:miaudote/widgets/user_image_card.dart';
import 'package:provider/provider.dart';

class UsersPage extends StatefulWidget {
  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  openPetRegister() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const CadastroPetPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: Colors.black,
          ),
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      // body: SingleChildScrollView(
      //     reverse: true,
      //     child: Center(
      //         child: Column(children: [
      //       Padding(
      //           padding: const EdgeInsets.only(top: 10.0),
      //           child: Column(
      //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //             // ignore: prefer_const_literals_to_create_immutables
      //             children: [
      //               const Text(
      //                 "Usuários",
      //                 style: TextStyle(
      //                   fontSize: 30,
      //                   fontWeight: FontWeight.bold,
      //                 ),
      //               ),
      //               const SizedBox(
      //                 height: 30,
      //               ),
      //             ],
      //           ))
      //     ])))
      body: Consumer<UserRepository>(
        builder: (context, repository, _) => repository.users.isEmpty
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : PetsGridView(
                pets: List.from(repository.users.map(
                  (Users pet) => UserImageCard(
                    image: pet.foto,
                    nome: pet.nome,
                    email: pet.email,
                    onTap: () {
                      //openDetails(pet);
                    },
                  ),
                )),
              ),
      ),
    );
  }
}
