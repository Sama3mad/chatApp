import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// It allows you to refer to the imported library using the prefix http
class App extends StatefulWidget {
  App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    // TODO: implement initState
    getData();
  }

  void saveData() async {
    //function can perform asynchronous operations and return a Future
    final url = Uri.https(
        'flutter-prep-2a4b5-default-rtdb.firebaseio.com', 'testingApp.json');
    final response = await http.post(url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'name': 'sama',
          'age': '19',
          'nationality': 'egyptian',
        }));
    //The await keyword is used to wait for a Future to complete. It can only be used within an async function.

    print(response.statusCode);
    //This is important for determining if the request was successful or if there was an error.
  }

  void getData() async {
    final url = Uri.https(
        'flutter-prep-2a4b5-default-rtdb.firebaseio.com', 'testingApp.json');
    final response = await http.get(url);
    // if(response.body == 'null'){
    //   return;
    // }
    //checks if there is no data to get

    try {
      print(response.body);
      final Map<String, dynamic> listData = jsonDecode(response.body);
      //When you retrieve data from Firebase, it comes in a JSON-like format, which is typically parsed into a Map<String, dynamic>
      //{"-O3DeLUIIyKe7Colip0J":{"age":"19","name":"sama","nationality":"egyptian"}}
      for (final item in listData.entries) {
        //each entry holds a key and a value. the key here is the id ("-O3DeLUIIyKe7Colip0J") and the value is the map {"age":"19","name":"sama","nationality":"egyptian"}
        print('name: ${item.value['name']}');
        print('age: ${item.value['age']}');
        print('nationality: ${item.value['nationality']}');
        removeItem(item.key);
      }
    } catch (error) {
      print('no data to print');
    }
  }

  void removeItem(String itemId) {
    final url = Uri.https('flutter-prep-2a4b5-default-rtdb.firebaseio.com',
        'testingApp/$itemId.json');
    http.delete(url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
          child: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              saveData();
            },
            child: Text('press to save data'),
          ),
          ElevatedButton(
            onPressed: () {
              getData();
            },
            child: Text('press to get data'),
          ),
        ],
      )),
    );
  }
}
