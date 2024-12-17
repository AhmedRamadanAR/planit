
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:planit/features/home/data/models/task_model/task_model.dart';
import 'package:intl/intl.dart';

import 'package:hive_flutter/hive_flutter.dart';
class TaskCubit extends Cubit<Map<String, List<TaskModel>>> {
  final Box<TaskModel> _taskBox;
  final Box<String> _settingsBox;

  TaskCubit(this._taskBox, this._settingsBox) : super({}) {
    loadTodos();
  }
static TaskCubit get(context)=>BlocProvider.of(context);

  void loadTodos() {
    final tasks = <String, List<TaskModel>>{};

    DateTime now = DateTime.now();

    final lastResetDate = _settingsBox.get('lastResetDate', defaultValue: '');
    print("lasst" + lastResetDate.toString());

    if (lastResetDate!.isEmpty) {
      _settingsBox.put('lastResetDate', DateFormat('yyyy-MM-dd').format(now));
    } else {
      final lastResetDateTime = DateFormat('yyyy-MM-dd').parse(lastResetDate!);

      if (now.isAfter(lastResetDateTime.add(Duration(days: 7)))) {
        deleteAllTasks(); // Reset tasks for the new week
        _settingsBox.put('lastResetDate', DateFormat('yyyy-MM-dd').format(now)); // Update the last reset date
      }
    }

    for (var day in [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ]) {
      tasks[day] = _taskBox.values.where((task) => task.day == day).toList();
      print('Tasks for $day: ${tasks[day]}');
    }

    emit(tasks);
  }

  void deleteAllTasks() {
    _taskBox.clear();
    print("All tasks deleted.");
    emit({});
  }

  void addTask(String day, String title) {
    final newTask = TaskModel(title: title, isCompleted: false, day: day);
    _taskBox.add(newTask);
    final currentTasks = state[day] ?? [];
    currentTasks.add(newTask);
    final updatedTasks = Map<String, List<TaskModel>>.from(state);
    updatedTasks[day] = currentTasks;
    loadTodos();

    emit(updatedTasks);
  }


  void updateTask(String day, int index) {
    final currentTasks = state[day] ?? [];
    final task = currentTasks[index];
    task.isCompleted = !task.isCompleted;

    _taskBox.put(task.key, task);



    currentTasks[index] = task;
    final updatedTasks = Map<String, List<TaskModel>>.from(state);
    updatedTasks[day] = currentTasks;

    emit(updatedTasks);
  }
  void deleteTask(String day, int index) {
    final currentTasks = state[day] ?? [];
    _taskBox.deleteAt(index);

    print('Deleted task at index: $index');

    currentTasks.removeAt(index);
    final updatedTasks = Map<String, List<TaskModel>>.from(state);
    updatedTasks[day] = currentTasks;

    emit(updatedTasks);
  }

}

