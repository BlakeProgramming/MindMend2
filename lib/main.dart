import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:myapp/sign_in_screen.dart';
// import 'package:myapp/sudoku.dart';
import 'firebase_options.dart';
import 'gradient_theme.dart';

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
      theme: ThemeData(
        primarySwatch: Colors.blue,
        extensions: <ThemeExtension<dynamic>>[
          GradientTheme(
            containerGradient: const LinearGradient(
              colors: [Color(0xFF7B60D1), Color(0xFF4A148C)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
        ),
      ],
      ),
      home: SignInScreen(),
    );
  }
}

/*theme: ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.deepPurple,
      primary: Colors.deepPurple,
      secondary: Colors.amber,
      surface: Colors.white,
      background: Colors.grey[200]!,
    ), */
