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
  List<bool> _checked = <bool>[];
  List<String> _idTo = <String>[];
  WebSocketChannel _socket;
  String _title;
  String _description;
  TextEditingController titleCon;
  TextEditingController descCon;
  String _ip;

  @override
  void initState() {
    super.initState();
    this._title = '';
    this._description = '';
    _ip = '192.168.20.64';
    titleCon = TextEditingController();
    descCon = TextEditingController();
    this._initializeSocket();
  }

  _initializeSocket() async {
    // ignore: await_only_futures
    this._socket = await IOWebSocketChannel.connect("ws://${this._ip}:3000");
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
    return SafeArea(
      top: true,
      bottom: true,
      child: Scaffold(
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
          mainAxisAlignment: MainAxisAlignment.end,
          mainAxisSize: MainAxisSize.max,
          children: [
            FloatingActionButton(
                child: Icon(Icons.delete),
                onPressed: () {
                  this._deleteTask();
                }),
            SizedBox(
              width: 15,
            ),
            FloatingActionButton(child: Icon(Icons.edit), onPressed: () {}),
            SizedBox(width: 165),
            FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                this._showAnimatedWindow(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<List<Task>> _fetchData() async {
    http.Response response =
        await http.get("http://${this._ip}:3000/api/tasks");
    List<dynamic> data = jsonDecode(response.body) as List;
    List<Task> maps = data.map((e) => Task.fromJson(e)).toList();
    return maps;
  }

  Widget _createTable(List<Task> tasks) {
    List<DataRow> myRows = <DataRow>[];
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

  void _showAnimatedWindow(BuildContext context) {
    showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          final curvedValue = Curves.linearToEaseOut.transform(a1.value) - 1.0;

          return Transform(
            transform: Matrix4.translationValues(0.0, curvedValue * -300, 0.0),
            child: _showAddWindow(context),
          );
        },
        transitionDuration: Duration(milliseconds: 250),
        barrierDismissible: true,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) {
          return Container();
        });
  }

  Widget _showAddWindow(BuildContext context) {
    return AlertDialog(
      insetPadding: EdgeInsets.all(30),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      titlePadding: EdgeInsets.zero,
      title: Container(
        width: MediaQuery.of(context).size.width,
        height: 70,
        margin: EdgeInsets.zero,
        child: Center(
          child: Text(
            'Add Task',
            style: TextStyle(
                fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      ),
      content: Form(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              child: TextField(
                controller: titleCon,
                onChanged: (value) {
                  this._title = value;
                },
                decoration: InputDecoration(labelText: 'Title'),
              ),
            ),
            Container(
              child: TextField(
                controller: descCon,
                maxLines: 5,
                onChanged: (value) {
                  this._description = value;
                },
                decoration: InputDecoration(labelText: 'Description'),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  width: 120,
                  height: 45,
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ButtonStyle(
                          shape: MaterialStateProperty.all<OutlinedBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)))),
                      child: Text(
                        'Cancelar',
                        style: TextStyle(fontSize: 18),
                      )),
                ),
                SizedBox(
                  width: 20,
                ),
                SizedBox(
                  width: 120,
                  height: 45,
                  child: ElevatedButton(
                      onPressed: () {
                        print(descCon.text);
                        if (titleCon.text != '' && descCon.text != '') {
                          print('Presed');
                          this._addTask();
                          descCon.text = '';
                          titleCon.text = '';
                          Navigator.pop(context);
                        }
                      },
                      style: ButtonStyle(
                          shape: MaterialStateProperty.all<OutlinedBorder>(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)))),
                      child: Text(
                        'Agregar',
                        style: TextStyle(fontSize: 18),
                      )),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  void _addTask() async {
    http.Response respuesta = await http.post(
        "http://${this._ip}:3000/api/tasks",
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json'
        },
        body:
            '{"title": "${this._title}", "description": "${this._description}"}');
    this._title = '';
    this._description = '';
    print('entre');
    print(respuesta.body);
    setState(() {
      this._fetchData();
    });
    //this._socket.sink.add('true');
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
