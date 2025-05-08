import 'package:flutter/material.dart';
import 'activity_center.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'package:myapp/assets/MindMendBackgroundDesign.png';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  SignInScreenState createState() => SignInScreenState();
}

class SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Firebase Sign In
  void _signIn() async {
    try {
      final UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );

      if (userCredential.user != null) {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => ActivityCenter()),
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      String message = 'An error occurred. Please try again.';
      if (e.code == 'user-not-found') {
        message = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        message = 'Incorrect password.';
      }
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(message)));
      }
    }
  }

  void _showSignUpDialog() {
    final TextEditingController signUpEmailController = TextEditingController();
    final TextEditingController signUpPassController = TextEditingController();

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Create Account'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: signUpEmailController,
                  decoration: const InputDecoration(labelText: 'New Email'),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: signUpPassController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'New Password'),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  try {
                    await FirebaseAuth.instance.createUserWithEmailAndPassword(
                      email: signUpEmailController.text.trim(),
                      password: signUpPassController.text.trim(),
                    );
                    if (mounted) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Account created! Please log in.'),
                        ),
                      );
                    }
                  } on FirebaseAuthException catch (e) {
                    String errorMsg = 'Something went wrong.';
                    if (e.code == 'weak-password') {
                      errorMsg = 'The password provided is too weak.';
                    } else if (e.code == 'email-already-in-use') {
                      errorMsg = 'That email is already in use.';
                    }
                    if (mounted) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(errorMsg)));
                    }
                  }
                },
                child: const Text('Sign Up'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          // Image.network('https://i.imgur.com/JPOublB.png', fit: BoxFit.cover),
          Positioned.fill(
            child: Image.asset(
              'MindMendBackgroundDesign.png',
              fit: BoxFit.cover,
            ),
          ),

          // Overlay + content
          Container(
            color: const Color.fromARGB(61, 0, 0, 0), // Dark overlay
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.network(
                      'https://i.imgur.com/gwjmwdY.png', // Provided image link
                      height: 75, // Adjust the size as needed
                    ),
                    const SizedBox(height: 20),
                    _buildTextField('Email', _emailController),
                    const SizedBox(height: 10),
                    _buildTextField(
                      'Password',
                      _passwordController,
                      obscureText: true,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _signIn,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 50,
                          vertical: 15,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        'LOGIN',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    TextButton(
                      onPressed: _showSignUpDialog,
                      child: const Text(
                        'No account yet? Sign up!',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    bool obscureText = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.black54),
          filled: true,
          fillColor: Colors.white.withValues(),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
        ),
      ),
    );
  }
}
