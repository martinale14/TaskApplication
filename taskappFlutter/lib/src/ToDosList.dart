import 'package:flutter/material.dart';
import 'package:taskapp/helpers/Tasks.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class TodosList extends StatefulWidget {
  final List<Task> tasks;

  TodosList({Key key, @required this.tasks}) : super(key: key);
  @override
  _TodosListState createState() => _TodosListState();
}

class _TodosListState extends State<TodosList> {
  List<Task> _tasks = <Task>[];

  @override
  void initState() {
    super.initState();
    this._tasks = widget.tasks;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: _listItem(),
      ),
    );
  }

  List<Widget> _listItem() {
    List<Widget> items = [];

    if (this._tasks != null) {
      this._tasks.forEach((task) {
        items.add(Slidable(
          actionPane: SlidableDrawerActionPane(),
          actionExtentRatio: 0.25,
          child: Container(
            color: Colors.white,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.blue,
                child: Icon(Icons.chevron_right),
                foregroundColor: Colors.white,
              ),
              title: Text(task.title),
              subtitle: Text(task.description),
            ),
          ),
          secondaryActions: <Widget>[
            IconSlideAction(
              caption: 'Edit',
              color: Colors.blue,
              icon: Icons.edit,
              onTap: () => {},
            ),
            IconSlideAction(
              caption: 'Delete',
              color: Colors.red,
              icon: Icons.delete,
              onTap: () => {},
            ),
          ],
        ));
      });
    }

    return items;
  }
}
