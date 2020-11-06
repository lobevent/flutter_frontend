import 'package:dartz/dartz.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/infrastructure/event/event_dtos.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_frontend/infrastructure/profile/profile_dtos.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';

class MockEvent extends Mock implements Event {}

main() {

  test("Event Convertion", () {
    EventDto test = EventDto(
        id: 1,
        name: "EVENT1",
        public: true,
        description: "kleines event",
        owner: ProfileDto(id: 0, name: "manfred"),
        date: DateTime.now(),
        creationDate: DateTime.now());
    EventDto testDto =
    EventDto.fromJson(EventDto.fromDomain(test.toDomain()).toJson());
    expect(testDto, test);
  });

}
