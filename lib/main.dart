import 'package:flutter/material.dart';
import 'login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_database/firebase_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseApp app = await Firebase.initializeApp();
  FirebaseDatabase database = FirebaseDatabase.instance;

  if (app.name == "[DEFAULT]") {
    print("Conectado a Firebase");
  } else {
    print("No se pudo conectar a Firebase");
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tasker',
      theme: ThemeData(

        primarySwatch: Colors.red,
      ),
      home: LoginPage(),
    );
  }
}
