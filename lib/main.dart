import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:planit/features/home/data/models/task_model/task_model.dart';
import 'package:planit/features/home/presentation/view_models/selected_day_cubit.dart';
import 'package:planit/features/home/presentation/views/home_screen.dart';

import 'features/home/presentation/view_models/home_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(TaskModelAdapter());
  final taskBox = await Hive.openBox<TaskModel>('tasks');
  var settingsBox = await Hive.openBox<String>('settingsBox');

  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => MyApp(settingBox: settingsBox,taskBox: taskBox,),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.taskBox,required this.settingBox});

  final Box<TaskModel> taskBox;
  final Box<String> settingBox;


  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<TaskCubit>(
          create: (context) => TaskCubit(taskBox,settingBox),
        ),
        BlocProvider<SelectedDayCubit>(create: (context) => SelectedDayCubit()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        locale: DevicePreview.locale(context),
        builder: DevicePreview.appBuilder,
        home: HomeScreen(),
      ),
    );
  }
}
