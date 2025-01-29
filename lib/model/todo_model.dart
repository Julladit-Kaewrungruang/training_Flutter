import 'dart:convert';

List<TodoModel> todoFromJson(dynamic str) =>
    List<TodoModel>.from(str.map((x) => TodoModel.fromJson(x)));

String todoToJson(List<TodoModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TodoModel {
  final String? title;
  final String? detail;
  final dynamic isDoneTimestamp;
  final int? id;
  final bool? isDone;
  final DateTime? dueDate;

  TodoModel({
    this.title,
    this.detail,
    this.isDoneTimestamp,
    this.id,
    this.isDone,
    this.dueDate,
  });

  factory TodoModel.fromJson(Map<String, dynamic> json) => TodoModel(
        title: json["title"],
        detail: json["detail"],
        isDoneTimestamp: json["is_done_timestamp"],
        id: json["id"],
        isDone: json["is_done"],
        dueDate:
            json["due_date"] == null ? null : DateTime.parse(json["due_date"]),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "detail": detail,
        "is_done_timestamp": isDoneTimestamp,
        "id": id,
        "is_done": isDone,
        "due_date":
            "${dueDate!.year.toString().padLeft(4, '0')}-${dueDate!.month.toString().padLeft(2, '0')}-${dueDate!.day.toString().padLeft(2, '0')}",
      };
}
