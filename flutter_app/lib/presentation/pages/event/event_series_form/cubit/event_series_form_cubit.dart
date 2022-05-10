import 'package:bloc/bloc.dart';
import 'package:flutter_frontend/domain/event/event_series.dart';
import 'package:flutter_frontend/infrastructure/event_series/eventSeries_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';

part 'event_series_form_state.dart';
part 'event_series_form_cubit.freezed.dart';

class EventSeriesFormCubit extends Cubit<EventSeriesFormState> {
  final bool isEdit;

  EventSeriesRepository repository = GetIt.I<EventSeriesRepository>();


  EventSeriesFormCubit(this.isEdit) : super(EventSeriesFormState.initial()){}


  Future<void> saveSeries() async {
    repository.addSeries(retrieveFormReadyStateOrCrash().series).then(
            (response){
              response.fold((l) {emit(EventSeriesFormState.error());} , (r) => null);
            });
    emit(EventSeriesFormState.saving());
  }


  ESF_Ready retrieveFormReadyStateOrCrash(){
    return state.maybeMap(orElse: (){throw UnimplementedError();}, ready: (readyState) => readyState);
  }


}
