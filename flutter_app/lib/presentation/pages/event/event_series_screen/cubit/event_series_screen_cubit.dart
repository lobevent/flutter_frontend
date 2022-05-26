import 'package:bloc/bloc.dart';
import 'package:flutter_frontend/domain/core/failures.dart';
import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/domain/event/event_series.dart';
import 'package:flutter_frontend/infrastructure/event_series/eventSeries_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';

part 'event_series_screen_state.dart';
part 'event_series_screen_cubit.freezed.dart';

class EventSeriesScreenCubit extends Cubit<EventSeriesScreenState> {
  EventSeriesRepository repository = GetIt.I<EventSeriesRepository>();
  UniqueId seriesId;

  EventSeriesScreenCubit({required this.seriesId}) : super(EventSeriesScreenState.loading()){loadEventSeries();}

  Future<void> loadEventSeries()async{
    repository.getSeriesById(seriesId).then((series) {
      series.fold(
              (failure) => emit(EventSeriesScreenState.failure(failure)),
              (series) => emit(EventSeriesScreenState.ready(series)));

    });
  }


  Future<void> subscribe() async{
    state.maybeMap(orElse: (){}, ready: (readyState) {
      this.repository.addSubscription(readyState.series).then((value) => {});
    });

  }
}
