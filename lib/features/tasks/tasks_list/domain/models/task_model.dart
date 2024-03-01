import 'dart:convert';

class TaskModel {
  String? id;
  String? title;
  String? date;
  String? image;
  bool? isDone;
  bool isChecked;
  TaskModel({
    required this.title,
    required this.date,
    required this.image,
    this.id,
    this.isDone = false,
    this.isChecked = false,
  });
  factory TaskModel.empty() {
    return TaskModel(
      title: null,
      date: null,
      image: null,
      isDone: false,
      isChecked: false,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'date': date,
      'image': "image",
      'isDone': isDone,
    };
  }

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'],
      title: map['title'] != null ? map['title'] as String : null,
      date: map['date'] != null ? map['date'] as String : null,
      image: map['image'] != null ? map['image'] as String : null,
      isDone: map['isDone'] != null ? map['isDone'] as bool : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory TaskModel.fromJson(String source) =>
      TaskModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
