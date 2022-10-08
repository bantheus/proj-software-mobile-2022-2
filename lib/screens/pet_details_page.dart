import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:miaudote/models/pet.dart';

class PetDetailsPage extends StatefulWidget {
  final Pet pet;

  const PetDetailsPage({super.key, required this.pet});

  @override
  State<PetDetailsPage> createState() => _PetDetailsPageState();
}

class _PetDetailsPageState extends State<PetDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.pet.nome),
        elevation: 0,
        backgroundColor: Colors.black45,
        foregroundColor: Colors.white,
      ),
      body: Stack(
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
                        if (widget.pet.especie.toString() == '[Cachorro]') ...[
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
                        if (widget.pet.sexo.toString() == '[Macho]') ...[
                          const FaIcon(
                            FontAwesomeIcons.mars,
                            color: Colors.blue,
                          ),
                          const SizedBox(width: 20),
                          const Text(
                            'e sou macho',
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
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: ButtonBar(
                        alignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            //send a whatsapp message to the pet owner
                            onPressed: () {},

                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.blue,
                              minimumSize: const Size(500, 50),
                            ),
                            child: const Text(
                              "Adotar",
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
      ),
    );
  }
}
