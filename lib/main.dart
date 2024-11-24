import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test Search',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: SearchScreen(),
    );
  }
}

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  String _result = '';

  Future<void> fetchTestById(String id) async {
    final url = Uri.parse('http://192.168.56.1:8000/testdb/api/test/$id/');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _result = 'Text: ${data['text']}, Number: ${data['number']}';
        });
      } else if (response.statusCode == 404) {
        setState(() {
          _result = 'No instance found with ID $id.';
        });
      } else {
        setState(() {
          _result = 'Error: ${response.reasonPhrase}';
        });
      }
    } catch (e) {
      setState(() {
        _result = 'Error fetching data: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Search Test by ID')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Enter Test ID',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                final id = _controller.text;
                if (id.isNotEmpty) {
                  fetchTestById(id);
                }
              },
              child: Text('Search'),
            ),
            SizedBox(height: 16.0),
            Text(_result, style: TextStyle(fontSize: 16.0)),
          ],
        ),
      ),
    );
  }
}
