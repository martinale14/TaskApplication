import 'dart:convert';
import 'package:taskapp/helpers/Tasks.dart';
import 'package:http/http.dart' as http;

class Petitions {
  String ip = '';

  Petitions() {
    ip = '192.168.20.27';
  }

  Future<List<Task>> fetchData() async {
    http.Response response = await http.get("http://${this.ip}:3000/api/tasks");
    List<dynamic> data = jsonDecode(response.body) as List;
    List<Task> maps = data.map((e) => Task.fromJson(e)).toList();

    return maps;
  }

  void addTask(String title, String desc, {Function callBack}) async {
    await http.post("http://${this.ip}:3000/api/tasks",
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json'
        },
        body: '{"title": "$title", "description": "$desc"}');
    callBack();
  }

  void deleteTask(String id, Function callBack) async {
    await http.delete("http://${this.ip}:3000/api/tasks/$id", headers: {
      'Content-type': 'application/json',
      'Accept': 'application/json'
    });
    callBack();
  }

  void editTask(String id, String title, String desc, Function callBack) async {
    await http.put("http://${this.ip}:3000/api/tasks/$id",
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json'
        },
        body: '{"title": "$title", "description": "$desc"}');
    callBack();
  }
}
