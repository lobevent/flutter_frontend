import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_frontend/domain/auth/auth_failure.dart';
import 'package:flutter_frontend/domain/auth/value_objects.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_frontend/domain/event/event.dart';


part 'own_events_state.freezed.dart';



@freezed
abstract class OwnEventsState with _$OwnEventsState {
  const factory OwnEventsState({
    @required List<Event> ownEventsList,
  }) = _OwnEventsState;


  factory OwnEventsState.initial() => OwnEventsState(
      ownEventsList: null,
  );


  factory OwnEventsState.loading() => OwnEventsState(
    ownEventsList: null,
  );

  factory OwnEventsState.loaded() => OwnEventsState(
    ownEventsList: null ,
  );

  factory OwnEventsState.error() => OwnEventsState(
     ownEventsList: null ,
  );
}







