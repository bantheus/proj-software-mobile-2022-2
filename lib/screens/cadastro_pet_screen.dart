import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:miaudote/models/pet.dart';
import 'package:miaudote/services/auth_service.dart';
import 'package:provider/provider.dart';

import '../repositories/pet_repository.dart';

class CadastroPetPage extends StatefulWidget {
  const CadastroPetPage({Key? key}) : super(key: key);

  @override
  State<CadastroPetPage> createState() => _CadastroPetPageState();
}

class _CadastroPetPageState extends State<CadastroPetPage> {
  final _formKey = GlobalKey<FormState>();
  final _id = TextEditingController();
  final _nome = TextEditingController();
  final _especie = TextEditingController();
  final _descricao = TextEditingController();
  final _sexo = TextEditingController();
  final _idade = TextEditingController();
  final _status = TextEditingController();

  bool loading = false; //feedback enquanto carrega
  Random random = Random();

  cadastrar() async {
    try {
      int id = random.nextInt(3) + 1;
      setState(() => loading = true);
      final success = await context.read<PetRepository>().createPet(Pet(
          id: _id.text,
          nome: _nome.text,
          imagem:
              'images/${_especie.text.toLowerCase().contains('cac') ? 'cachorro$id' : 'gato$id'}.jpg',
          descricao: _descricao.text,
          sexo: _sexo.text,
          especie: _especie.text,
          idade: int.parse(_idade.text),
          dataAdocao: "3000-10-12",
          dataEntrada: DateTime.now().toString(),
          status: int.parse(_status.text)));
      setState(() => loading = false);

      if (success && mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(feedbackSnackbar(text: "Pet cadastrado com sucesso"));
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(feedbackSnackbar(
            text: "Este Pet já está cadastrado. Tente novamente"));
      }
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

  validarForm() {
    if (_formKey.currentState!.validate()) {
      cadastrar();
    }
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
      body: SingleChildScrollView(
        reverse: true,
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Text(
                      "Cadastre um Pet",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      //id
                      TextFormField(
                        controller: _id,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 20.0),
                          labelText: "ID",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Informe o ID';
                          }
                          return null;
                        }, //imput
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      //nome
                      TextFormField(
                        controller: _nome,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 20.0),
                          labelText: "Nome",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Informe uma descrição';
                          }
                          return null;
                        }, //imput
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: _especie,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 20.0),
                          labelText: "Espécie",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: _descricao,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 20.0),
                          labelText: "Descrição",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ), //Imput Celular
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: _idade,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 20.0),
                          labelText: "Idade",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: _sexo,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 20.0),
                          labelText: "Sexo",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      //nome
                      TextFormField(
                        controller: _status,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 20.0),
                          labelText: "Status",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Informe situação';
                          }
                          return null;
                        }, //imput
                      ),
                      const SizedBox(
                        height: 20,
                      ),

                      const SizedBox(height: 40),
                      SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () => validarForm(),
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.indigo),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: (loading)
                                ? [
                                    Padding(
                                      padding: EdgeInsets.all(10),
                                      child: SizedBox(
                                        //width: double.infinity,
                                        //height: 24,
                                        child: CircularProgressIndicator(
                                          color: Colors.white,
                                        ),
                                      ),
                                    )
                                  ]
                                : [
                                    Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Text(
                                        "Cadastrar",
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    ),
                                  ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
