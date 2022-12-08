import 'dart:convert';
import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miaudote/models/pet.dart';
import 'package:miaudote/models/users.dart';
import 'package:miaudote/repositories/pet_repository.dart';
import 'package:miaudote/services/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../repositories/user_repository.dart';

class PetDetailsPage extends StatefulWidget {
  final Pet pet;

  const PetDetailsPage({
    Key? key,
    required this.pet,
  }) : super(key: key);

  @override
  State<PetDetailsPage> createState() => _PetDetailsPageState();
}

class _PetDetailsPageState extends State<PetDetailsPage> {
  List<String> tutores = [];

  late UserRepository repositorioUsers;

  bool loading = false; //feedback enquanto carrega
  final ValueNotifier<bool> searching = ValueNotifier(false);
  String selectedTutor = "ong";
  final ValueNotifier<bool> load = ValueNotifier(false);
  late Users user;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getUser();
    getUsers();
    selectedTutor = widget.pet.tutor;
  }

  getUser() async {
    try {
      load.value = true;
      user = await context.read<UserRepository>().findUser();
      if (user != null && mounted) {
        load.value = false;
      }
    } on Exception catch (e) {
      load.value = false;
      ScaffoldMessenger.of(context).showSnackBar(feedbackSnackbar(text: e));
    }
  }

  getUsers() async {
    try {
      searching.value = true;
      tutores = await context.read<UserRepository>().readUsers();
      if (tutores != null && mounted) {
        searching.value = false;
      }
    } on Exception catch (e) {
      searching.value = false;
      ScaffoldMessenger.of(context).showSnackBar(feedbackSnackbar(text: e));
    }
  }

  alterarStatus(String newTutor) async {
    try {
      print(newTutor);
      setState(() => loading = true);
      await context.read<PetRepository>().changeStatus(widget.pet.id, newTutor);
      setState(() => loading = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(feedbackSnackbar(text: "Pet adotado com sucesso"));
    } on AuthException catch (e) {
      setState(() => loading = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(feedbackSnackbar(text: e.message));
    }
  }

  feedbackSnackbar({text}) {
    return SnackBar(
      //behavior: SnackBarBehavior.floating,
      content: Text(text),
      duration: Duration(milliseconds: 3000),
      action: SnackBarAction(
        label: 'OK',
        onPressed: () {},
      ),
    );
  }

  openWhatsApp({nome, pet}) async {
    var number = "5515996916596";
    var whatsappUrl =
        "https://wa.me/$number?text=Olá, me chamo $nome e gostaria de adotar o pet $pet";
    await launch(whatsappUrl)
        ? launch(whatsappUrl)
        : print("Não foi possível abrir o WhatsApp");
  }

  @override
  Widget build(BuildContext context) {
    //String selectedTutor = widget.pet.tutor;
    AuthService auth = Provider.of<AuthService>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.pet.nome),
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 20,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: ValueListenableBuilder(
          valueListenable: searching,
          builder: (context, bool isLoading, _) {
            if (isLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return Stack(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Image.asset(
                    widget.pet.imagem,
                    fit: BoxFit.fitWidth,
                    alignment: Alignment.topCenter,
                  ),
                ),
                ListView(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 270),
                      padding: const EdgeInsets.all(20),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              widget.pet.nome,
                              style: const TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            widget.pet.descricao,
                            style: const TextStyle(
                              fontSize: 20,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              const SizedBox(width: 10),
                              if (widget.pet.especie.toString().toLowerCase() ==
                                  'cachorro') ...[
                                const FaIcon(
                                  FontAwesomeIcons.dog,
                                  color: Colors.orange,
                                ),
                                const SizedBox(width: 15),
                                const Text(
                                  'Sou um cachorrinho',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.grey,
                                  ),
                                ),
                              ] else ...[
                                const FaIcon(
                                  FontAwesomeIcons.cat,
                                  color: Colors.orange,
                                ),
                                const SizedBox(width: 15),
                                const Text(
                                  'Eu sou um gatinho',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              const SizedBox(width: 10),
                              if (widget.pet.idade == 1) ...[
                                const FaIcon(
                                  FontAwesomeIcons.cakeCandles,
                                  color: Colors.green,
                                ),
                                const SizedBox(width: 20),
                                const Text(
                                  '1 ano',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.grey,
                                  ),
                                ),
                              ] else ...[
                                const FaIcon(
                                  FontAwesomeIcons.cakeCandles,
                                  color: Colors.green,
                                ),
                                const SizedBox(width: 20),
                                Text(
                                  "Tenho ${widget.pet.idade} anos",
                                  style: const TextStyle(
                                    fontSize: 20,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              const SizedBox(width: 10),
                              if (widget.pet.sexo.toString() == 'macho') ...[
                                const FaIcon(
                                  FontAwesomeIcons.mars,
                                  color: Colors.blue,
                                ),
                                const SizedBox(width: 20),
                                const Text(
                                  'Sou macho',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.grey,
                                  ),
                                ),
                              ] else ...[
                                const FaIcon(
                                  FontAwesomeIcons.venus,
                                  color: Colors.pink,
                                ),
                                const SizedBox(width: 20),
                                const Text(
                                  'e sou fêmea',
                                  style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ],
                          ),
                          const SizedBox(height: 20),
                          auth.usuario?.email != "admin@admin.com"
                              ? Container()
                              : Row(children: [
                                  const SizedBox(width: 10),
                                  const FaIcon(
                                    FontAwesomeIcons.user,
                                    color: Colors.pink,
                                  ),
                                  const SizedBox(width: 20),
                                  const Text(
                                    'Meu tutor',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  DropdownButton<String>(
                                    value: selectedTutor,
                                    icon: const Icon(Icons.arrow_drop_down),
                                    iconSize: 20,
                                    elevation: 40,
                                    // underline: Container(),
                                    style: const TextStyle(
                                        fontSize: 20, color: Colors.grey),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        selectedTutor = newValue!;
                                      });
                                    },
                                    items: List.generate(
                                      tutores.length,
                                      (index) => DropdownMenuItem(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(tutores[index]),
                                        ),
                                        value: tutores[index],
                                      ),
                                    ),
                                  ),
                                ]),
                          const SizedBox(height: 50),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: ButtonBar(
                              alignment: MainAxisAlignment.center,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    auth.usuario?.email == 'admin@admin.com'
                                        ? alterarStatus(selectedTutor)
                                        : openWhatsApp(
                                            nome: user.nome,
                                            pet: widget.pet.nome);
                                  },
                                  style: TextButton.styleFrom(
                                    backgroundColor: Colors.indigo,
                                    primary: Colors.white,
                                    minimumSize: const Size(500, 50),
                                  ),
                                  child: Text(
                                    auth.usuario?.email != 'admin@admin.com'
                                        ? "Adotar"
                                        : "Adotado",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            );
          }),
    );
  }
}
