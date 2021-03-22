import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:flutter_frontend/infrastructure/core/base_dto.dart';
import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/domain/event/value_objects.dart';
import 'package:flutter_frontend/infrastructure/profile/profile_dtos.dart';

part 'event_dtos.freezed.dart';

part 'event_dtos.g.dart';

@freezed
class EventDto extends BaseDto implements _$EventDto {
  const EventDto._();

  const factory EventDto({
    required String id,
    required String name,
    required bool public,
    required String description,
    required DateTime date,
    required DateTime creationDate,
    @OwnerConverter() required ProfileDto owner,
  }) = EventDtoFull;


  factory EventDto.fromDomain(Event event) {
    EventDto returnedDto;

    return EventDto(
              id: event.id.getOrCrash(),
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

  @override
  Event toDomain() {
   return Event(
      id: Id.fromUnique(id),
      name: EventName(name),
      date: date,
      description: EventDescription(description),
      owner: owner.toDomain(),
      //TODO: don't forget this one!
      public: public,
      creationDate: creationDate,
    );
  }
}



class OwnerConverter
    implements JsonConverter<ProfileDto, Map<String, dynamic>> {
  const OwnerConverter();

  @override
  ProfileDto fromJson(Map<String, dynamic> owner) {
    owner["runtimeType"] = "justId";
    return ProfileDto.fromJson(owner);
  }

  @override
  Map<String, dynamic> toJson(ProfileDto profileDto) {
    return profileDto.toJson();
  }
}
