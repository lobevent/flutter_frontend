import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/domain/event/event_failure.dart';
import 'package:flutter_frontend/domain/event/value_objects.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:flutter_frontend/domain/profile/value_objects.dart';
import 'package:flutter_frontend/infrastructure/event/event_local_service.dart';
import 'package:flutter_frontend/infrastructure/event/event_remote_service.dart';
import 'package:flutter_frontend/infrastructure/event/event_repository.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:meta/meta.dart';

part 'event_screen_state.dart';
part 'event_screen_cubit.freezed.dart';

class EventScreenCubit extends Cubit<EventScreenState> {
  EventScreenCubit(UniqueId id) : super(EventScreenState.loading()) {
    emit(EventScreenState.loading());
    getEvent(id);
  }

  EventRepository repository =
      EventRepository(EventRemoteService(), EventLocalService());

  Future<void> getEvent(UniqueId id) async {

    final Event ownEventsList= await Future.delayed(Duration(seconds: 2), () {
      return
        Event(id: UniqueId(), name: EventName("test"), date: DateTime.now(), description: EventDescription("lalal"), creationDate: DateTime.now(), owner: Profile(id: UniqueId(), name: ProfileName("ssss")), public: true,longitude: 0,latitude: 0);
    });


    repository.getSingle(id).then((eventOrFailure) =>
        eventOrFailure.fold(
            (failure) => emit(EventScreenState.error(failure: failure)),
            (event) => emit(EventScreenState.loaded(event: event)
            )
        )
    );
  }



}
