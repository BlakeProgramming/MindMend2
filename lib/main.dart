import 'package:flutter/material.dart';
import 'package:myapp/activity_center.dart';
import 'package:myapp/dashboard_p5.dart';
import 'package:myapp/sign_in_screen.dart';
import 'package:myapp/sudoku.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'Gemini.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MindMend App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: ActivityCenter(),
    );
  }
}
