import 'dart:convert';

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
  EventDto origTestDto = EventDto(
      id: 1,
      name: "EVENT1",
      public: true,
      description: "kleines event",
      owner: ProfileDto(id: 0, name: "manfred"),
      date: DateTime.now(),
      creationDate: DateTime.now());


  test("Event Convertion", () {

    EventDto testDto =
    EventDto.fromJson(EventDto.fromDomain(origTestDto.toDomain()).toJson());
    expect(testDto, origTestDto);
  });

  test("connectionTest", () async {

      final client = MockEvent();

      when(client.get("ourUrl.com/event/1", headers: {"Authentication": "Baerer lalala"}))
          .thenAnswer((_) async => http.Response(jsonEncode(origTestDto.toJson()), 200));

      SymfonyCommunicator communicator
      = SymfonyCommunicator(jwt: "lalala", client: client);

      EventRemoteService remoteservice
      = EventRemoteService(communicator: communicator);

      EventRepository repository = EventRepository(remoteservice, null);
      expect(await repository.getSingle(Id.fromUnique(1)).then((value) => value.fold((l) => null, (r) => EventDto.fromDomain(r))), origTestDto);
  });




  test("connectionTestPost", () async {

    final client = MockEvent();

    print(jsonEncode(origTestDto.toJson()));
    when(client.post("ourUrl.com/event",  headers: {"Authentication": "Baerer lalala"}, body: origTestDto.toJson())).thenAnswer((realInvocation) async => http.Response("1", 200));
    //whenObject.thenAnswer((_) async =>  http.Response("1", 200));


    SymfonyCommunicator communicator
    = SymfonyCommunicator(jwt: "lalala", client: client);

    EventRemoteService remoteservice
    = EventRemoteService(communicator: communicator);

    EventRepository repository = EventRepository(remoteservice, null);

    expect(await repository.create(origTestDto.toDomain()).then((value) => value.fold((l) => null, (r) => Unit)), origTestDto); //TODO: get body from postfunction

  });


}
