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
      title: 'Spiritual Companion',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      Duration(seconds: 3),
      () => Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => SpiritualCompanionApp()), // Replace NextScreen with your main screen widget
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/splash_image.jpeg'), // Make sure this is the correct path to your image
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

class SpiritualCompanionApp extends StatefulWidget {
  @override
  _SpiritualCompanionAppState createState() => _SpiritualCompanionAppState();
}

class _SpiritualCompanionAppState extends State<SpiritualCompanionApp> {
  final TextEditingController _controller = TextEditingController();
  String _displayedMessage = '';
  bool _isLoading = false;

  void _findMessage() async {
    setState(() {
      _isLoading = true;
    });

    var response = await http.post(
      Uri.parse('http://aibible.savinsolution.io/find_verse/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
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
      setState(() {
        _displayedMessage = 'Error: ${response.statusCode}';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Spiritual Companion',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.black,
        colorScheme: ColorScheme.dark(
          primary: Colors.black,
          secondary: Colors.yellowAccent,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            primary: Colors.yellowAccent,
            onPrimary: Colors.black,
          ),
        ),
        textTheme: TextTheme(
          bodyText2: TextStyle(color: Colors.white),
          headline6: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
      home: Scaffold(
        appBar: AppBar(
          title: Text('We\'re here for you!'),
          centerTitle: true,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Padding(
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
                  child: _isLoading ? CircularProgressIndicator() : Text('Temukan ayat untuk mengerti anda'),
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
        ),
      ),
    );
  }
}
