import 'package:hive/hive.dart';

part 'task_model.g.dart';
@HiveType(typeId: 1)
class TaskModel extends HiveObject{

  @HiveField(0)
  final String title;
  @HiveField(1)
  bool isCompleted;

  @HiveField(2)
  final String day;
  TaskModel({required this.title,required this.isCompleted,required this.day});
}