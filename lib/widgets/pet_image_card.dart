import 'package:flutter/material.dart';
// import 'package:miaudote/models/style-card.dart';

class PetImageCard extends StatelessWidget {
  final bool isBack;
  final String image;
  final String nome;
  final String idade;
  final VoidCallback onTap;
  const PetImageCard(
      {super.key,
      required this.image,
      required this.nome,
      required this.idade,
      required this.onTap,
      required this.isBack});
  // constructor(StyleCard styleCard) {
  // isBack = styleCard.isBack;
  // }

  @override
  Widget build(BuildContext context) {
    // bool isBack = false;
    return GestureDetector(
        onHorizontalDragStart: (details) => {print(details), onTap()},
        onHorizontalDragEnd: (details) => onTap(),
        // onLongPressStart: (LongPressStartDetails details) {
        //   onTap();
        // },
        // onLongPressEnd: (details) => onTap(),
        child: isBack == false
            ? Card(
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Ink.image(
                          image: AssetImage(image),
                          height: MediaQuery.of(context).size.height * 0.2,
                          fit: BoxFit.cover,
                        ),
                      ],
                    ),
                  ],
                ),
              )
            : Card(
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12).copyWith(bottom: 10),
                      child: Column(
                        children: [
                          Text(
                            nome,
                            style: const TextStyle(fontSize: 30),
                          ),
                          Text("$idade ANO"),
                        ],
                      ),
                    ),
                  ],
                ),
              ));
  }
}
