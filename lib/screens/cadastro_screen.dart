import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:miaudote/screens/home_screen.dart';
import 'package:miaudote/models/users.dart';
import 'package:miaudote/screens/login_screen.dart';
import 'package:provider/provider.dart';
import 'package:email_validator/email_validator.dart';
import '../repositories/user_repository.dart';
import '../services/auth_service.dart';
import '../widgets/auth_check.dart';

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

  bool loading = false; //feedback enquanto carrega

  cadastrar() async {
    try {
      setState(() => loading = true);
      await context.read<AuthService>().cadastrar(_email.text, _senha.text);
      await context.read<UserRepository>().createUser(
            Users(
              nome: _nome.text,
              email: _email.text,
              celular: _celular.text,
            ),
          );

      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const AuthCheck()),
      );
    } on AuthException catch (e) {
      setState(() => loading = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(feedbackSnackbar(text: e.message));
    }
  }

  validarForm() {
    if (_formKey.currentState!.validate()) {
      cadastrar();
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
                      "Cadastre-se",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Encontre um novo amigo",
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey[700],
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
                            return 'Informe o seu Nome';
                          }
                          return null;
                        }, //imput
                      ),
                      const SizedBox(
                        height: 20,
                      ),

                      TextFormField(
                          controller: _email,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            labelText: "E-mail",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Informe o email';
                            }
                            if (!EmailValidator.validate(value)) {
                              return "Email inv??lido";
                            }
                            return null;
                          }),

                      const SizedBox(
                        height: 20,
                      ),

                      TextFormField(
                        controller: _celular,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 20.0),
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
                            return "Celular inv??lido";
                          }
                          return null;
                        },
                      ), //Imput Celular
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: _senha,
                        obscureText: true,
                        decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 20.0),
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
                            return 'A senha deve ter no m??nimo 6 caracteres';
                          } else {
                            return null;
                          }
                        }, //imput
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
