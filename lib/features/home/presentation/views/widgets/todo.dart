
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:planit/constants.dart';

class ToDoTile extends StatelessWidget {
  final String taskName;
  final bool isChecked;
  Function(bool?)? onChanged;

  ToDoTile({super.key, required this.taskName, required this.isChecked, this.onChanged});


  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.all(8.0),

      child: Container(
        decoration: BoxDecoration(
            color: const Color(0xFF979797),
            borderRadius: BorderRadius.circular(12)),
        child: Row(
          children: [
            Checkbox(checkColor: Colors.white,activeColor: blueColor,
              value: isChecked,
              onChanged: onChanged,
            ),
            Text(
              taskName,
              style: TextStyle(decoration: isChecked? TextDecoration.lineThrough : TextDecoration.none),
            )
          ],
        ),
      ),

    );
  }
}