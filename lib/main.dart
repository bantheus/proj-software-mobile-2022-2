import 'package:flutter/material.dart';
import 'package:miaudote/repositories/pet_repository.dart';
import 'package:miaudote/repositories/user_repository.dart';
import 'package:provider/provider.dart';

import 'package:miaudote/my_app.dart';

void main() {
  runApp(const MyApp());
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => UserRepository(),
        ),
        ChangeNotifierProvider(
          create: (context) => PetRepository(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}
