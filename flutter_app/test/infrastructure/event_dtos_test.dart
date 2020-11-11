import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/domain/event/event_failure.dart';
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
  EventDto origTestDto = EventDto(
      name: "EVENT1",
      public: true,
      description: "kleines event",
      owner: ProfileDto(id: 0, name: "manfred"),
      date: DateTime.now(),
      creationDate: DateTime.now());

  final client = MockEvent();
  final SymfonyCommunicator communicator
  = SymfonyCommunicator(jwt: "lalala", client: client);

  final EventRemoteService remoteservice
  = EventRemoteService(communicator: communicator);

  EventRepository repository = EventRepository(remoteservice, null);

  test("Event Convertion", () {

    EventDto testDto =
    EventDto.fromJson(EventDto.fromDomain(origTestDto.toDomain()).toJson());
    expect(testDto, origTestDto);
  });








  group('CRUD', () {

    test("connectionTest", () async {

      when(client.get("ourUrl.com/event/1", headers: {"Authentication": "Baerer lalala"}))
          .thenAnswer((_) async => http.Response(jsonEncode(origTestDto.toJson()), 200));


      expect(await repository.getSingle(Id.fromUnique(1)).then((value) => value.fold((l) => null, (r) => EventDto.fromDomain(r))), origTestDto);
    });





    test("Post with 200 response", () async {
      const int id = 2;


      EventDto newTestDto = origTestDto.copyWith(id: id);
      when(client.post("ourUrl.com/event",  headers: {"Authentication": "Baerer lalala"}, body: jsonEncode(origTestDto.toJson()))).thenAnswer((realInvocation) async => http.Response(jsonEncode(newTestDto.toJson()), 200));

      Event answer = await repository.create(origTestDto.toDomain()).then((value) => value.fold((l) => null, (r) => r));
      expect(answer.id, id);
      expect(answer == null, false);
      expect(EventDto.fromDomain(answer), origTestDto.copyWith(id: id));

    });

    test("Post with communicaton errors", () async {
      final codesAndFailures = { 401:const EventFailure.notAuthenticated(), 403:const EventFailure.insufficientPermissions(), 404:const EventFailure.notFound(), 500:const EventFailure.internalServer()};
      codesAndFailures.forEach((key, value) async {
        when(client.post("ourUrl.com/event",  headers: {"Authentication": "Baerer lalala"}, body: jsonEncode(origTestDto.toJson()))).thenAnswer((realInvocation) async => http.Response("" ,key));
        final EventFailure answer = await repository.create(origTestDto.toDomain()).then((value) => value.fold((l) => l, (r) => null));
        expect(answer, value);
      });
    });

    }

  );

}
