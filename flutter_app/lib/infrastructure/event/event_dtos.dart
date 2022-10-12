import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/domain/event/invitation.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/domain/event/value_objects.dart';
import 'package:flutter_frontend/infrastructure/core/base_dto.dart';
import 'package:flutter_frontend/infrastructure/core/json_converters.dart';
import 'package:flutter_frontend/infrastructure/event_series/eventSeries_dtos.dart';
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
    3: EventStatus.invited,
    4: EventStatus.confirmAttending,
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
    int? maxPersons,
    @SeriesConverter() EventSeriesDto? eventSeries,
    @TodoConverter() TodoDto? todo,
    @OwnerConverter() ProfileDto? owner,
    @InvitationsToProfileConverter() List<InvitationDto>? invitations,
    bool? liked,
    double? longitude,
    double? latitude,
    String? address,
    int? ownStatus,
    String? image,
    double? distance,
    //@JsonKey(ignore: true) bool? isHost,
    bool? isHost,
  }) = EventDtoFull;

  factory EventDto.fromDomain(Event event) {
    EventDto returnedDto;
    return EventDto(
        maxPersons: event.maxPersons,
        id: event.id.value,
        name: event.name.getOrCrash(),
        public: event.public,
        date: event.date,
        eventSeries: event.series != null
            ? EventSeriesDto.fromDomain(event.series!)
            : null,
        description:
            event.description != null ? event.description!.getOrCrash() : null,
        todo: event.todo != null ? TodoDto.fromDomain(event.todo!) : null,
        creationDate: event.creationDate,
        owner: event.owner != null ? ProfileDto.fromDomain(event.owner!) : null,
        attendingUsersCount: event.attendingCount,
        ownStatus: domainToDtoStatus[event.status] as int?,
        longitude: event.longitude,
        address: event.address,
        latitude: event.latitude,
        distance: event.distance,
        visibleWithoutLogin: event.visibleWithoutLogin,
        invitations:
            event.invitations.map((i) => InvitationDto.fromDomain(i)).toList(),
        image: event.image);
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
        maxPersons: maxPersons,
        id: UniqueId.fromUniqueString(id),
        name: EventName(name),
        date: date,
        description:
            description == null ? null : EventDescription(description!),
        todo: todo == null ? null : todo!.toDomain(),
        owner: owner?.toDomain(),
        //TODO: don't forget this one!
        public: public,
        liked: liked,
        series: eventSeries?.toDomain(),
        creationDate: creationDate,
        attendingCount: attendingUsersCount,
        status: dtoToDomainStatus[ownStatus] as EventStatus?,
        longitude: longitude,
        latitude: latitude,
        address: address,
        visibleWithoutLogin: visibleWithoutLogin,
        invitations: invitationL,
        isHost: isHost ?? false,
        distance: distance,
        image: image);
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

class SeriesConverter
    implements JsonConverter<EventSeriesDto, Map<String, dynamic>> {
  const SeriesConverter();

  @override
  EventSeriesDto fromJson(Map<String, dynamic> series) {
    //owner["runtimeType"] = "justId";
    return EventSeriesDto.fromJson(series);
  }

  @override
  Map<String, dynamic> toJson(EventSeriesDto series) {
    return series.toJson();
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
