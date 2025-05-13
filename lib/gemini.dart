import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'secrets.dart'; // ✅ Secure API key storage
import 'package:myapp/back_button_to_activity_center.dart';

//Broken, fix later

class GeminiChat extends StatefulWidget {
  const GeminiChat({super.key});

  @override
  State<GeminiChat> createState() => _GeminiChatState();
}

class _GeminiChatState extends State<GeminiChat> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, String>> messages = []; // ✅ Chat history storage

  Future<void> _sendMessage(String userMessage) async {
    if (userMessage.isEmpty) return;

    setState(() {
      messages.add({"role": "user", "text": userMessage});
    });

    var headers = {'Content-Type': 'application/json'};

    var request = http.Request(
      'POST',
      Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$geminiApiKey',
      ),
    );

    // Sending the user message as part of the request body
    request.body = json.encode({
      "contents": [
        {
          "parts": [
            {
              "text": "$userMessage  (ensure your response reflects that of a therapist. Do not let messages exceed 2500 characters. Do not repeat prompt before responding. If specifically asked, offer ways to help.)", // User message input
            },
          ],
        },
      ],
    });

    request.headers.addAll(headers);

    try {
      // Sending the request
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();
        final data = jsonDecode(responseBody);

        // Check if the response contains valid data
        String aiResponse = "";
        if (data.containsKey("candidates") &&
            data["candidates"].isNotEmpty &&
            data["candidates"][0].containsKey("content") &&
            data["candidates"][0]["content"].containsKey("parts") &&
            data["candidates"][0]["content"]["parts"].isNotEmpty) {
          aiResponse = data["candidates"][0]["content"]["parts"][0]["text"];
        } else {
          aiResponse = "No response from AI.";
        }

        setState(() {
          messages.add({"role": "ai", "text": aiResponse});
        });

        _controller.clear();
      } else {
        // Handle error if the response status is not 200
        String errorBody = await response.stream.bytesToString();
        ("Error response: $errorBody");

        setState(() {
          messages.add({
            "role": "ai",
            "text": "Error: ${response.reasonPhrase}",
          }); // Shows real error
        });
      }
    } catch (e) {
      setState(() {
        messages.add({
          "role": "ai",
          "text": "An error occurred: $e",
        }); // Catches network issues
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF7B60D1), // Deep purple
                  Color(0xFF4A148C), // Slightly lighter purple
                ],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  // 🌿 Header (Centered text)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Column(
                      children: const [
                        Text(
                          "MindMend",
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1,
                          ),
                        ),
                        Text(
                          "AI Therapist",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white70,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // 💬 Chat Messages
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final msg = messages[index];
                        final isUser = msg["role"] == "user";
                        return Align(
                          alignment:
                              isUser
                                  ? Alignment.centerRight
                                  : Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            padding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 14,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  isUser
                                      ? Colors.purple[200]
                                      : Colors.white.withValues(),
                              borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(16),
                                topRight: const Radius.circular(16),
                                bottomLeft: Radius.circular(isUser ? 16 : 0),
                                bottomRight: Radius.circular(isUser ? 0 : 16),
                              ),
                            ),
                            child: Text(
                              msg["text"]?.trim() ??
                                  "", // 🔧 Trim to remove extra spacing
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  // 📝 Input Area
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _controller,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              hintText: "Express Yourself...",
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 16,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(24),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.send,
                              color: Colors.deepPurple,
                            ),
                            onPressed: () => _sendMessage(_controller.text),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Back Button (Positioned in top-left corner)
          Positioned(
            top: 20,
            left: 16,
            child: const BackToActivityCenterButton(), // ✅ Add back button here
          ),
        ],
      ),
    );
  }
}
