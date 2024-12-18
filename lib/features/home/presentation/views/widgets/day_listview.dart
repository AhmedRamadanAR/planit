import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

import '../../view_models/selected_day_cubit.dart';
import 'day_item.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class DayListView extends StatelessWidget {
  final Function(String dayName) onDaySelected;

  DayListView({super.key, required this.onDaySelected});

  Map<String, String> getNext7DaysStartingMonday() {
    Map<String, String> daysWithDates = {};
    DateTime today = DateTime.now();
    int daysToMonday = today.weekday - DateTime.monday;
    DateTime monday = today.subtract(Duration(days: daysToMonday));

    for (int i = 0; i < 7; i++) {
      DateTime date = monday.add(Duration(days: i));
      String dayName = DateFormat('EEEE').format(date);
      String dayNumber = DateFormat('d').format(date);
      daysWithDates[dayName] = dayNumber;
    }

    return daysWithDates;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width; // Get screen width

    final daysWithDates = getNext7DaysStartingMonday();
    return BlocBuilder<SelectedDayCubit, String?>(
      builder: (context, selectedDay) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: SizedBox(
            height: 80,
            child: ListView.builder(shrinkWrap: true
              ,
              scrollDirection: Axis.horizontal,
              itemCount: daysWithDates.length,
              itemBuilder: (context, index) {
                String dayName = daysWithDates.keys.elementAt(index);
                String dayNumber = daysWithDates[dayName]!;

                return Padding(
                  padding: EdgeInsets.only(
                    right: index == daysWithDates.length - 1
                    ? screenWidth * 0.05 // Add extra padding for the last item
                        : 10.0,),
                  child: GestureDetector(
                    onTap: () {
                      BlocProvider.of<SelectedDayCubit>(context).selectDay(dayName);
                      onDaySelected(dayName);
                    },
                    child: DayItem(
                      dayName: dayName,
                      dayNumber: dayNumber,
                      isSelected: dayName == selectedDay,
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
