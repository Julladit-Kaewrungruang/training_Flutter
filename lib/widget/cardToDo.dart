import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';

import '../todo.dart';

class Cardtodo extends StatelessWidget {
  const Cardtodo(
      {super.key,
      required this.title,
      required this.subTitle,
      required this.onPressedDelete,
      required this.onPressedEdit,
      required this.iconDone});
  final String title;
  final String subTitle;
  final Function(BuildContext) onPressedDelete;
  final Function(BuildContext) onPressedEdit;
  final IconData iconDone;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Slidable(
        key: ValueKey(title),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              flex: 2,
              onPressed: onPressedEdit,
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF2E2E3E),
              label: 'Edit',
              padding: const EdgeInsets.symmetric(horizontal: 5),
              borderRadius: BorderRadius.circular(10),
            ),
            const SizedBox(width: 10),
            SlidableAction(
              flex: 2,
              onPressed: onPressedDelete,
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF2E2E3E),
              label: 'Delete',
              padding: const EdgeInsets.symmetric(horizontal: 5),
              borderRadius: BorderRadius.circular(10),
            ),
          ],
        ),
        child: Card(
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: ListTile(
            leading: Icon(
              iconDone,
              color: Color(0xff46475E),
              size: 25,
            ),
            title: Text(
              title,
              style: GoogleFonts.poppins(
                fontSize: 15,
                color: const Color(0xff2E2E3E),
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: Text(
              subTitle,
              style: GoogleFonts.poppins(
                fontSize: 11,
                color: const Color(0xff2E2E3E),
                fontWeight: FontWeight.w200,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
