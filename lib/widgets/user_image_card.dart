import 'package:flutter/material.dart';
import 'package:miaudote/services/auth_service.dart';
import 'package:provider/provider.dart';

class UserImageCard extends StatelessWidget {
  final String image;
  final String nome;
  final String email;
  final VoidCallback onTap;
  const UserImageCard(
      {super.key,
      required this.image,
      required this.nome,
      required this.email,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    AuthService auth = Provider.of<AuthService>(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListView(
        //physics: const NeverScrollableScrollPhysics(),
        children: [
          Stack(
            children: [
              Ink.image(
                image: AssetImage(image),
                height: 200,
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
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: ButtonBar(
              alignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: onTap,
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    primary: Colors.white,
                  ),
                  child: Text('Desabilitar'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
