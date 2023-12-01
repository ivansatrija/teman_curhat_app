import 'package:flutter/material.dart';
import 'dart:async'; // For simulating delay
import 'package:http/http.dart' as http; // Uncomment when you have the backend setup
import 'dart:convert'; // Uncomment when you have the backend setup

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spiritual Companion',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.black,
        colorScheme: ColorScheme.dark(
          primary: Colors.black,
          secondary: Colors.yellowAccent, // Used to be 'accentColor'
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            primary: Colors.yellowAccent, // Button color
            onPrimary: Colors.black, // Text color
          ),
        ),
        textTheme: TextTheme(
          bodyText2: TextStyle(color: Colors.white),
          headline6:
              TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
            borderSide: BorderSide(color: Colors.yellowAccent),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
            borderSide: BorderSide(color: Colors.yellowAccent),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.0),
            borderSide: BorderSide(color: Colors.yellowAccent),
          ),
          hintStyle: TextStyle(color: Colors.white70),
        ),
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

    // Dummy delay to simulate network request
    await Future.delayed(Duration(seconds: 2));

    // Simulate a successful response with a random verse
    setState(() {
      _displayedMessage =
          'Random Verse: "For everything there is a season, and a time for every matter under heaven."';
      _isLoading = false;
    });

    // Uncomment the following lines when you have a backend service to call
    /*
    // var response = await http.post(
    //   Uri.parse('http://localhost:8000/find_verse/'),
    //   headers: <String, String>{
    //     'Content-Type': 'application/json; charset=UTF-8',
    //   },
    //   body: jsonEncode({
    //     'example_text': _controller.text,
    //   }),
    // );

    // if (response.statusCode == 200) {
    //   var data = jsonDecode(response.body);
    //   setState(() {
    //     _displayedMessage = data['Messages'];
    //     _isLoading = false;
    //   });
    // } else {
    //   setState(() {
    //     _displayedMessage = 'Error: ${response.statusCode}';
    //     _isLoading = false;
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('We\'re here for you!'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Type here...',
                filled: true,
                fillColor: Colors.black38,
              ),
              style: TextStyle(color: Colors.white),
              maxLines: null,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isLoading ? null : _findMessage,
              child:
                  _isLoading ? CircularProgressIndicator() : Text('Find Verse'),
            ),
            SizedBox(height: 16),
            if (_displayedMessage.isNotEmpty)
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.yellowAccent,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  _displayedMessage,
                  style: TextStyle(color: Colors.black),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
