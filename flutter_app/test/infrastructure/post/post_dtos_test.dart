import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_frontend/infrastructure/core/symfony_communicator.dart';
import 'package:flutter_frontend/infrastructure/event/event_dtos.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_frontend/infrastructure/profile/profile_dtos.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:flutter_frontend/domain/post/post.dart';
import 'package:flutter_frontend/infrastructure/post/post_dtos.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/infrastructure/post/post_remote_service.dart';
import 'package:flutter_frontend/infrastructure/post/post_repository.dart';
import 'package:flutter_frontend/domain/post/post.dart';
import 'package:flutter_frontend/domain/post/post_failure.dart';
import 'package:flutter_frontend/domain/post/i_post_repository.dart';
import 'package:http/http.dart' as http;

import '../profile/profile_dtos_test.dart';

class MockPost extends Mock implements Profile, http.Client {}

main() {
  const int testId = 3;

  PostDto normalPostDto1 = PostDto(
      id: testId,
      creationDate: DateTime.now(),
      postContent: "geiler post yeye 1",
      owner: ProfileDto(id: 0, name: "manni"),
      event: EventDto(
          id: 0,
          name: "corona event 1",
          public: true,
          description: "geile corona party mit 20 mann",
          date: DateTime.now(),
          creationDate: DateTime.now(),
          owner: ProfileDto(id: 1, name: "adolf")));

  PostDto normalPostDto2 = PostDto(
      id: 2,
      creationDate: DateTime.now(),
      postContent: "geiler post yeye 2",
      owner: ProfileDto(id: 0, name: "manni"),
      event: EventDto(
          id: 0,
          name: "corona event 1",
          public: false,
          description: "geile corona party mit 20 mann",
          date: DateTime.now(),
          creationDate: DateTime.now(),
          owner: ProfileDto(id: 1, name: "adolf")));

  PostDto postDtoWithoutId1 = PostDto.WithoutId(
      creationDate: DateTime.now(),
      postContent: "geiler post yeye 3",
      owner: ProfileDto(id: 0, name: "manni"),
      event: EventDto(
          id: 0,
          name: "corona event 1",
          public: true,
          description: "geile corona party mit 20 mann",
          date: DateTime.now(),
          creationDate: DateTime.now(),
          owner: ProfileDto(id: 0, name: "manni")));

  PostDto postDtoWithoutId2 = PostDto.WithoutId(
      creationDate: DateTime.now(),
      postContent: "geiler post yeye 3",
      owner: ProfileDto(id: 0, name: "manni"),
      event: EventDto(
          id: 0,
          name: "corona event 1",
          public: false,
          description: "geile corona party mit 20 mann",
          date: DateTime.now(),
          creationDate: DateTime.now(),
          owner: ProfileDto(id: 1, name: "adolf")));

  const ProfileDto profileDto = ProfileDto(id: 0, name: "manni");

  List<PostDto> postList = [
    normalPostDto1,
    normalPostDto2,
    postDtoWithoutId1,
    postDtoWithoutId2
  ];

  //initializing Client and communication Objects
  final client = MockPost();
  final SymfonyCommunicator communicator = SymfonyCommunicator(
      jwt: "lalala",
      client: client); //SymfonyCommunicator for communication mocking with fake jwt and the mocking client
  final PostRemoteService
      remoteService //we have to pass the communicator, as it has the mocked client
      = PostRemoteService(communicator:
      communicator); //remoteService for mocking in the repository
  PostRepository repository = PostRepository(remoteService);

  //some often used values

  const String jwt = "lalala";
  const Map<String, String> authenticationHeader = {
    "Authentication": "Baerer $jwt"
  };

  //HTTP error codes with corresponding eventFailures
  final codesAndFailures = {
    401: const PostFailure.notAuthenticated(),
    403: const PostFailure.insufficientPermissions(),
    404: const PostFailure.notFound(),
    500: const PostFailure.internalServer()
  };

  //getList operations with corresponding api paths
  final listOperations = {
    Operation.own: PostRemoteService.ownPostsPath,
    Operation.feed: PostRemoteService.feedPath,
    Operation.fromUser: PostRemoteService.postsFromUserPath,
  };

  //first test

  test("Post Convertion", () {
    PostDto convertedTestPostDto = PostDto.fromJson(
        PostDto.fromDomain(normalPostDto1.toDomain()).toJson());
    expect(normalPostDto1, convertedTestPostDto);
  });

  test("Post with 200 response", () async {
    when(client.post("ourUrl.com/post",
            headers: authenticationHeader,
            body: jsonEncode(postDtoWithoutId1.toJson())))
        .thenAnswer((realInvocation) async =>
            http.Response(jsonEncode(normalPostDto1.toJson()), 200));

    Post answer =
    await repository
        .create(postDtoWithoutId1.toDomain())
        .then((value) => value.fold((l) => throw Error(), (r) => r));
    expect(
        answer.maybeMap((value) => value.id.getOrCrash(), orElse: () => null),
        testId);
    expect(answer = null, false);
    expect(PostDto.fromDomain(answer), normalPostDto1);
  });

  test("Delete with 200 response", () async {
    when(client.delete(
            SymfonyCommunicator.url +
                PostRemoteService.deletePath +
                testId.toString(),
            headers: authenticationHeader))
        .thenAnswer((realInvocation) async =>
            http.Response(jsonEncode(postDtoWithoutId1.toJson()), 200));
    Post answer = await repository
        .delete(postDtoWithoutId1.toDomain())
        .then((value) => value.fold((l) => null, (r) => r));
    expect(
        answer.maybeMap((value) => value.id.getOrCrash(), orElse: () => null),
        testId);
    expect(answer == null, false);
    expect(PostDto.fromDomain(answer), postDtoWithoutId1);
  });

  test("Delete with wrong postdto type (without id)", () async {
    when(client.delete(
            SymfonyCommunicator.url +
                PostRemoteService.deletePath +
                testId.toString(),
            headers: authenticationHeader))
        .thenAnswer((realInvocation) async => http.Response("", 200));
    final Either<PostFailure, Post> answer = await repository
        .delete(postDtoWithoutId1.toDomain()); //await answer from repository
    final PostFailure failure = answer.swap().getOrElse(() =>
        throw Error()); //swap, so we can use get or else, and throw an error if its not an failure
    expect(failure, const PostFailure.unexpected());
  });

  //---------------------UPDATE----------------------
  test("Put with 200 response", () async {
    when(client.put(
            SymfonyCommunicator.url +
                PostRemoteService.updatePath +
                testId.toString(),
            headers: authenticationHeader,
            body: jsonEncode(postDtoWithoutId1.toJson())))
        .thenAnswer((realInvocation) async =>
            http.Response(jsonEncode(postDtoWithoutId1.toJson()), 200));

    Post answer = await repository
        .update(postDtoWithoutId1.toDomain())
        .then((value) => value.fold((l) => null, (r) => r));
    expect(
        answer.maybeMap((value) => value.id.getOrCrash(), orElse: () => null),
        testId);
    expect(answer == null, false);
    expect(PostDto.fromDomain(answer), normalPostDto1);
  });

  //-------autogenerated on Http error codes -----------------
  ///Test crud methods and reaction to the statuscodes
  ///the tests are generated based on the error codes and the associated errors
  codesAndFailures.forEach((code, pstFailure) {
    //Autogenerated tests for the different failures in post
    test("Post with communicaton errors. Code: $code", () async {
      //tests for posts
      when(client.post(SymfonyCommunicator.url + PostRemoteService.postPath,
              headers: authenticationHeader,
              body: jsonEncode(postDtoWithoutId1.toJson())))
          .thenAnswer((realInvocation) async => http.Response("", code));
      final PostFailure answer = await repository
          .create(postDtoWithoutId1.toDomain())
          .then((value) => value.fold((l) => l, (r) => null));
      expect(answer, pstFailure);
    });

    test("Delete with communication errors. Code: $code", () async {
      //Autogenerated tests for the different failures in delete
      when(client.delete(
              SymfonyCommunicator.url +
                  PostRemoteService.deletePath +
                  testId.toString(),
              headers: authenticationHeader))
          .thenAnswer((realInvocation) async => http.Response("", code));
      final Either<PostFailure, Post> answer = await repository
          .delete(postDtoWithoutId1.toDomain()); //await answer from repository
      final PostFailure failure = answer.swap().getOrElse(() =>
          throw Error()); //swap, so we can use get or else, and throw an error if its not an failure
      expect(failure, pstFailure);
    });

    test("Put with communication Errors. Code: $code", () async {
      when(client.put(
              SymfonyCommunicator.url +
                  PostRemoteService.updatePath +
                  testId.toString(),
              headers: authenticationHeader,
              body: jsonEncode(postDtoWithoutId1.toJson())))
          .thenAnswer((realInvocation) async => http.Response("", code));
      PostFailure failure = await repository
          .update(postDtoWithoutId1.toDomain())
          .then((value) => value.swap().getOrElse(() => throw Error()));
      expect(failure, pstFailure);
    });

    ///Test for the failures in the get listCalls
    listOperations.forEach((operation, path) {
      test(
          "getList with communication Errors. Operation: $operation. Code: $code",
          () async {
        PostFailure returnedFailure;
        when(client.get(SymfonyCommunicator.url + path,
                headers: authenticationHeader))
            .thenAnswer((_) async => http.Response(
                jsonEncode(postList.map((e) => e.toJson()).toList()), code));
        if (operation == Operation.fromUser) {
          returnedFailure = await repository
              .getList(operation, profile: profileDto.toDomain())
              .then((value) => value.swap().getOrElse(() => throw Error()));
        } else {
          returnedFailure = await repository
              .getList(operation)
              .then((value) => value.swap().getOrElse(() => throw Error()));
        }
        expect(returnedFailure, pstFailure);
      });
    });
  });
}
