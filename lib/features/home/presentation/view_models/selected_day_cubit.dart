import 'package:flutter_bloc/flutter_bloc.dart';

class SelectedDayCubit extends Cubit<String?> {
  SelectedDayCubit() : super(null);

  void selectDay(String dayName) {
    emit(dayName);
  }
}
