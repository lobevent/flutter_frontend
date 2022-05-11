import 'package:bloc/bloc.dart';
import 'package:flutter_frontend/domain/core/failures.dart';
import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/domain/event/event_series.dart';
import 'package:flutter_frontend/domain/event/value_objects.dart';
import 'package:flutter_frontend/infrastructure/event_series/eventSeries_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';

part 'event_series_form_state.dart';
part 'event_series_form_cubit.freezed.dart';

class EventSeriesFormCubit extends Cubit<EventSeriesFormState> {

  final bool isEdit;
  EventSeriesRepository repository = GetIt.I<EventSeriesRepository>();


  EventSeriesFormCubit(this.isEdit) : super(EventSeriesFormState.initial()){
    // if the series is not edited but created, we have to generate a new eventseries object and pass it in the ready state
    if(!isEdit){
      EventSeries series = EventSeries(id: UniqueId(), description: EventDescription(''), name: EventName(''));
      emit(EventSeriesFormState.ready(series));
    }
  }


  ///
  /// is called on submission, sends the series back to the backend and emits either
  /// errorstate, or the saveReady state
  ///
  Future<void> saveSeries() async {
    repository.addSeries(retrieveFormReadyStateOrCrash().series).then(
            (response){
              response.fold(
                      (Netfailure) => emit(EventSeriesFormState.networkError(Netfailure)) ,
                      (series) => emit(EventSeriesFormState.savedReady())
              );
            });
    emit(const EventSeriesFormState.saving());
  }


  /// we want to only retrieve the form ready state, if its not there we crash
  ESF_Ready retrieveFormReadyStateOrCrash(){
    return state.maybeMap(orElse: (){throw UnimplementedError();}, ready: (readyState) => readyState);
  }


}
