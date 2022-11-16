import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/domain/event/event_series.dart';
import 'package:flutter_frontend/domain/event/value_objects.dart';
import 'package:flutter_frontend/presentation/pages/event/event_series_form/cubit/event_series_form_cubit.dart';

extension ESF_Cubit_Editing on EventSeriesFormCubit {
  ///
  /// changes the title of the eventseries in the state, and emits a new state
  ///
  changeTitle(String title) {
    state.maybeMap(
        orElse: () {},
        ready: (readyState) {
          emit(readyState.copyWith(
              series: readyState.series.copyWith(name: EventName(title))));
        });
  }

  ///
  /// changes the description of the eventseries in the state, and emits a new state
  ///
  changeDescription(String description) {
    state.maybeMap(
        orElse: () {},
        ready: (readyState) {
          emit(readyState.copyWith(
              series: readyState.series
                  .copyWith(description: EventDescription(description))));
        });
  }

  changePublic(bool isPublic) {
    state.maybeMap(
        orElse: () {},
        ready: (readyState) {
          emit(readyState.copyWith(
              series: readyState.series.copyWith(public: isPublic)));
        });
  }
}
