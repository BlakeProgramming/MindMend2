import 'package:flutter/material.dart';
import 'Gemini.dart'; // AI Therapist
// import 'journal.dart'; // Uncomment when journal screen exists
import 'sign_in_screen.dart';

class ActivityCenter extends StatelessWidget {
  const ActivityCenter({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF7B60D1), Color(0xFF8A6DD3)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Scrollbar(
            thumbVisibility: true,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: screenWidth),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'MindMend',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const Divider(color: Colors.white70, thickness: 1, height: 20),
                      const SizedBox(height: 10),
                      const Text(
                        'Activities',
                        style: TextStyle(fontSize: 22, color: Colors.white),
                      ),
                      const SizedBox(height: 10),
                      _buildButtonWrap(context, [
                        _ActivityButton(label: 'Art', onTap: () {}),
                        _ActivityButton(label: 'Puzzle', onTap: () {}),
                        _ActivityButton(label: 'Music', onTap: () {}),
                      ]),
                      const SizedBox(height: 30),
                      const Text(
                        'Personal Top Sections',
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                      const SizedBox(height: 10),
                      _buildButtonWrap(context, [
                        _ActivityButton(label: 'Journal', onTap: () {
                          // Navigator.push(context, MaterialPageRoute(builder: (context) => JournalScreen()));
                        }),
                        _ActivityButton(label: 'Gaming', onTap: () {}),
                        _ActivityButton(label: 'AI Therapist', onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const GeminiChat()));
                        }),
                      ]),
                      const SizedBox(height: 40),
                      const Icon(Icons.keyboard_arrow_down_rounded,
                          color: Colors.white60, size: 40),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButtonWrap(BuildContext context, List<Widget> buttons) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      alignment: WrapAlignment.center,
      children: buttons,
    );
  }
}

class _ActivityButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _ActivityButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final buttonWidth = screenWidth * 0.25;

    return SizedBox(
      width: buttonWidth < 140 ? 140 : buttonWidth, // Ensure minimum size
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.deepPurple,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: Text(label, style: const TextStyle(fontSize: 16)),
      ),
    );
  }
}