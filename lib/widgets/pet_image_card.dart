import 'package:flutter/material.dart';

class PetImageCard extends StatelessWidget {
  final String image;
  final String nome;
  final String idade;
  final VoidCallback onTap;
  const PetImageCard(
      {super.key,
      required this.image,
      required this.nome,
      required this.idade,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListView(
        children: [
          Stack(
            children: [
              Ink.image(
                image: AssetImage(image),
                height: 240,
                fit: BoxFit.cover,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12).copyWith(bottom: 10),
            child: Column(
              children: [
                Text(
                  nome,
                  style: const TextStyle(fontSize: 30),
                ),
                int.parse(idade) > 1 ? Text("$idade ANOS") : Text("$idade ANO"),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: ButtonBar(
              alignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: onTap,
                  style: TextButton.styleFrom(
                    //foregroundColor: Colors.white,
                    backgroundColor: Colors.blue,
                  ),
                  child: const Text("Mais informações"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
