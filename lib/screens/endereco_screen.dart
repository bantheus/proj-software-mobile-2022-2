import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:miaudote/screens/home_screen.dart';
import 'package:miaudote/models/users.dart';
import 'package:miaudote/screens/login_screen.dart';
import 'package:miaudote/screens/perfil_screen.dart';
import 'package:provider/provider.dart';
import 'package:email_validator/email_validator.dart';
import '../repositories/user_repository.dart';
import '../services/auth_service.dart';
import '../widgets/auth_check.dart';

class EnderecoPage extends StatefulWidget {
  EnderecoPage();

  @override
  State<EnderecoPage> createState() => _EnderecoPageState();
}

class _EnderecoPageState extends State<EnderecoPage> {
  final _formKey = GlobalKey<FormState>();
  final _cidade = TextEditingController();
  final _estado = TextEditingController();
  final _rua = TextEditingController();
  final _numero = TextEditingController();

  bool loading = false; //feedback enquanto carrega

  atualizar() async {
    try {
      setState(() => loading = true);
      //Users usuario = context.read<UserRepository>().user;

      // widget.usuario.user?.estado = _estado.text;
      // widget.usuario.user?.cidade = _cidade.text;
      // widget.usuario.user?.rua = _rua.text;
      // widget.usuario.user?.numero = _numero.text;
      // context
      //     .read<UserRepository>()
      //     .updateUser(_estado.text, _cidade.text, _rua.text, _numero.text);
      await context
          .read<UserRepository>()
          .updateUser(_estado.text, _cidade.text, _rua.text, _numero.text);
      setState(() => loading = false);
      Navigator.pop(context);
    } on Exception catch (e) {
      setState(() => loading = false);
      ScaffoldMessenger.of(context).showSnackBar(feedbackSnackbar(text: e));
    }
  }

  validarForm() {
    if (_formKey.currentState!.validate()) {
      atualizar();
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
                      "Endereço",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
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
                      TextFormField(
                        controller: _estado,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 20.0),
                          labelText: "Estado",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Informe o Estado';
                          }
                          return null;
                        }, //imput
                      ),
                      const SizedBox(
                        height: 20,
                      ),

                      TextFormField(
                          controller: _cidade,
                          keyboardType: TextInputType.name,
                          decoration: InputDecoration(
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            labelText: "Cidade",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Informe a Cidade';
                            }

                            return null;
                          }),

                      const SizedBox(
                        height: 20,
                      ),

                      TextFormField(
                        controller: _rua,
                        keyboardType: TextInputType.name,
                        decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 20.0),
                          labelText: "Rua",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Informe a rua';
                          }

                          return null;
                        },
                      ), //Imput Celular
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: _numero,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 20.0),
                          labelText: "Numero",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Informe o numero da residência';
                          }
                          return null;
                        }, //imput
                      ),
                      const SizedBox(height: 40),
                      SizedBox(
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () => validarForm(),
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.red),
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
                                        "Atualizar",
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
