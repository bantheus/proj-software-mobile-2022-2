import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FavoritosPage extends StatefulWidget {
  @override
  State<FavoritosPage> createState() => _FavoritosPageState();
}

class _FavoritosPageState extends State<FavoritosPage> {
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
        body: SingleChildScrollView(
            reverse: true,
            child: Center(
                child: Column(children: [
              Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    // ignore: prefer_const_literals_to_create_immutables
                    children: [
                      const Text(
                        "Favoritos",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                    ],
                  ))
            ]))));
  }
}
