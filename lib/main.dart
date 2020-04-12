import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(MaterialApp(
    theme: ThemeData(
        primaryColor: Colors.blue,
        accentColor: Colors.blueAccent,
        buttonColor: Colors.blue),
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController todoTaskController = TextEditingController();
  List _todoList = [
    {'title': 'xxx', 'ok': true},
    {'title': 'sadasdsd', 'ok': false},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('TODO List'), centerTitle: true),
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(10, 1, 10, 1),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                      controller: todoTaskController,
                      decoration: InputDecoration(
                        labelText: 'New task',
                      )),
                ),
                RaisedButton(
                  textColor: Colors.white,
                  child: Icon(Icons.add),
                  onPressed: () {},
                )
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
                padding: EdgeInsets.only(top: 10, left: 1, right: 1),
                itemCount: _todoList.length,
                itemBuilder: (context, index) {
                  return CheckboxListTile(
                      secondary: CircleAvatar(
                        child: _todoList[index]['ok']
                            ? Icon(Icons.check)
                            : Icon(Icons.clear),
                      ),
                      title: Text(_todoList[index]['title']),
                      value: _todoList[index]['ok']);
                }),
          ),
          Row(
            children: <Widget>[
              IconButton(
                iconSize: 50,
                icon: Icon(Icons.check_circle),
                onPressed: () {},
              ),
              Text('xxxxxx'),
              Checkbox(
                tristate: true,
                onChanged: (value) {},
              ),
            ],
          )
        ],
      ),
    );
  }

  Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/data.json');
  }

  Future<File> _saveFile() async {
    String data = json.encode(_todoList);
    final file = await _getFile();
    return file.writeAsString(data);
  }

  Future<String> _readData() async {
    try {
      final file = await _getFile();
      return file.readAsString();
    } catch (e) {
      return null;
    }
  }
}
