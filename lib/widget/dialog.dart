import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';

import '../service/todo_service.dart';

class MyDialog extends StatelessWidget {
  const MyDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController detailController = TextEditingController();
    final todoService = TodoService();

    Future<void> handleSubmit() async {
      String title = titleController.text.trim();
      String detail = detailController.text.trim();
      if (title.isNotEmpty) {
        await todoService.createTodo(title, detail);
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Title is required")),
        );
      }
    }

    return AlertDialog(
      title: Column(
        children: [
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Title :  ',
                style: GoogleFonts.kanit(
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
              ),
              Gap(10),
              Expanded(
                child: TextFormField(
                  controller: titleController,
                  style: GoogleFonts.kanit(
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                  maxLines: 1,
                ),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Detail : ',
                style: GoogleFonts.kanit(
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Colors.black,
                  ),
                ),
              ),
              Gap(10),
              Expanded(
                child: TextFormField(
                  controller: detailController,
                  style: GoogleFonts.kanit(
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                  maxLines: 1,
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
            borderRadius: BorderRadius.circular(10),
          ),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: handleSubmit,
            child: Text(
              "Submit",
              style: GoogleFonts.kanit(
                textStyle: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
