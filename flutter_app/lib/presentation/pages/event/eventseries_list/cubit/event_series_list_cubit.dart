import 'package:bloc/bloc.dart';
import 'package:flutter_frontend/domain/core/failures.dart';
import 'package:flutter_frontend/domain/event/event_series.dart';
import 'package:flutter_frontend/infrastructure/event_series/eventSeries_repository.dart';
import 'package:flutter_frontend/presentation/core/utils/loading/scroll_listener.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';

part 'event_series_list_state.dart';
part 'event_series_list_cubit.freezed.dart';

class EventSeriesListCubit extends Cubit<EventSeriesListState> {

  // late ScrollListener listener;
  EventSeriesRepository repository = GetIt.I<EventSeriesRepository>();

  EventSeriesListCubit() : super(EventSeriesListState.loading()){
    loadEventSeriesLists();
    //this.listener = ScrollListener(loadMore: loadMore);
  }


  Future<void> loadEventSeriesLists()async{
    repository.getOwnedEventSeries(lastEventTime: DateTime.now(), amount: 20).then((value) => value.fold(
        (failure) {
          emit(EventSeriesListState.failure(failure));
        },
        (seriesList) {
          emit(EventSeriesListState.ready(seriesList));
        }));
  }

  // loadMore(){
  //
  // }
}
