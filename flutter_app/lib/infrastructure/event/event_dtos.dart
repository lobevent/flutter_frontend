import 'package:flutter_frontend/infrastructure/core/json_converters.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:flutter_frontend/infrastructure/core/base_dto.dart';
import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/domain/event/value_objects.dart';
import 'package:flutter_frontend/infrastructure/profile/profile_dtos.dart';

part 'event_dtos.freezed.dart';

part 'event_dtos.g.dart';

@freezed
abstract class EventDto extends BaseDto implements _$EventDto {
  const EventDto._();

  const factory EventDto({
    @required int id,
    @required String name,
    @required bool public,
    @required String description,
    @required DateTime date,
    @required DateTime creationDate,
    @required @ProfileConverter() ProfileDto owner,
  }) = EventDtoFull;

  const factory EventDto.withoutId({
    @required String name,
    @required bool public,
    @required String description,
    @required DateTime date,
    @required DateTime creationDate,
    @required @ProfileConverter() ProfileDto owner,
  }) = EventDtoWithoutId;

  factory EventDto.fromDomain(Event event) {
    EventDto returnedDto;

    return event.map(
        (value) => EventDto(
              id: value.id.getOrCrash(),
              name: value.name.getOrCrash(),
              public: value.public,
              date: value.date,
              description: value.description.getOrCrash(),
              creationDate: value.creationDate,
              owner: ProfileDto.fromDomain(value.owner),
            ),
        withoutId: (value) => EventDto.withoutId(
            name: value.name.getOrCrash(),
            public: value.public,
            date: value.date,
            description: value.description.getOrCrash(),
            creationDate: value.creationDate,
            owner: ProfileDto.fromDomain(value.owner)));
  }

  factory EventDto.fromJson(Map<String, dynamic> json) =>
      _$EventDtoFromJson(json);

  @override
  Event toDomain() {
   return map((value) => Event(
      id: Id.fromUnique(value.id),
      name: EventName(value.name),
      date: value.date,
      description: EventDescription(value.description),
      owner: value.owner.toDomain(),
      //TODO: don't forget this one!
      public: value.public,
      creationDate: value.creationDate,
    ), withoutId: (value) =>  Event.withoutId(
      name: EventName(value.name),
      date: value.date,
      description: EventDescription(description),
      owner: value.owner.toDomain(),
      //TODO: don't forget this one!
      public: value.public,
      creationDate: value.creationDate,
    ));
  }
}

