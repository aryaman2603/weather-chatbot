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

  // IMPORTANT: Backend URL Configuration
  // For iPhone simulator (and Android emulator), 'http://localhost:8000' works
  // because the simulator/emulator's localhost maps to your development machine's localhost.
  // If running on a physical device, you would need your development machine's actual
  // local IP address (e.g., 'http://192.168.1.5:8000/chat').
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
      appBar: AppBar(
        title: const Text("Weather Chatbot"),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          // Chat message list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return Align(
                  alignment: message["sender"] == "You" ? Alignment.centerRight : Alignment.centerLeft,
                  child: Card(
                    // Different colors for user and bot messages
                    color: message["sender"] == "You" ? Colors.blue[100] : Colors.grey[200],
                    elevation: 1.0,
                    margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: message["sender"] == "You" ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                        children: [
                          Text(
                            message["sender"]!,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: message["sender"] == "You" ? Colors.blue[800] : Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            message["message"]!,
                            style: TextStyle(
                              color: message["sender"] == "You" ? Colors.blue[900] : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // Loading indicator
          if (_isLoading) const LinearProgressIndicator(),
          // Input field and send button
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      hintText: "Ask about the weather or anything...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    ),
                    onSubmitted: (value) => _sendMessage(), // Allows sending on Enter key press
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