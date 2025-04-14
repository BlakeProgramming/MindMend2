import 'package:flutter/material.dart';
import 'package:myapp/sign_in_screen.dart';
import 'activity_center.dart';

void main() {
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
      home:
          const SignInScreen(), // ✅ This must match the class name in Gemini.dart
    );
  }
}

