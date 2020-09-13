import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

void main() {
  runApp(new MyApp5());
}

class MyApp5 extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: Text('Client App (Flutter)')),
        body: BodyWidget(),
      ),
    );
  }
}

class BodyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.only(top: 32.0),
        child: SizedBox(
          width: 200,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              RaisedButton(
                child: Text('Make GET (all) request'),
                onPressed: () async {
//                  _makeGetAllRequest();
                  await fetchProducts();
                },
              ),
              RaisedButton(
                child: Text('Make GET (one) request'),
                onPressed: () {
                  _makeGetOneRequest();
                },
              ),
              RaisedButton(
                child: Text('Make POST request'),
                onPressed: () {
                  _makePostRequest();
                },
              ),
              RaisedButton(
                child: Text('Make PUT request'),
                onPressed: () {
                  _makePutRequest();
                },
              ),
              RaisedButton(
                child: Text('Make PATCH request'),
                onPressed: () {
                  _makePatchRequest();
                },
              ),
              RaisedButton(
                child: Text('Make DELETE request'),
                onPressed: () {
                  _makeDeleteRequest();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  static const Map<String, String> headers = {
    "Content-type": "application/json"
  };

  // access localhost from the emulator/simulator
  String _hostname() {
    if (Platform.isAndroid)
      return 'http://10.0.2.2:8888';
    else
      return 'http://localhost:8888';
  }

  Future<List<Fruit>> fetchProducts() async {
    final response = await http.get('http://10.0.2.2:8888/');
    if (response.statusCode == 200) {
      print('Status: $response');

      return parseProducts(response.body);
    } else {
      throw Exception('Unable to fetch products from the REST API');
    }
  }

  List<Fruit> parseProducts(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    return parsed.map<Fruit>((json) => Fruit.fromJson(json)).toList();
  }

  // GET all
  _makeGetAllRequest() async {
    // get everything
    Response response = await get(_hostname());
    // examples of info available in response
    int statusCode = response.statusCode;
    String jsonString = response.body;
    Map m = jsonDecode(jsonString);
    final f = Fruit.fromJson(m);
    print('Status: $statusCode, $jsonString');
    print('Status: $f');
  }

  // GET one
  _makeGetOneRequest() async {
    // only get a single item at index 0
    int idToGet = 0;
    String url = '${_hostname()}/$idToGet';
    Response response = await get(url);
    int statusCode = response.statusCode;
    String jsonString = response.body;
    print('Status: $statusCode, $jsonString');
  }

  // POST
  _makePostRequest() async {
    // set up POST request arguments
    String json = '{"fruit": "pear", "color": "green"}';
    // make POST request
    Response response = await post(_hostname(), headers: headers, body: json);
    int statusCode = response.statusCode;
    String body = response.body;
    print('Status: $statusCode, $body');
  }

  // PUT
  _makePutRequest() async {
    // set up PUT request arguments
    int idToReplace = 0;
    String url = '${_hostname()}/$idToReplace';
    String json = '{"fruit": "watermellon", "color": "red and green"}';
    // make PUT request
    Response response = await put(url, headers: headers, body: json);
    int statusCode = response.statusCode;
    String body = response.body;
    print('Status: $statusCode, $body');
  }

  // PATCH
  _makePatchRequest() async {
    // set up PATCH request arguments
    int idToUpdate = 0;
    String url = '${_hostname()}/$idToUpdate';
    String json = '{"color": "green"}';
    // make PATCH request
    Response response = await patch(url, headers: headers, body: json);
    int statusCode = response.statusCode;
    String body = response.body;
    print('Status: $statusCode, $body');
  }

  // DELETE
  void _makeDeleteRequest() async {
    // set up DELETE request argument
    int idToDelete = 0;
    String url = '${_hostname()}/$idToDelete';
    // make DELETE request
    Response response = await delete(url);
    int statusCode = response.statusCode;
    String body = response.body;
    print('Status: $statusCode, $body');
  }
}

// For help converting JSON to objects in Flutter see
// this post https://stackoverflow.com/a/54657953
class Fruit {
  int id;
  String fruit;
  String color;

  Fruit(this.fruit, this.color);

  // named constructor
  Fruit.fromJson(Map<String, dynamic> json)
      : fruit = json['fruit'],
        color = json['color'];

  // method
  Map<String, dynamic> toJson() {
    return {
      'fruit': fruit,
      'color': color,
    };
  }
}
