import 'package:flutter/material.dart';
import 'package:miaudote/models/user.dart';
import 'package:miaudote/screens/login_screen.dart';
import 'package:provider/provider.dart';

import '../repositories/user_repository.dart';

class CadastroPage extends StatefulWidget {
  const CadastroPage({Key? key}) : super(key: key);

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final _formKey = GlobalKey<FormState>();
  final _nome = TextEditingController();
  final _email = TextEditingController();
  final _celular = TextEditingController();
  final _senha = TextEditingController();

  cadastrar() {
    User? user = context.read<UserRepository>().findUser(_email.text);
    if (user == null) {
      context.read<UserRepository>().createUser(
            User(
              nome: _nome.text,
              email: _email.text,
              celular: _celular.text,
              senha: _senha.text,
            ),
          );
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Cadastro com sucesso")));
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => LoginPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Este email já está cadastrado")));
    }
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
          brightness: Brightness.light,
          backgroundColor: Colors.white,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_ios,
                size: 20,
                color: Colors.black,
              ))),
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
                    Text(
                      "Cadastre-se",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Encontre um novo amigo",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey[700],
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    )
                  ],
                ),
              ),
              Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                  child: Form(
                      key: _formKey,
                      child: Column(children: [
                        TextFormField(
                            controller: _nome,
                            keyboardType: TextInputType.name,
                            decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 20.0),
                              labelText: "Nome",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Informe o seu Nome';
                              }
                              return null;
                            } //imput
                            ),
                        SizedBox(
                          height: 20,
                        ),

                        TextFormField(
                            controller: _email,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 20.0),
                              labelText: "E-mail",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            validator: (value) {
                              String pattern =
                                  r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                              RegExp regExp = new RegExp(pattern);
                              if (value!.isEmpty) {
                                return 'Informe o email';
                              }
                              if (!regExp.hasMatch(value)) {
                                return "Email inválido";
                              }
                              return null;
                            }),
                        SizedBox(
                          height: 20,
                        ),

                        TextFormField(
                            controller: _celular,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 20.0),
                              labelText: "Celular",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            validator: (value) {
                              String mask = r'(^(?:[+0]9)?[0-9]{10,12}$)';
                              RegExp regExp = RegExp(mask);
                              if (value!.isEmpty) {
                                return 'Informe o Celular';
                              }
                              if (!regExp.hasMatch(value)) {
                                return "Celular inválido";
                              }
                              return null;
                            }), //Imput Celular
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                            controller: _senha,
                            obscureText: true,
                            decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.symmetric(horizontal: 20.0),
                              labelText: "Senha",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Informe a senha';
                              }
                              if (value.length < 6) {
                                return 'A senha deve ter no mínimo 6 caracteres';
                              } else
                                return null;
                            } //imput
                            ),
                        SizedBox(
                          height: 40,
                        ),
                        Container(
                          height: 40,
                          child: ElevatedButton(
                            onPressed: () => validarForm(),
                            child: Container(
                                width: double.infinity,
                                child: Text(
                                  'Cadastrar',
                                  textAlign: TextAlign.center,
                                )),
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all<Color>(Colors.red),
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 40,
                        ),
                      ]))),
            ],
          ),
        ),
      ),
    );
  }
}
