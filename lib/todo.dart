import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:test_zoom/home.dart';
import 'package:test_zoom/model/todo_model.dart';

import 'service/todo_service.dart';

class Todo extends StatefulWidget {
  const Todo({super.key, required this.todo});
  final TodoModel todo;
  @override
  State<Todo> createState() => _TodoState();
}

class _TodoState extends State<Todo> {
  String formattedDate = '';
  bool? check;
  DateTime? dueDate;
  @override
  void initState() {
    super.initState();
    check = widget.todo.isDone;
    dueDate = widget.todo.dueDate;
    if (dueDate != null) {
      formattedDate = DateFormat('dd/MM/yyyy').format(dueDate!);
    } else {
      formattedDate = 'Invalid date';
    }
  }

  final TextEditingController detailController = TextEditingController();

  final todoService = TodoService();

  Future<void> upDateSubmit() async {
    String detail = detailController.text.trim();
    if (detail.isNotEmpty) {
      await todoService.upDateTodo(
          id: widget.todo.id as int,
          detail: detail,
          title: widget.todo.title.toString(),
          isDone: check);

      setState(() {});
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => Home()),
        (Route<dynamic> route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Detail is required")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: TodoService().getTodoById(id: widget.todo.id as int),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: Text('Loading...'),
            ),
          );
        } else if (snapshot.hasError) {
          log("snap :: ${snapshot.data}");
          return const Scaffold(
            body: Center(
              child: Text('Error Data...'),
            ),
          );
        } else if (!snapshot.hasData) {
          return const Text(
            'No Data Available',
            style: TextStyle(fontSize: 24),
          );
        } else {
          final todo = snapshot.data!;
          return Scaffold(
            appBar: AppBar(
              actions: [
                IconButton(
                  onPressed: () async {
                    await upDateSubmit();
                  },
                  icon: const Icon(Icons.edit),
                ),
              ],
              title: Text(
                todo.first.title,
                style: GoogleFonts.kanit(fontSize: 24),
              ),
            ),
            body: Form(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Stack(
                  children: [
                    Column(
                      children: [
                        TextFormField(
                          controller: detailController
                            ..text = widget.todo.detail ?? "",
                          decoration: const InputDecoration(
                            fillColor: Colors.transparent,
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.brown,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.brown,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.black, width: 2),
                            ),
                          ),
                          maxLines: 5,
                          keyboardType: TextInputType.text,
                          onTap: () {
                            log("in");
                          },
                        ),
                        const Gap(50),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  Container(
                                    child: Text(
                                      'Done',
                                      style: GoogleFonts.poppins(
                                        textStyle: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Checkbox(
                                    value: check,
                                    onChanged: (value) {
                                      setState(() {
                                        check = value;
                                      });
                                    },
                                  )
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    'due date',
                                    style: GoogleFonts.poppins(
                                      textStyle: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    formattedDate,
                                    style: GoogleFonts.poppins(
                                      textStyle: const TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
