import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:miaudote/models/users.dart';
//import 'package:miaudote/models/user.dart';
import 'package:miaudote/repositories/user_repository.dart';
import 'package:miaudote/screens/cadastro_screen.dart';
import 'package:miaudote/screens/endereco_screen.dart';
import 'package:miaudote/screens/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:collection/src/iterable_extensions.dart';
import 'package:email_validator/email_validator.dart';

import '../repositories/user_repository.dart';
import '../services/auth_service.dart';

class PerfilPage extends StatefulWidget {
  

  PerfilPage();

  @override
  State<PerfilPage> createState() => _PerfilPageState();
}

class _PerfilPageState extends State<PerfilPage> {
  final ValueNotifier<bool> loading = ValueNotifier(false);
  late Users user;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getUser();
  }

  getUser() async {
    try {
      loading.value = true;
      user = await context.read<UserRepository>().findUser();
      if (user != null && mounted) {
        loading.value = false;
      }
    } on Exception catch (e) {
      loading.value = false;
      ScaffoldMessenger.of(context).showSnackBar(feedbackSnackbar(text: e));
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

  XFile? imageFile;

  _abrirGaleria() async {
    final picker = ImagePicker();

    try {
      XFile? file = await picker.pickImage(source: ImageSource.gallery);
      if (file != null) setState(() => imageFile = file);
      
    } catch (e) {
      print(e);
    }
  }

  _abrirCamera() async {
    
    final picker = ImagePicker();

    try {
      XFile? file = await picker.pickImage(source: ImageSource.camera);
      if (file != null) setState(() => imageFile = file);
    } catch (e) {
      print(e);
    }
  }

  _escolha(BuildContext context) {
    final usuario = Provider.of<UserRepository>(context, listen: false);
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Escolha"),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  GestureDetector(
                    child: Text("Galeria"),
                    onTap: () {
                      _abrirGaleria();
                    },
                  ),
                  Padding(padding: EdgeInsets.all(8)),
                  GestureDetector(
                    child: Text("Câmera"),
                    onTap: () {
                      _abrirCamera();
                    },
                  ),
                ],
              ),
            ),
          );
        });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
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

          child: ValueListenableBuilder(
              valueListenable: loading,
              builder: (context, bool isLoading, _) {
                if (isLoading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 120.0),
                      child: SizedBox(
                        width: 250,
                        height: 150,
                                       child: Stack(
                      clipBehavior: Clip.none,
                      fit: StackFit.expand,
                      children: [
                        CircleAvatar(
                          child: ClipOval(
                              child: imageFile != null
                                  ? Image.file(File(imageFile!.path))
                                  : null),
                          radius: 10,
                        ),
                        Positioned(
                          right: 30,
                          bottom: 0,
                          child: SizedBox(
                            height: 46,
                            width: 46,
                             child: TextButton (
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                  side: BorderSide(color: Colors.white),
                                ),
                              ),
                              onPressed: () {
                                _escolha(context);
                              },
                              child: Icon(Icons.camera_alt_outlined),
                             
                          ),
                        )
                        )
                      ],
                    )),


              ),
              
              Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 30,
                  ),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                (user.nome),
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.email),
                                    const SizedBox(width: 10),
                                    Text(
                                      (user.email),
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                  ]),
                              const SizedBox(
                                height: 30,
                              ),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.phone),
                                    const SizedBox(width: 10),
                                    Text(
                                      (user.celular),
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                  ]),
                            ])),
                    const SizedBox(
                      height: 40,
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 30,
                        ),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Endereço",
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 5),
                              IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => EnderecoPage(),
                                        ));
                                  }),
                            ])),
                  ],
                );
              }),
        ),
      ),
    );
  }
}
