import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import '../config.dart';
import '../model/todo_model.dart';

class TodoService {
  Map<String, dynamic>? data;

  Future getTodo() async {
    final apicon = Config();
    final dio = Dio();

    try {
      final response = await dio.get(
        "${apicon.protocol}${apicon.host}${apicon.apiver}${apicon.todo}",
      );
      if (response.statusCode == 200) {
        var data = todoFromJson(response.data);
        return data;
      }
      return [];
    } on DioException catch (e) {
      log("DioException: ${e.response?.data}");
      return e.response!;
    }
  }

  Future getTodoById({required int id}) async {
    final apicon = Config();
    final dio = Dio();

    try {
      final response = await dio.get(
        "${apicon.protocol}${apicon.host}${apicon.apiver}${apicon.todo}/${id}",
      );
      if (response.statusCode == 200) {
        var data = todoFromJson([response.data]);
        return data;
      }
      return [];
    } on DioException catch (e) {
      log("DioException: ${e.response?.data}");
      return e.response!;
    }
  }

  Future getTodoByTitle({required String title}) async {
    final apicon = Config();
    final dio = Dio();

    try {
      final response = await dio.get(
        "${apicon.protocol}${apicon.host}${apicon.apiver}${apicon.todo}/${title}",
      );
      if (response.statusCode == 200) {
        var data = todoFromJson(response.data);
        log('✅ getTodoByTitle created successfully');
        return data;
      }
      return [];
    } on DioException catch (e) {
      log("DioException: ${e.response?.data}");
      return e.response!;
    }
  }

  Future createTodo(String title, String detail) async {
    final apicon = Config();
    final dio = Dio();
    String? dueDate;
    final String formattedDueDate =
        dueDate ?? DateFormat('yyyy-MM-dd').format(DateTime.now());
    try {
      final response = await dio.post(
          "${apicon.protocol}${apicon.host}${apicon.apiver}${apicon.todo}",
          data: {
            "detail": detail,
            "due_date": formattedDueDate,
            "title": title
          });
      if (response.statusCode == 200) {
        log('✅ Task created successfully');
        return response.statusCode;
      }
      return [];
    } on DioException catch (e) {
      log("DioException: ${e.response?.data}");
      return e.response!;
    }
  }

  Future upDateTodo(
      {required int id,
      String? detail,
      bool? isDone,
      required String title}) async {
    final apicon = Config();
    final dio = Dio();
    final String formattedDueDate =
        DateFormat('yyyy-MM-dd').format(DateTime.now());

    try {
      final response = await dio.put(
        "${apicon.protocol}${apicon.host}${apicon.apiver}${apicon.todo}/$id",
        data: {
          "detail": detail,
          "is_done": isDone ?? false,
          "title": title,
          "due_date": formattedDueDate,
        },
      );
      if (response.statusCode == 200) {
        log('✅ Task Update successfully');

        return response.statusCode;
      }
      return [];
    } on DioException catch (e) {
      log("DioException: ${e.response?.data}");
      return e.response!;
    }
  }

  Future deleteTodo({required int id}) async {
    final apicon = Config();
    final dio = Dio();

    try {
      final response = await dio.delete(
        "${apicon.protocol}${apicon.host}${apicon.apiver}${apicon.todo}/${id}",
      );
      if (response.statusCode == 200) {
        return response.statusCode;
      }
      return [];
    } on DioException catch (e) {
      log("DioException: ${e.response?.data}");
      return e.response!;
    }
  }
}
