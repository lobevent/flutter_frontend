import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_frontend/domain/auth/auth_failure.dart';
import 'package:flutter_frontend/domain/auth/value_objects.dart';
import 'package:flutter_frontend/domain/event/event_failure.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_frontend/domain/event/event.dart';


part 'own_events_state.freezed.dart';



@freezed
abstract class OwnEventsState with _$OwnEventsState {
  const factory OwnEventsState({
    @required List<Event> ownEventsList,
  }) = _OwnEventsState;


  factory OwnEventsState.initial() = _Initial;


  factory OwnEventsState.loading() = _LoadInProgress;

  factory OwnEventsState.loaded({@required List<Event> events}) = _Loaded;

  factory OwnEventsState.error(EventFailure eventFailure) = _LoadFailure;
}




