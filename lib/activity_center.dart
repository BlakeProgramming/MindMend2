import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/sudoku.dart';
import 'gemini.dart';
import 'gradient_theme.dart';
import 'Art_Studio.dart';

class ActivityCenter extends StatefulWidget {
  const ActivityCenter({super.key});

  @override
  _ActivityCenterState createState() => _ActivityCenterState();
}

class _ActivityCenterState extends State<ActivityCenter> {
  String? email;

  @override
  void initState() {
    super.initState();
    // Initialize email with the current user's email
    email = FirebaseAuth.instance.currentUser?.email;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final scrollController = ScrollController();
    final gradient =
        Theme.of(context).extension<GradientTheme>()!.containerGradient;
    return Scaffold(
      body: Container(
        width: screenWidth,
        decoration: BoxDecoration(gradient: gradient),
        child: SafeArea(
          child: Scrollbar(
            controller: scrollController,
            thumbVisibility: true,
            child: SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.all(20),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: screenHeight - 40,
                ), // adjust for SafeArea
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      Column(
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
                          const Divider(
                            color: Colors.white70,
                            thickness: 1,
                            height: 20,
                          ),
                          const Text(
                            'Activities',
                            style: TextStyle(fontSize: 22, color: Colors.white),
                          ),
                          const SizedBox(height: 10),
                          const SizedBox(height: 10),
                          _buildButtonWrap(context, [
                            _ActivityButton(label: 'Art', onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ArtCanvas(),
                                  ),
                                );
                            }
                            ),
                            _ActivityButton(
                              label: 'Puzzle',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SudokuScreen(),
                                  ),
                                );
                              },
                            ),
                            _ActivityButton(label: 'Music', onTap: () {}),
                          ]),
                          const SizedBox(height: 30),
                          const Text(
                            'Top Sections',
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                          const SizedBox(height: 10),
                          _buildButtonWrap(context, [
                            _ActivityButton(
                              label: 'Journal',
                              onTap: () {
                                // Navigator.push(context, MaterialPageRoute(builder: (context) => JournalScreen()));
                              },
                            ),
                            _ActivityButton(
                              label: 'AI Therapist',
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const GeminiChat(),
                                  ),
                                );
                              },
                            ),
                          ]),
                        ],
                      ),
                      const Spacer(), // Pushes the arrow icon to the bottom
                      const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: Colors.white60,
                        size: 40,
                      ),
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
      spacing: 20,
      runSpacing: 20,
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
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white.withValues(),
        foregroundColor: const Color(0xFF7B60D1),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}
