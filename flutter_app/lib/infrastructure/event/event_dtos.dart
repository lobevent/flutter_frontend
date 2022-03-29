import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/domain/event/invitation.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/domain/event/value_objects.dart';
import 'package:flutter_frontend/infrastructure/core/base_dto.dart';
import 'package:flutter_frontend/infrastructure/core/json_converters.dart';
import 'package:flutter_frontend/infrastructure/invitation/invitation_dtos.dart';
import 'package:flutter_frontend/infrastructure/profile/profile_dtos.dart';
import 'package:flutter_frontend/infrastructure/todo/todo_dtos.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

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

  static final Map domainToDtoStatus =
      dtoToDomainStatus.map((key, value) => MapEntry(value, key));

  @JsonSerializable(explicitToJson: true)
  const factory EventDto({
    required String id,
    required String name,
    required bool public,
    required String? description,
    required DateTime date,
    required bool visibleWithoutLogin,
    required DateTime creationDate,
    int? attendingUsersCount,
    @TodoConverter() TodoDto? todo,
    @OwnerConverter() ProfileDto? owner,
    @InvitationsToProfileConverter() List<InvitationDto>? invitations,
    bool? liked,
    double? longitude,
    double? latitude,
    int? ownStatus,
    @JsonKey(ignore: true) bool? isHost,
  }) = EventDtoFull;

  factory EventDto.fromDomain(Event event) {
    EventDto returnedDto;
    return EventDto(
      id: event.id.value,
      name: event.name.getOrCrash(),
      public: event.public,
      date: event.date,
      description:
          event.description != null ? event.description!.getOrCrash() : null,
      todo: event.todo != null ? TodoDto.fromDomain(event.todo!) : null,
      creationDate: event.creationDate,
      owner: event.owner!=null ? ProfileDto.fromDomain(event.owner!)
          :null,
      attendingUsersCount: event.attendingCount,
      ownStatus: domainToDtoStatus[event.status] as int?,
      longitude: event.longitude,
      latitude: event.latitude,
      visibleWithoutLogin: event.visibleWithoutLogin,
      invitations:
          event.invitations.map((i) => InvitationDto.fromDomain(i)).toList(),
    );
  }

  factory EventDto.fromJson(Map<String, dynamic> json) =>
      _$EventDtoFromJson(json);

  @override
  Event toDomain() {
    List<Invitation> invitationL = invitations
            ?.map<Invitation>((e) => e.toDomain() as Invitation)
            .toList() ??
        <Invitation>[];
    return Event(
      id: UniqueId.fromUniqueString(id),
      name: EventName(name),
      date: date,
      description: description == null ? null : EventDescription(description!),
      todo: todo == null ? null : todo!.toDomain(),
      owner: owner?.toDomain(),
      //TODO: don't forget this one!
      public: public,
      liked: liked,
      creationDate: creationDate,
      attendingCount: attendingUsersCount,
      status: dtoToDomainStatus[ownStatus] as EventStatus?,
      longitude: longitude,
      latitude: latitude,
      visibleWithoutLogin: visibleWithoutLogin,
      invitations: invitationL,
      isHost: isHost ?? false
    );
  }
}

class OwnerConverter
    implements JsonConverter<ProfileDto, Map<String, dynamic>> {
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

class TodoConverter implements JsonConverter<TodoDto, Map<String, dynamic>> {
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

class InvitationsToProfileConverter extends ListConverter<InvitationDto> {
  const InvitationsToProfileConverter() : super();
}
