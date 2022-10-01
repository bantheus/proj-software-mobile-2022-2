import 'package:flutter/material.dart';
import 'package:miaudote/models/user.dart';
import 'package:miaudote/repositories/user_repository.dart';
import 'package:miaudote/screens/cadastro_screen.dart';
import 'package:miaudote/screens/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:collection/src/iterable_extensions.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _senha = TextEditingController();

  autenticar() {
    User? user = context.read<UserRepository>().findUser(_email.text);
    if (user != null) {
      if (user.senha == _senha.text) {
        context.read<UserRepository>().setStatus(user);

        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => HomePage(user: user)),
        );
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Senha inválida")));
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Usuário não encontrado")));
    }
  }

  validarForm() {
    if (_formKey.currentState!.validate()) {
      autenticar();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        reverse: true,
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 120.0),
                child: Container(
                    width: 250,
                    height: 150,
                    child: Image.asset('images/logo.png')),
              ),
              Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                  child: Form(
                      key: _formKey,
                      child: Column(children: [
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
                                  'Login',
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
                        TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CadastroPage(),
                                ),
                              );
                            },
                            child: Text(
                              'Ainda não tem conta? Cadastre-se agora.',
                              style: TextStyle(color: Colors.blue),
                            )),
                      ]))),
            ],
          ),
        ),
      ),
    );
  }
}
