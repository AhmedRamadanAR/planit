import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:planit/constants.dart';
import 'package:planit/core/utilis/style.dart';



class DayItem extends StatelessWidget {
  final String dayName;
  final String dayNumber;
  final bool isSelected;

  const DayItem({
    super.key,
    required this.dayName,
    required this.dayNumber,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isSelected ? Colors.blue : cyanColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        children: [
          Text(dayName, style: Styles.textStyle18.copyWith(color: isSelected ? Colors.black : blueColor)
          ,
          )
        ,
      Text(dayNumber, style: Styles.textStyle18.copyWith(color: isSelected ? Colors.black : blueColor)

      ) ],
      ),
    );
  }
}
