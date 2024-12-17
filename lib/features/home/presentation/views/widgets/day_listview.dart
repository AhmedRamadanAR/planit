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
    final daysWithDates = getNext7DaysStartingMonday();
    return BlocBuilder<SelectedDayCubit, String?>(
      builder: (context, selectedDay) {
        return Padding(
          padding: const EdgeInsets.all(30),
          child: Container(decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
            height: 80,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: daysWithDates.length,
              itemBuilder: (context, index) {
                String dayName = daysWithDates.keys.elementAt(index);
                String dayNumber = daysWithDates[dayName]!;

                return GestureDetector(
                  onTap: () {
                    BlocProvider.of<SelectedDayCubit>(context).selectDay(dayName);
                    onDaySelected(dayName);
                  },
                  child: DayItem(
                    dayName: dayName,
                    dayNumber: dayNumber,
                    isSelected: dayName == selectedDay,
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