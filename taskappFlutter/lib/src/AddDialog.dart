import 'package:flutter/material.dart';
import 'package:taskapp/controllers/Petitions.dart';

class AddDialog {
  TextEditingController titleCon = TextEditingController();
  TextEditingController descCon = TextEditingController();
  String idEdit = '';

  AddDialog({String titleEdit, String descEdit, String idEdit}) {
    if (idEdit != null) {
      this.idEdit = idEdit;
    }
    if (idEdit != null) {
      titleCon.text = titleEdit;
      descCon.text = descEdit;
    }
  }

  void showAnimatedWindow(BuildContext context,
      {Function addCallBack, Function editCallBack}) {
    showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          final curvedValue = Curves.linearToEaseOut.transform(a1.value) - 1.0;

          return Transform(
            transform: Matrix4.translationValues(0.0, curvedValue * -300, 0.0),
            child: _showAddWindow(context, addCallBack,
                editCallBack: editCallBack),
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

  Widget _showAddWindow(BuildContext context, Function addCallBack,
      {Function editCallBack}) {
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
                onChanged: (value) {},
                decoration: InputDecoration(labelText: 'Title'),
              ),
            ),
            Container(
              child: TextField(
                controller: descCon,
                maxLines: 5,
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
                        if (titleCon.text != '' && descCon.text != '') {
                          if (this.idEdit != '') {
                            print('aqui me trabe');
                            Petitions().editTask(this.idEdit, titleCon.text,
                                descCon.text, editCallBack);
                          } else {
                            Petitions().addTask(titleCon.text, descCon.text,
                                callBack: addCallBack);
                          }
                          this.idEdit = '';
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
}
