import 'package:flutter_frontend/domain/event/value_objects.dart';
import 'package:flutter_frontend/presentation/pages/event/event_series_form/cubit/event_series_form_cubit.dart';

extension ESF_Cubit_Editing on EventSeriesFormCubit{
  changeTitle(String title){
    state.maybeMap(orElse: () {}, ready: (readyState){
      emit(readyState.copyWith(series: readyState.series.copyWith(name: EventName(title))));
    });
  }

  changeDescription(String description){
    state.maybeMap(orElse: () {}, ready: (readyState){
      emit(readyState.copyWith(series: readyState.series.copyWith(description: EventDescription(description))));
    });
  }
}