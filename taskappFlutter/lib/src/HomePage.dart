import 'package:flutter/material.dart';
import 'package:taskapp/controllers/Petitions.dart';
import 'package:taskapp/src/AddDialog.dart';
import 'package:taskapp/src/ToDosList.dart';
import 'package:taskapp/helpers/Tasks.dart';
import 'package:taskapp/controllers/SocketCon.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  SocketCon _socket;
  List<Task> myTasks = <Task>[];

  @override
  void initState() {
    super.initState();
    _socket = SocketCon(() {
      setState(() {});
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
                future: Petitions().fetchData(),
                builder:
                    (BuildContext context, AsyncSnapshot<List<Task>> snapshot) {
                  if (snapshot.hasData) {
                    this.myTasks = snapshot.data;
                    return TodosList(
                      tasks: this.myTasks,
                      deleteCallBack: () {
                        this._socket.changeMaked();
                        setState(() {});
                      },
                      updateCallBack: () {
                        this._socket.changeMaked();
                        setState(() {});
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  }

                  return CircularProgressIndicator();
                },
              )),
        ),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              AddDialog().showAnimatedWindow(context, addCallBack: () {
                this._socket.changeMaked();
                setState(() {});
              });
            }),
      ),
    );
  }

  @override
  void dispose() {
    this._socket.changeMaked();
    super.dispose();
  }
}
