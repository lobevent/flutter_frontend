import 'package:dartz/dartz.dart';
import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/infrastructure/core/symfony_communicator.dart';
import 'package:flutter_frontend/infrastructure/event/event_dtos.dart';
import 'package:flutter_frontend/infrastructure/event/event_remote_service.dart';
import 'package:flutter_frontend/infrastructure/event/event_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_frontend/infrastructure/profile/profile_dtos.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:http/http.dart' as http;

class MockEvent extends Mock implements Event, http.Client {}

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

  test("connectionTest", (){
    EventDto test = EventDto(
        id: 1,
        name: "EVENT1",
        public: true,
        description: "kleines event",
        owner: ProfileDto(id: 0, name: "manfred"),
        date: DateTime.now(),
        creationDate: DateTime.now());

      final client = MockEvent();

      when(client.get("ourUrl.com/event/1"))
          .thenAnswer((_) async => http.Response(test.toJson().toString(), 200));

      EventRemoteService remoteservice
      = EventRemoteService(communicator: SymfonyCommunicator(jwt: "lalala", client: client));

      EventRepository repository = EventRepository(remoteservice, null);
      expect(repository.getSingle(Id.fromUnique(1))
          .then((value) => value.fold((l) => null, (r) => EventDto.fromDomain(r))), test);


  });



}
