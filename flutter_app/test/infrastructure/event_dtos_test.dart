import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/domain/event/event_failure.dart';
import 'package:flutter_frontend/domain/event/i_event_repository.dart';
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

  EventDto origTestDto1 = EventDto(
      id: 3,
      name: "EVENT2",
      public: true,
      description: "toni stinkt",
      owner: ProfileDto(id: 0, name: "manfred"),
      date: DateTime.now(),
      creationDate: DateTime.now());

  EventDto origTestDto2 = EventDto(
      id: 4,
      name: "EVENT3",
      public: true,
      description: "tom stinkt",
      owner: ProfileDto(id: 0, name: "manfred"),
      date: DateTime.now(),
      creationDate: DateTime.now());

  EventDto origTestDto3 = EventDto(
      id: 5,
      name: "EVENT5",
      public: false,
      description: "tom stinkt sehr",
      owner: ProfileDto(id: 0, name: "manfred"),
      date: DateTime.now(),
      creationDate: DateTime.now());

  const ProfileDto profileDto = ProfileDto(id: 0, name: "manfred");

  List<EventDto> evnentList = [origTestDto1, origTestDto2, origTestDto3]; //used for list tests


  //initializing often used objects
  final client = MockEvent();
  final SymfonyCommunicator communicator
  = SymfonyCommunicator(jwt: "lalala", client: client);

  final EventRemoteService remoteservice
  = EventRemoteService(communicator: communicator);

  EventRepository repository = EventRepository(remoteservice, null);


  //first test
  test("Event Convertion", () {

    EventDto testDto =
    EventDto.fromJson(EventDto.fromDomain(origTestDto.toDomain()).toJson());
    expect(testDto, origTestDto);
  });








  //testing crud operations here
  group('CRUD', () {

    test("get Single Test", () async {

      when(client.get("ourUrl.com/event/1", headers: {"Authentication": "Baerer lalala"}))
          .thenAnswer((_) async => http.Response(jsonEncode(origTestDto.toJson()), 200));


      expect(await repository.getSingle(Id.fromUnique(1)).then((value) => value.fold((l) => null, (r) => EventDto.fromDomain(r))), origTestDto);
    });

    //testing list chain and convertion
    final listOptions = {
      Operation.attending:EventRemoteService.attendingEventsPath,
      Operation.fromUser:EventRemoteService.profileEventPath,
      Operation.owned:EventRemoteService.ownedEventsPath,
      Operation.unreacted:EventRemoteService.unreactedEventsPath
    }; //instantiating map with different operation options
    listOptions.forEach((operation, path) async{ // generate testcases for different operations
      test("get List Test with 200 response. Operation: $operation", () async {

          Either<EventFailure, List<Event>> returnedList;
          List<Map<String, dynamic>> jsonList = evnentList.map((e) => e.toJson()).toList();
          when(client.get(SymfonyCommunicator.url + path, headers: {"Authentication": "Baerer lalala"}))
              .thenAnswer((_) async => http.Response(jsonEncode(jsonList), 200));
          if(operation == Operation.fromUser){
            returnedList = await repository.getList(operation, profile: profileDto.toDomain());
          }else{
            returnedList = await repository.getList(operation);
          }
          expect(returnedList.fold((l) => null, (r) => r.map((e) => EventDto.fromDomain(e)).toList()), evnentList);
        });

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


    test("Delete with 200 response", () async {
      const int id = 2;


      EventDto newTestDto = origTestDto.copyWith(id: id);
      when(client.delete(SymfonyCommunicator.url + EventRemoteService.deletePath + id.toString(),  headers: {"Authentication": "Baerer lalala"})).thenAnswer((realInvocation) async => http.Response(jsonEncode(newTestDto.toJson()), 200));
      Event answer = await repository.delete(newTestDto.toDomain()).then((value) => value.fold((l) => null, (r) => r));
      expect(answer.id, id);
      expect(answer == null, false);
      expect(EventDto.fromDomain(answer), origTestDto.copyWith(id: id));
    });

    test("Put with 200 response", () async {
      const int id = 2;


      EventDto newTestDto = origTestDto.copyWith(id: id);
      when(client.put(SymfonyCommunicator.url + EventRemoteService.deletePath + id.toString(),  headers: {"Authentication": "Baerer lalala"}, body: jsonEncode(newTestDto.toJson()))).thenAnswer((realInvocation) async => http.Response(jsonEncode(newTestDto.toJson()), 200));

      Event answer = await repository.update(newTestDto.toDomain()).then((value) => value.fold((l) => null, (r) => r));
      expect(answer.id, id);
      expect(answer == null, false);
      expect(EventDto.fromDomain(answer), origTestDto.copyWith(id: id));
    });

    final codesAndFailures = { 401:const EventFailure.notAuthenticated(), 403:const EventFailure.insufficientPermissions(), 404:const EventFailure.notFound(), 500:const EventFailure.internalServer()};
    codesAndFailures.forEach((key, value) async { //Autogenerated tests for the different failures
      test("Post with communicaton errors. Code: $key", () async {
          when(client.post(SymfonyCommunicator.url + EventRemoteService.postPath,  headers: {"Authentication": "Baerer lalala"}, body: jsonEncode(origTestDto.toJson()))).thenAnswer((realInvocation) async => http.Response("" ,key));
          final EventFailure answer = await repository.create(origTestDto.toDomain()).then((value) => value.fold((l) => l, (r) => null));
          expect(answer, value);
        });
    });

    }

  );

}
