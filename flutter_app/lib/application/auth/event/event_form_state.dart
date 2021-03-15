import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_frontend/domain/auth/auth_failure.dart';
import 'package:flutter_frontend/domain/auth/value_objects.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/domain/event/event_failure.dart';
import 'package:freezed_annotation/freezed_annotation.dart';


//part of 'event_form_cubit.dart';
part 'event_form_state.freezed.dart';



@freezed
abstract class EventFormState with _$EventFormState {

  const factory EventFormState({
    @required Event event,
    @required bool idEditing,
  }) = _EventFormState;


  factory EventFormState.initial() => EventFormState(
    event: Event.empty(),
    idEditing: false,
  );

  factory EventFormState.loading() => EventFormState(
    event: Event.empty(),
    idEditing: false,
  );

  factory EventFormState.loaded(Event event) => EventFormState(
    event: event,
    idEditing: true,
  );

  factory EventFormState.error(EventFailure eventFailure) = _LoadFailure;
}

