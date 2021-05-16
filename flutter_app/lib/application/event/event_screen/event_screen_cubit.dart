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
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';

part 'event_screen_state.dart';
part 'event_screen_cubit.freezed.dart';

class EventScreenCubit extends Cubit<EventScreenState> {
  EventScreenCubit(UniqueId id) : super(EventScreenState.loading()) {
    emit(EventScreenState.loading());
    getEvent(id);
  }

  EventRepository repository = GetIt.I<EventRepository>();

  Future<void> getEvent(UniqueId id) async {


    repository.getSingle(id).then((eventOrFailure) =>
        eventOrFailure.fold(
            (failure) => emit(EventScreenState.error(failure: failure)),
            (event) => emit(EventScreenState.loaded(event: event)
            )
        )
    );
  }



}
