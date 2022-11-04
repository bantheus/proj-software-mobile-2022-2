import 'package:flutter/material.dart';
import 'package:miaudote/firebase_options.dart';
import 'package:miaudote/repositories/pet_repository.dart';
import 'package:miaudote/repositories/user_repository.dart';
import 'package:miaudote/services/auth_service.dart';
import 'package:miaudote/widgets/auth_check.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
//import 'package:firebase_options.dart';

import 'package:miaudote/my_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform); //start firebase

  //runApp(const MyApp());
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthService()),
        ChangeNotifierProvider(
          create: (context) => UserRepository(
            auth: context.read<AuthService>(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => PetRepository(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}
