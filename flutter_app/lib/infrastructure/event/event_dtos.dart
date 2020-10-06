
import 'package:flutter/cupertino.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'event_dtos.freezed.dart';
part 'event_dtos.g.dart';

@freezed
abstract class EventDto with _$EventDto{
    factory EventDto({
      @required int id,
      @required String name,
      @required bool public,
      @required String description,
      @required DateTime date,
      //ProfileDto profile, //TODO: implement profile
    }) = _EventDto;

    factory EventDto.fromDomain(Event event)
    {
      return EventDto(
        id: event.id,
        name: event.name.getOrCrash(),
        public: event.public,
        date: event.date,
        description: event.description.getOrCrash(),
        //profile: event.owner.

      );


    }

    factory EventDto.fromJson(Map<String, dynamic> json) =>
      _$EventDtoFromJson(json);



}