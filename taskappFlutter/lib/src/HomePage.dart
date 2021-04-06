import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/io.dart';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:taskapp/helpers/Tasks.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<bool> _checked = new List<bool>();
  List<String> _idTo = new List<String>();
  WebSocketChannel _socket;
  String _title;
  String _description;

  @override
  void initState() {
    super.initState();
    this._title = '';
    this._description = '';
    this._initializeSocket();
  }

  _initializeSocket() async {
    // ignore: await_only_futures
    this._socket = await IOWebSocketChannel.connect('ws://192.168.20.64:3000');
    this._socket.stream.listen((event) {
      if (event == 'makeChange') {
        setState(() {
          this._fetchData();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task App'),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(0),
        margin: EdgeInsets.all(0),
        decoration: BoxDecoration(color: Colors.white.withOpacity(0)),
        child: Align(
            alignment: Alignment.topCenter,
            child: FutureBuilder(
              future: _fetchData(),
              builder:
                  (BuildContext context, AsyncSnapshot<List<Task>> snapshot) {
                if (snapshot.hasData) {
                  List<Task> tasks = snapshot.data;
                  return _createTable(tasks);
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }

                return CircularProgressIndicator();
              },
            )),
      ),
      floatingActionButton: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
              child: Icon(Icons.delete),
              onPressed: () {
                this._deleteTask();
              }),
          SizedBox(width: 10),
          FloatingActionButton(child: Icon(Icons.edit), onPressed: () {}),
          SizedBox(width: 180),
          FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                this._showAddWindow();
              }),
        ],
      ),
    );
  }

  Future<List<Task>> _fetchData() async {
    http.Response response =
        await http.get('http://192.168.20.64:3000/api/tasks');
    List<dynamic> data = jsonDecode(response.body) as List;
    List<Task> maps = data.map((e) => Task.fromJson(e)).toList();
    return maps;
  }

  Widget _createTable(List<Task> tasks) {
    List<DataRow> myRows = List<DataRow>();
    tasks.asMap().forEach((i, e) {
      _checked.add(false);
      _idTo.add('none');
      myRows.add(DataRow(cells: [
        DataCell(Checkbox(
          value: _checked[i],
          onChanged: (value) {
            setState(() {
              _checked[i] = value;
              if (value == true) {
                _idTo[i] = e.id;
              } else {
                _idTo.removeAt(i);
              }
            });
          },
        )),
        DataCell(Text('${e.title}')),
        DataCell(Text('${e.description}'))
      ]));
    });

    return DataTable(columns: [
      DataColumn(label: Text('Check')),
      DataColumn(label: Text('Title')),
      DataColumn(label: Text('Description'))
    ], rows: myRows);
  }

  _showAddWindow() {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text('Add Task'),
            content: Form(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    child: TextField(
                      onChanged: (value) {
                        this._title = value;
                      },
                      decoration: InputDecoration(labelText: 'Title'),
                    ),
                  ),
                  Container(
                    child: TextField(
                      maxLines: 5,
                      onChanged: (value) {
                        this._description = value;
                      },
                      decoration: InputDecoration(labelText: 'Description'),
                    ),
                  )
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Close')),
              FlatButton(
                onPressed: () {
                  this._addTask();
                  Navigator.of(context).pop();
                },
                child: Text('Agregar'),
              )
            ],
          );
        });
  }

  _addTask() async {
    http.Response respuesta = await http.post(
        'http://192.168.20.64:3000/api/tasks',
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json'
        },
        body:
            '{"title": "${this._title}", "description": "${this._description}"}');
    this._title = '';
    this._description = '';
    print(respuesta.body);
    setState(() {
      this._fetchData();
    });
    this._socket.sink.add('true');
  }

  _deleteTask() {
    this._idTo.asMap().forEach((i, e) {
      print('dato ' + e);
    });
    this._socket.sink.add('true');
  }

  @override
  void dispose() {
    this._socket.sink.close();
    super.dispose();
  }
}
