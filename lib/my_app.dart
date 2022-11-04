import 'package:flutter/material.dart';
import 'package:miaudote/screens/login_screen.dart';
import 'package:miaudote/services/auth_service.dart';
import 'package:miaudote/widgets/auth_check.dart';
import 'package:provider/provider.dart';


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "MiAuDote",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const AuthCheck(),
    );
      
      
  }
}
