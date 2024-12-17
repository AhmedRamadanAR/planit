import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planit/constants.dart';
import 'package:planit/features/home/data/models/task_model/task_model.dart';
import 'package:planit/features/home/presentation/view_models/home_cubit.dart';
import 'package:planit/features/home/presentation/views/widgets/day_listview.dart';
import 'package:planit/features/home/presentation/views/widgets/dialog_box.dart';
import 'package:planit/features/home/presentation/views/widgets/todo.dart';

import '../view_models/selected_day_cubit.dart';


class HomeScreen extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(backgroundColor:blueColor,foregroundColor:Colors.white,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        onPressed: () {
          final selectedDay = context.read<SelectedDayCubit>().state;
          if (selectedDay != null) {
            createNewTask(context, selectedDay);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Please select a day first')),
            );
          }
        },
        child: Icon(Icons.add),
      ),
      body: Column(
        children: [
          DayListView(
            onDaySelected: (day) {
              context.read<SelectedDayCubit>().selectDay(day);
            },
          ),
          Expanded(
            child: BlocBuilder<TaskCubit, Map<String, List<TaskModel>>>(
              builder: (context, tasks) {
                final selectedDay = context.watch<SelectedDayCubit>().state;

                if (selectedDay == null) {
                  return Center(child: Text('Please select a day.'));
                }

                final dayTasks = tasks[selectedDay] ?? [];

                return ListView.builder(
                  itemCount: dayTasks.length,
                  itemBuilder: (context, index) {
                    final task = dayTasks[index];
                    return ToDoTile(
                      key: ValueKey(task.key),
                      taskName: task.title,
                      isChecked: task.isCompleted,
                      onChanged: (_) {
                        if (selectedDay != null) {
                          TaskCubit.get(context).updateTask(selectedDay, index);
                        }
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void saveNewTask(BuildContext context, String selectedDay) {
    final task = _controller.text.trim();
    if (task.isNotEmpty) {
      context.read<TaskCubit>().addTask(selectedDay, task); // Pass selectedDay here
      _controller.clear();
      Navigator.of(context).pop();
    }
  }

  void cancelDialog(BuildContext context) {
    _controller.clear();
    Navigator.pop(context);
  }

  void createNewTask(BuildContext context, String selectedDay) {
    showDialog(
      context: context,
      builder: (context) => DialogBox(
        controller: _controller,
        onSave: () => saveNewTask(context, selectedDay), // Pass selectedDay to save task
        onCancel: () => cancelDialog(context),
      ),
    );
  }
}
