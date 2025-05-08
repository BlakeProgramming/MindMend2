import 'package:flutter/material.dart';
import 'package:myapp/activity_center.dart'; // Update this path to match your file structure

class BackToActivityCenterButton extends StatelessWidget {
  const BackToActivityCenterButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
      onPressed: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ActivityCenter()),
        );
      },
    );
  }
}