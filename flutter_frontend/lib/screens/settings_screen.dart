import 'dart:convert';
//import 'package:http/http.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app_tutorial/views/gradient_container.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  // Using a List of Maps to store sender and message for better display
  final List<Map<String, String>> _messages = [];
  bool _isLoading = false;

  
  final String _backendUrl = 'http://localhost:8000/chat';

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    if (_textController.text.isEmpty) {
      return; // Don't send empty messages
    }

    String userMessage = _textController.text;

    // Add user's message to the list and clear input field
    setState(() {
      _messages.add({"sender": "You", "message": userMessage});
      _isLoading = true; // Show loading indicator
    });
    _textController.clear();

    try {
      // Make the HTTP POST request to your Python backend
      final response = await http.post(
        Uri.parse(_backendUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'message': userMessage, // Send the user's message as a JSON object
        }),
      );

      if (response.statusCode == 200) {
        // If the server returns a 200 OK response, parse the JSON
        final Map<String, dynamic> data = jsonDecode(response.body);
        setState(() {
          _messages.add({"sender": "Gemini", "message": data['response']});
        });
      } else {
        // If the server did not return a 200 OK response,
        // print the error and add an error message to the chat.
        print('Backend Error - Status Code: ${response.statusCode}');
        print('Backend Error - Body: ${response.body}');
        setState(() {
          _messages.add({"sender": "Error", "message": "Failed to get response from backend. Status: ${response.statusCode}"});
        });
      }
    } catch (e) {
      // Catch any network-related errors
      print('Network Error: $e');
      setState(() {
        _messages.add({"sender": "Error", "message": "Could not connect to backend: $e"});
      });
    } finally {
      setState(() {
        _isLoading = false; // Hide loading indicator
      });
    }
  }

  
  @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: const Color(0xFF121D2B), // dark bluish background
    appBar: AppBar(
      title: const Text("Weather Chatbot"),
      backgroundColor: const Color(0xFF0D1521), // darker appbar
      foregroundColor: Colors.white,
    ),
    body: Column(
      children: [
        // Chat messages
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: _messages.length,
            itemBuilder: (context, index) {
              final message = _messages[index];
              final isUser = message["sender"] == "You";
              return Align(
                alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                child: Card(
                  color: isUser ? Colors.blueAccent : Colors.lightBlue,
                  elevation: 2.0,
                  margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                      children: [
                        Text(
                          message["sender"]!,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[200],
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          message["message"]!,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        // Loading bar
        if (_isLoading) const LinearProgressIndicator(),

        // Input area
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _textController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Ask about the weather",
                    hintStyle: const TextStyle(color: Colors.white54),
                    filled: true,
                    fillColor: Colors.blueGrey[900],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25.0),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                  ),
                  onSubmitted: (value) => _sendMessage(),
                ),
              ),
              const SizedBox(width: 8.0),
              FloatingActionButton(
                onPressed: _sendMessage,
                child: const Icon(Icons.send),
                backgroundColor: Colors.blueAccent,
                elevation: 2.0,
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

}