import 'package:flutter/material.dart';
import 'package:miaudote/models/users.dart';
import 'package:miaudote/repositories/user_repository.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../screens/home_screen.dart';
import '../screens/login_screen.dart';
import '../screens/cadastro_screen.dart';
import '../services/auth_service.dart';

class AuthCheck extends StatefulWidget {
  const AuthCheck({Key? key}) : super(key: key);

  @override
  _AuthCheckState createState() => _AuthCheckState();
}

class _AuthCheckState extends State<AuthCheck> {
  @override
  Widget build(BuildContext context) {
    //olha para estado no authservice (usuário)

    AuthService auth = Provider.of<AuthService>(context);


    if (auth.isLoading) {
      return loading();
    } //controle enquanto aguarda retorno base
    else if (auth.usuario == null) {
      return const LoginPage();
    } else {
      UserRepository repoUser = UserRepository(auth: auth);

      return HomePage(usuario: repoUser);
    }
  }

  loading() {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
