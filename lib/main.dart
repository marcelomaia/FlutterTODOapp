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
  List _todoList = [];

  var lastRemovedElement;
  var lastRemovedIndex;

  @override
  void initState() {
    super.initState();
    _readData().then((data) {
      _todoList = json.decode(data);
    });
  }

  void atualizaItem(index, value) {
    setState(() {
      _todoList[index]['ok'] = value;
      _saveFile();
    });
  }

  void onAddButtonClicked() {
    if (todoTaskController.text.isNotEmpty) {
      var item = {};
      item['title'] = todoTaskController.text;
      item['ok'] = false;
      todoTaskController.clear();
      setState(() {
        _todoList.add(item);
      });
      _saveFile();
    }
  }

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
                      autofocus: true,
                      controller: todoTaskController,
                      decoration: InputDecoration(
                        labelText: 'New task',
                      )),
                ),
                RaisedButton(
                  textColor: Colors.white,
                  child: Icon(Icons.add),
                  onPressed: onAddButtonClicked,
                )
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
                padding: EdgeInsets.only(top: 10, left: 1, right: 1),
                itemCount: _todoList.length,
                itemBuilder: (context, index) {
                  return buildItem(context, index);
                }),
          ),
        ],
      ),
    );
  }

  Widget buildItem(BuildContext context, int index) {
    return Dismissible(
      key: UniqueKey(),
      onDismissed: (direction) {
        setState(() {
          lastRemovedElement = _todoList[index];
          lastRemovedIndex = index;
          _todoList.removeAt(index);
          _saveFile();
          final snackbar = SnackBar(
            content: Text("Task ${lastRemovedElement['title']} removed"),
            duration: Duration(seconds: 3),
            action: SnackBarAction(
              label: 'Desfazer?',
              onPressed: () {
                setState(() {
                  _todoList.insert(lastRemovedIndex, lastRemovedElement);
                  _saveFile();
                });
              },
            ),
          );
          Scaffold.of(context).showSnackBar(snackbar);
        });
      },
      child: CheckboxListTile(
          onChanged: (value) {
            atualizaItem(index, value);
          },
          secondary: CircleAvatar(
            child:
                _todoList[index]['ok'] ? Icon(Icons.check) : Icon(Icons.clear),
          ),
          title: Text(_todoList[index]['title']),
          value: _todoList[index]['ok']),
      direction: DismissDirection.startToEnd,
      background: Container(
          color: Colors.red,
          child: Align(
            alignment: Alignment(-.9, 0),
            child: Icon(
              Icons.delete,
              color: Colors.white,
            ),
          )),
    );
  }

  Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/data.json');
  }

  Future<File> _saveFile() async {
    var data = json.encode(_todoList);
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
