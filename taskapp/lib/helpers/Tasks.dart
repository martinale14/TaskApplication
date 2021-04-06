class Task {
  final String id;
  final String title;
  final String description;

  Task({this.id, this.title, this.description});

  factory Task.fromJson(Map<String, dynamic> parsedJson) {
    return Task(
        id: parsedJson['_id'],
        title: parsedJson['title'],
        description: parsedJson['description']);
  }
}
