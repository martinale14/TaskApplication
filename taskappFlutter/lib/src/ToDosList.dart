import 'package:flutter/material.dart';
import 'package:taskapp/helpers/Tasks.dart';
import 'package:taskapp/controllers/Petitions.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:taskapp/src/AddDialog.dart';

class TodosList extends StatefulWidget {
  final List<Task> tasks;
  final Function deleteCallBack;
  final Function updateCallBack;

  TodosList(
      {Key key, @required this.tasks, this.deleteCallBack, this.updateCallBack})
      : super(key: key);
  @override
  _TodosListState createState() => _TodosListState();
}

class _TodosListState extends State<TodosList> {
  @override
  void initState({Function deleteCallBack}) {
    super.initState();
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
    if (widget.tasks != null) {
      widget.tasks.forEach((task) {
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
              onTap: () {
                AddDialog(
                        titleEdit: task.title,
                        descEdit: task.description,
                        idEdit: task.id)
                    .showAnimatedWindow(context,
                        editCallBack: widget.updateCallBack);
              },
            ),
            IconSlideAction(
              caption: 'Delete',
              color: Colors.red,
              icon: Icons.delete,
              onTap: () {
                Petitions().deleteTask(task.id, widget.deleteCallBack);
              },
            ),
          ],
        ));
      });
    }

    return items;
  }
}
