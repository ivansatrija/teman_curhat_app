import 'package:flutter/material.dart';
import 'dart:async'; // For simulating delay
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _controller = TextEditingController();
  String _displayedMessage = '';
  bool _isLoading = false;

  void _findMessage() async {
    setState(() {
      _isLoading = true;
    });

    var response = await http.post(
      Uri.parse('https://aibible.savinsolution.io/find_verse/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      // Encode the request body as JSON
      body: jsonEncode({
        'example_text': _controller.text,
      }),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      setState(() {
        _displayedMessage = data['Messages'];
        _isLoading = false;
      });
    } else {
      // Handle the error
      setState(() {
        _displayedMessage = 'Error: ${response.statusCode}';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Teman Curhat Rohani'),
      ),
      body: SingleChildScrollView(
        // Wrap the whole body with SingleChildScrollView
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: 'Enter your Keluh Kesah here',
                  border: OutlineInputBorder(), // Added an outline border
                  contentPadding: EdgeInsets.all(10.0),
                ),
                maxLines: null, // Allows multiple lines
              ),
              SizedBox(height: 16), // Add some spacing
              ElevatedButton(
                onPressed: _isLoading ? null : _findMessage,
                child: _isLoading ? CircularProgressIndicator() : Text('Find'),
              ),
              SizedBox(height: 16), // Add some spacing
              if (!_isLoading) Text(_displayedMessage),
            ],
          ),
        ),
      ),
    );
  }
}
