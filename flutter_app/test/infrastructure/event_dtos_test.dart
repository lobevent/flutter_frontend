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
import 'package:mockito/mockito.dart';
import 'package:flutter_frontend/infrastructure/profile/profile_dtos.dart';
import 'package:http/http.dart' as http;

class MockEvent extends Mock implements Event, http.Client {}

main() {
  const int testId = 2;


  EventDto origTestDtoWithoutId = EventDto.withoutId(
      name: "EVENT1",
      public: true,
      description: "kleines event",
      owner: ProfileDto(id: 0, name: "manfred"),
      date: DateTime.now(),
      creationDate: DateTime.now());

  EventDto TestDtoWithId = EventDto(
      id: testId,
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

  List<EventDto> evnentList = [TestDtoWithId, origTestDto2, origTestDto3]; //used for list tests


  //initializing Client and communication Objects
  final client = MockEvent();
  final SymfonyCommunicator communicator
  = SymfonyCommunicator(jwt: "lalala", client: client); //SymfonyCommunicator for communication mocking with fake jwt and the mocking client
  final EventRemoteService remoteservice //we have to pass the communicator, as it has the mocked client
  = EventRemoteService(communicator: communicator); //remoteService for mocking in the repository
  EventRepository repository = EventRepository(remoteservice, null);


  //some often used values

  const String jwt = "lalala";
  const Map<String, String> authenticationHeader = {"Authentication": "Baerer $jwt"};

  //HTTP error codes with corresponding eventFailures
  final codesAndFailures = {
    401:const EventFailure.notAuthenticated(),
    403:const EventFailure.insufficientPermissions(),
    404:const EventFailure.notFound(),
    500:const EventFailure.internalServer()};

  //getList operations with corresponding api paths
  final listOperations = {
    Operation.attending:EventRemoteService.attendingEventsPath,
    Operation.fromUser:EventRemoteService.profileEventPath,
    Operation.owned:EventRemoteService.ownedEventsPath,
    Operation.unreacted:EventRemoteService.unreactedEventsPath
  }; //instantiating map with different operation options



  //first test
  test("Event Convertion", () {

    EventDto testDto =
    EventDto.fromJson(EventDto.fromDomain(origTestDtoWithoutId.toDomain()).toJson());
    expect(testDto, origTestDtoWithoutId);
  });








  //testing crud operations here
  group('CRUD', () {

    test("get Single Test", () async {

      when(client.get("ourUrl.com/event/1", headers: authenticationHeader))
          .thenAnswer((_) async => http.Response(jsonEncode(origTestDtoWithoutId.toJson()), 200));


      expect(await repository.getSingle(Id.fromUnique(1)).then((value) => value.fold((l) => null, (r) => EventDto.fromDomain(r))), origTestDtoWithoutId);
    });

    //testing list chain and convertion
    listOperations.forEach((operation, path) async{ // generate testcases for different operations
      test("get List Test with 200 response. Operation: $operation", () async {

          Either<EventFailure, List<Event>> returnedList;
          when(client.get(SymfonyCommunicator.url + path, headers: authenticationHeader))
              .thenAnswer((_) async => http.Response(jsonEncode(evnentList.map((e) => e.toJson()).toList()), 200)); // client response configuration
          if(operation == Operation.fromUser){
            returnedList = await repository.getList(operation, profile: profileDto.toDomain()); //the case, when profile must be passed
          }else{
            returnedList = await repository.getList(operation);
          }
          expect(returnedList.getOrElse(() => throw Error()).map((e) => EventDto.fromDomain(e)).toList(), evnentList);
        });

    });


    test("Post with 200 response", () async { //std post with 200 response

      when(client.post("ourUrl.com/event",  headers: authenticationHeader, body: jsonEncode(origTestDtoWithoutId.toJson()))).thenAnswer((realInvocation) async => http.Response(jsonEncode(TestDtoWithId.toJson()), 200));

      Event answer = await repository.create(origTestDtoWithoutId.toDomain()).then((value) => value.fold((l) => throw Error(), (r) => r));
      expect(answer.maybeMap((value) => value.id.getOrCrash(), orElse: () => null), testId);
      expect(answer == null, false);
      expect(EventDto.fromDomain(answer), TestDtoWithId);
    });


    test("Delete with 200 response", () async {

      when(
          client.delete(
              SymfonyCommunicator.url + EventRemoteService.deletePath + testId.toString(),
              headers: authenticationHeader))
          .thenAnswer((realInvocation) async => http.Response(jsonEncode(TestDtoWithId.toJson()), 200));
      Event answer = await repository.delete(
          TestDtoWithId.toDomain())
          .then((value) => value.fold((l) => null, (r) => r));
      expect(answer.maybeMap((value) => value.id.getOrCrash(), orElse: () => null), testId);
      expect(answer == null, false);
      expect(EventDto.fromDomain(answer), TestDtoWithId);
    });


    test("Delete with wrong eventdto type (without id)", () async {

      when(
          client.delete(
              SymfonyCommunicator.url + EventRemoteService.deletePath + testId.toString(),
              headers: authenticationHeader))
          .thenAnswer((realInvocation) async => http.Response("", 200));
      final Either<EventFailure, Event> answer = await repository.delete(origTestDtoWithoutId.toDomain()); //await answer from repository
      final EventFailure failure = answer.swap().getOrElse(() => throw Error()); //swap, so we can use get or else, and throw an error if its not an failure
      expect(failure, const EventFailure.unexpected());
    });

    test("Put with wrong eventdto type (without id)", () async {

      when(
          client.put(
              SymfonyCommunicator.url + EventRemoteService.updatePath + testId.toString(),
              headers: authenticationHeader,
              body: jsonEncode(TestDtoWithId.toJson())))
          .thenAnswer((realInvocation) async => http.Response("", 200));
      EventFailure failure = await repository.update(origTestDtoWithoutId.toDomain())
          .then((value) => value.swap().getOrElse(() => throw Error()));
      expect(failure, const EventFailure.unexpected());
    });
    //---------------------UPDATE----------------------
    test("Put with 200 response", () async {
      when(
          client.put(
              SymfonyCommunicator.url + EventRemoteService.updatePath + testId.toString(),
              headers: authenticationHeader,
              body: jsonEncode(TestDtoWithId.toJson())))
          .thenAnswer((realInvocation) async => http.Response(jsonEncode(TestDtoWithId.toJson()), 200));

      Event answer = await repository.update(TestDtoWithId.toDomain())
          .then((value) => value.fold((l) => null, (r) => r));
      expect(answer.maybeMap((value) => value.id.getOrCrash(), orElse:() => null), testId);
      expect(answer == null, false);
      expect(EventDto.fromDomain(answer), TestDtoWithId);
    });

    //-------autogenerated on Http error codes -----------------
    ///Test crud methods and reaction to the statuscodes
    ///the tests are generated based on the error codes and the associated errors
    codesAndFailures.forEach((code, evFailure) { //Autogenerated tests for the different failures in post
      test("Post with communicaton errors. Code: $code", () async { //tests for posts
          when(client.post(SymfonyCommunicator.url + EventRemoteService.postPath,  headers: authenticationHeader, body: jsonEncode(origTestDtoWithoutId.toJson()))).thenAnswer((realInvocation) async => http.Response("" ,code));
          final EventFailure answer = await repository.create(origTestDtoWithoutId.toDomain()).then((value) => value.fold((l) => l, (r) => null));
          expect(answer, evFailure);
        });

      test("Delete with communication errors. Code: $code", () async { //Autogenerated tests for the different failures in delete
        when(
            client.delete(
                SymfonyCommunicator.url + EventRemoteService.deletePath + testId.toString(),
                headers: authenticationHeader))
            .thenAnswer((realInvocation) async => http.Response("", code));
        final Either<EventFailure, Event> answer = await repository.delete(TestDtoWithId.toDomain()); //await answer from repository
        final EventFailure failure = answer.swap().getOrElse(() => throw Error()); //swap, so we can use get or else, and throw an error if its not an failure
        expect(failure, evFailure);
      });
      test("Put with communication Errors. Code: $code", () async {
        when(
            client.put(
                SymfonyCommunicator.url + EventRemoteService.updatePath + testId.toString(),
                headers: authenticationHeader,
                body: jsonEncode(TestDtoWithId.toJson())))
            .thenAnswer((realInvocation) async => http.Response("", code));
        EventFailure failure = await repository.update(TestDtoWithId.toDomain())
            .then((value) => value.swap().getOrElse(() => throw Error()));
        expect(failure, evFailure);
      });

      ///Test for the failures in the get listCalls
      listOperations.forEach((operation, path) {
        test("getList with communication Errors. Operation: $operation. Code: $code", () async{
          EventFailure returnedFailure;
          when(client.get(SymfonyCommunicator.url + path, headers: authenticationHeader))
              .thenAnswer((_) async => http.Response(jsonEncode(evnentList.map((e) => e.toJson()).toList()), code));
          if(operation == Operation.fromUser){
            returnedFailure = await repository.getList(operation, profile: profileDto.toDomain()).then((value) => value.swap().getOrElse(() => throw Error()));
          }else{
            returnedFailure = await repository.getList(operation).then((value) => value.swap().getOrElse(() => throw Error()));
          }
          expect(returnedFailure, evFailure);
        });
      });
    });

    }

  );

}
