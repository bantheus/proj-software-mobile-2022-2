import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:miaudote/firebase_options.dart';
import 'package:miaudote/repositories/pet_repository.dart';
import 'package:miaudote/repositories/user_repository.dart';
import 'package:miaudote/services/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:miaudote/my_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform); //start firebase
  //await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  //FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);

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
