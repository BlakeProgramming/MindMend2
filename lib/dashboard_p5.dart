import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DashboardP5 extends StatelessWidget {
  DashboardP5({super.key});

  @override
  Widget build(BuildContext context) {
    final String? email = FirebaseAuth.instance.currentUser?.email;

    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Welcome to the dashboard!"),
            SizedBox(height: 20),
            Text("Email: $email"),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                if (context.mounted) {
                  Navigator.pushReplacementNamed(context, '/sign-in');
                }
              },
              child: Text("Sign Out"),
            ),
          ],
        ),
      ),
    );
  }
}
