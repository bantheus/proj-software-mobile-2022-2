import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:miaudote/models/user.dart';
import 'package:miaudote/screens/login_screen.dart';
import 'package:provider/provider.dart';
import 'package:email_validator/email_validator.dart';
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
          .showSnackBar(feedbackSnackbar(text: "Cadastro com sucesso"));

      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          feedbackSnackbar(text: "Este email já está cadastrado"));
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
                              return "Email inválido";
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
                            return "Celular inválido";
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
                            return 'A senha deve ter no mínimo 6 caracteres';
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
                                MaterialStateProperty.all<Color>(Colors.red),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          child: const SizedBox(
                            width: double.infinity,
                            child: Text(
                              'Cadastrar',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20,
                              ),
                            ),
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
