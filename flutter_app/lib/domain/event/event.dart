import 'package:dartz/dartz.dart';
import 'package:flutter_frontend/domain/core/failures.dart';
import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/domain/event/event_series.dart';
import 'package:flutter_frontend/domain/event/invitation.dart';
import 'package:flutter_frontend/domain/event/value_objects.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:flutter_frontend/domain/profile/value_objects.dart';
import 'package:flutter_frontend/domain/todo/todo.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:image_picker/image_picker.dart';

part 'event.freezed.dart';

enum EventStatus {
  attending,
  notAttending,
  interested,
  invited,
  confirmAttending
}

@freezed
class Event with _$Event {
  const Event._();

  const factory Event(
      {required UniqueId id,
      required EventName name,
      required DateTime date,
      int? maxPersons,
      EventDescription? description,
      required DateTime creationDate,
      Todo? todo,
      Profile? owner,
      EventSeries? series,
      required bool public,
      required bool visibleWithoutLogin,
      required List<Invitation> invitations,
      bool? liked,
      int? attendingCount,
      EventStatus? status,
      double? longitude,
      String? Adress,
      double? latitude,
      required bool isHost,
      String? image}) = EventFull;

  factory Event.empty() => Event(
      id: UniqueId.fromUniqueString(
          'e6837df8-9e99-4f00-a40d-0e798834e9da'), // TODO: Random initial id?
      name: EventName(''),
      date: DateTime.now(),
      description: EventDescription(''),
      //todo: Todo(id: UniqueId.fromUniqueString('e6837df8-9e99-4f00-a40d-0e798834e9da'),items: [],name: TodoName('lool'), ),
      creationDate: DateTime.now(),
      owner: Profile(
          id: UniqueId(),
          name: ProfileName(
              "ssss")), //TODO: !!!!!!!IIIIIIMMMMMMMMPPPPPPOOOOORTANT!!!!!!!! Implement logged in profile fetching
      public: false,
      attendingCount: 0,
      status: EventStatus.attending,
      visibleWithoutLogin: false,
      isHost: false,
      invitations: <Invitation>[]);

  //check if the whole object is no failure
  // TODO I would go with Either<ValueFailure<dynamic>, Unit> since Option indicates that a value is ready to use or absent. But in this case there is always some kind of value even if it's just a value that indicates a failure
  Option<ValueFailure<dynamic>> get failureOption {
    return name.failureOrUnit.fold(
      (f) => some(f),
      (_) => none(),
    );
  }
}
