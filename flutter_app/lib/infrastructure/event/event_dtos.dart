import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/domain/event/value_objects.dart';
import 'package:flutter_frontend/infrastructure/profile/profile_dtos.dart';

part 'event_dtos.freezed.dart';
part 'event_dtos.g.dart';

@freezed
abstract class EventDto with _$EventDto {
  const EventDto._();

  const factory EventDto({
    int id,
    @required String name,
    @required bool public,
    @required String description,
    @required DateTime date,
    @required DateTime creationDate,
    @required @OwnerConverter() ProfileDto owner,
  }) = _EventDto;

  factory EventDto.fromDomain(Event event) {
    return EventDto(
      id: event.id,
      name: event.name.getOrCrash(),
      public: event.public,
      date: event.date,
      description: event.description.getOrCrash(),
      creationDate: event.creationDate,
      owner: ProfileDto.fromDomain(event.owner),
    );
  }

  factory EventDto.fromJson(Map<String, dynamic> json) =>
      _$EventDtoFromJson(json);

  Event toDomain() {
    return Event(
      id: id,
      name: EventName(name),
      date: date,
      description: EventDescription(description),
      owner: owner.toDomain(), //TODO: don't forget this one!
      public: public,
      creationDate: creationDate,
    );
  }
}

class OwnerConverter implements JsonConverter<ProfileDto, Map<String, dynamic>>{
  const OwnerConverter();
  @override
  ProfileDto fromJson(Map<String, dynamic> owner) {
    return ProfileDto.fromJson(owner);
  }

  @override
  Map<String, dynamic> toJson(ProfileDto profileDto) {
    return profileDto.toJson();
  }
}

