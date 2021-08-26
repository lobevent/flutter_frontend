import 'package:flutter_frontend/domain/core/value_validators.dart';
import 'package:flutter_frontend/domain/todo/item.dart';
import 'package:flutter_frontend/infrastructure/todo/todo_dtos.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:flutter_frontend/infrastructure/core/base_dto.dart';
import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/domain/event/value_objects.dart';
import 'package:flutter_frontend/infrastructure/profile/profile_dtos.dart';

part 'event_dtos.freezed.dart';

part 'event_dtos.g.dart';

@freezed
class EventDto extends BaseDto with _$EventDto {


  const EventDto._();

  static const Map dtoToDomainStatus = {
  0: EventStatus.notAttending,
  1: EventStatus.attending,
  2: EventStatus.interested,
  };

  static final Map domainToDtoStatus = dtoToDomainStatus.map((key, value) => MapEntry(value, key));


  const factory EventDto({
    required String id,
    required String name,
    required bool public,
    required String? description,
    required DateTime date,
    required DateTime creationDate,
    int? attendingUsers,
    @TodoConverter() TodoDto? todo,
    @OwnerConverter() ProfileDto? owner,
    double? longitude,
    double? latitude,
    int? ownStatus,
  }) = EventDtoFull;


  factory EventDto.fromDomain(Event event) {
    EventDto returnedDto;


    return EventDto(
      id: event.id.getOrCrash(),
      name: event.name.getOrCrash(),
      public: event.public,
      date: event.date,
      description: event.description!.getOrCrash(),
      todo: event.todo != null ? TodoDto.fromDomain(event.todo!) : null,
      creationDate: event.creationDate,
      owner: ProfileDto.fromDomain(event.owner!),
      attendingUsers: event.attending,
      ownStatus:  domainToDtoStatus[event.status] as int?,
      longitude: event.longitude,
      latitude: event.latitude
    );
  }

  factory EventDto.fromJson(Map<String, dynamic> json) =>
      _$EventDtoFromJson(json);

  @override
  Event toDomain() {
   return Event(
      id: UniqueId.fromUniqueString(id),
      name: EventName(name),
      date: date,
      description: description  == null ? null: EventDescription(description!),
      todo: todo?.toDomain(),
      owner: owner?.toDomain(),
      //TODO: don't forget this one!
      public: public,
      creationDate: creationDate,
      attending: attendingUsers,
      status: dtoToDomainStatus[ownStatus] as EventStatus?,
      longitude: longitude,
      latitude: latitude
    );
  }
}



class OwnerConverter implements JsonConverter<ProfileDto, Map<String, dynamic>> {
  const OwnerConverter();

  @override
  ProfileDto fromJson(Map<String, dynamic> owner) {
   //owner["runtimeType"] = "justId";
    return ProfileDto.fromJson(owner);
  }

  @override
  Map<String, dynamic> toJson(ProfileDto profileDto) {
    return profileDto.toJson();
  }
}

class TodoConverter implements JsonConverter<TodoDto, Map<String, dynamic>>{
  const TodoConverter();

  @override
  TodoDto fromJson(Map<String, dynamic> todo) {
    return TodoDto.fromJson(todo);
  }

  @override
  Map<String, dynamic> toJson(TodoDto todoDto) {
    return todoDto.toJson();
  }
}
