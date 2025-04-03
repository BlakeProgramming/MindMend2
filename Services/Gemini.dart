import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class GeminiAPI extends StatefulWidget {
  const GeminiAPI({super.key});

  @override
  State<GeminiAPI> createState() => _GeminiAPIPageState();
}

class _GeminiAPIPageState extends State<GeminiAPI> {
  String? textR;

  //auth data

  Future<void> _fetchRequest() async {
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request(
      'POST',
      Uri.parse(
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=AIzaSyBr83iyO0dAsodfd2F5HZrAajIRmzPqncI',
      ),
    );
    request.body = json.encode({
      "contents": [
        {
          "parts": [
            {
              "text":
                  "Give me a list of new, positive news stories. Include links to sources.",
            },
          ],
        },
      ],
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
      final data = jsonDecode(response.stream.bytesToString());
    setState(() {
      textR = data['contents'][0]['text'];
    });
    } else {
      print(response.reasonPhrase);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center( // Wrap in Center for better UI
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Align content properly
          children: [
            Text(
              textR, // Correct variable usage
              style: TextStyle(fontSize: 20), // Optional styling
            ),
          ],
        ),
      ),
    );
  }
}
