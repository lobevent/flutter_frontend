import 'package:bloc/bloc.dart';
import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/domain/event/value_objects.dart';
import 'package:flutter_frontend/infrastructure/event/event_local_service.dart';
import 'package:flutter_frontend/infrastructure/event/event_remote_service.dart';
import 'package:flutter_frontend/infrastructure/event/event_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/domain/event/event_failure.dart';


part 'event_form_cubit.freezed.dart';
part 'event_form_state.dart';

class EventFormCubit extends Cubit<EventFormState> {
  EventFormCubit() : super(EventFormState.initial()) {
    repository = EventRepository(EventRemoteService(), EventLocalService());
    emit(EventFormState.initial());}

  EventRepository repository;

  Future<void> saveEvent() async {
    Either<EventFailure, Unit> failureOrSuccess;
    dynamic test = state.event.failureOption;
    emit(state.copyWith(isSaving: true));
    if(state.event.failureOption.isNone()){
      Either<EventFailure, Unit> failureOrSuccess =  await right(unit);
    }
    emit(state.copyWith(isSaving: false, showErrorMessages: true, saveFailureOrSuccessOption: optionOf(failureOrSuccess)));
  }



  void changeTitle(String title){
    emit(state.copyWith(event: state.event.copyWith(name: EventName(title))));
  }

  void changeBody(String body) {
    emit(state.copyWith(event: state.event.copyWith(description: EventDescription(body))));
  }


//  Future<void> _getTrendingMovies() async {
//    try {
//      emit(EventFormState.loading());
//      final movies = await repository.getSingle(Id());
//      emit(EventFormState.loaded(Event.empty()));
//    } catch (e) {
//      emit(EventFormState.error(EventFailure.unexpected()));
//    }
//  }
}