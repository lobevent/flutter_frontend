// import 'dart:convert';
//
// import 'package:dartz/dartz.dart';
// import 'package:flutter_frontend/domain/core/value_objects.dart';
// import 'package:flutter_frontend/domain/profile/profile_failure.dart';
// import 'package:flutter_frontend/infrastructure/core/json_converters.dart';
// import 'package:flutter_frontend/infrastructure/core/symfony_communicator.dart';
// import 'package:flutter_frontend/infrastructure/event/event_dtos.dart';
// import 'package:flutter_frontend/infrastructure/post/post_dtos.dart';
// import 'package:flutter_frontend/infrastructure/post/post_repository.dart';
// import 'package:flutter_frontend/infrastructure/profile/profile_remote_service.dart';
// import 'package:flutter_frontend/infrastructure/profile/profile_repository.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mockito/mockito.dart';
// import 'package:flutter_frontend/infrastructure/profile/profile_dtos.dart';
// import 'package:flutter_frontend/domain/profile/profile.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter_frontend/infrastructure/core/json_converters.dart';
// import 'package:flutter_frontend/domain/profile/i_profile_repository.dart';
// import 'package:flutter_frontend/infrastructure/core/interpolation.dart';
// import 'package:flutter_frontend/domain/post/post.dart';
//
// class MockProfile extends Mock implements Profile, http.Client {}
//
// main() {
//   const int testId = 3;
//
//   ProfileDto testProfileDto = ProfileDto(id: testId, name: "hans");
//
//   ProfileDto testProfileDtoWithoutId = ProfileDto(id: 3, name: "hans");
//
//   PostDto normalPostDto2 = PostDto(
//       id: 2,
//       creationDate: DateTime.now(),
//       postContent: "geiler post yeye 2",
//       owner: ProfileDto(id: 0, name: "manni"),
//       event: EventDto(
//           id: 0,
//           name: "corona event 1",
//           public: false,
//           description: "geile corona party mit 20 mann",
//           date: DateTime.now(),
//           creationDate: DateTime.now(),
//           owner: ProfileDto(id: 1, name: "adolf")));
//
//
//   List<ProfileDto> profileDtoList = [testProfileDto,testProfileDtoWithoutId];
//
//   test("Profile Convertion", ()
//   {
//     ProfileDto testProfileDto = ProfileDto(id: 1,name: "manfred");
//     ProfileDto convertedProfileDto = ProfileDto.fromJson(ProfileDto.fromDomain(testProfileDto.toDomain()).toJson());
//     expect(testProfileDto, convertedProfileDto);
//   });
//
//   //initializing Client and communication Objects
//   final client = MockProfile();
//   final SymfonyCommunicator communicator = SymfonyCommunicator(
//       jwt: "lalala",
//       client:
//       client); //SymfonyCommunicator for communication mocking with fake jwt and the mocking client
//   final ProfileRemoteService
//   remoteService //we have to pass the communicator, as it has the mocked client
//   = ProfileRemoteService(
//       communicator:
//       communicator); //remoteService for mocking in the repository
//   ProfileRepository repository = ProfileRepository(remoteService);
//
//   //some often used values
//
//   const String jwt = "lalala";
//   const Map<String, String> authenticationHeader = {
//     "Authentication": "Baerer $jwt"
//   };
//
//   const int amount = 5;
//   final DateTime lastCommentTime = DateTime.now();
//   final String profileId = testProfileDto.id.toString();
//   final String postId = "2";
//
//
//
//   //HTTP error codes with corresponding eventFailures
//   final codesAndFailures = {
//     401: const ProfileFailure.notAuthenticated(),
//     403: const ProfileFailure.insufficientPermissions(),
//     404: const ProfileFailure.notFound(),
//     500: const ProfileFailure.internalServer()
//   };
//   //getList operations with corresponding api paths
//   /*search,
//   attendingUsersEvent,
//   follower,
//   postProfile,
//    */
//   final listOperations = {
//     Operation.search: ProfileRemoteService.searchProfilePath.interpolate(
//         {"profileId": profileId,"amount" : amount.toString(), "lastCommentTime" : lastCommentTime.toString()}),
//     Operation.attendingUsersEvent: ProfileRemoteService.attendingUsersPath.interpolate(
//         {"profileId": profileId,"amount" : amount.toString(), "lastCommentTime" : lastCommentTime.toString()}),
//     Operation.follower: ProfileRemoteService.followerPath.interpolate(
//         {"profileId": profileId, "amount" : amount.toString(), "lastCommentTime" : lastCommentTime.toString()}),
//     Operation.postProfile: ProfileRemoteService.postProfilePath.interpolate(
//         {"amount" : amount.toString(), "lastCommentTime" : lastCommentTime.toString()}),
//   };
//
//   //first test
//   test("Post Convertion", () {
//     ProfileDto convertedTestProfileDto = ProfileDto.fromJson(
//         ProfileDto.fromDomain(testProfileDto.toDomain()).toJson());
//     expect(testProfileDto, convertedTestProfileDto);
//   });
//
//   //test  CRUD HERE
//   group('CRUD', () {
//     test("get Single Test", () async {
//       when(client.get("ourUrl.com/profile", headers: authenticationHeader))
//           .thenAnswer((_) async =>
//           http.Response(jsonEncode(testProfileDto.toJson()), 200));
//
//       expect(
//           await repository.getSingleProfile(UniqueId.fromUniqueString(1)).then(
//                   (value) => value.fold((l) => null, (r) => ProfileDto.fromDomain(r))),
//           testProfileDto);
//     });
//
//     //testing list chain and convertion
//     listOperations.forEach((operation, path) async {
//       // generate testcases for different operations
//       test("get List Test with 200 response. Operation: $operation", () async {
//         Either<ProfileFailure, List<Profile>> returnedList;
//         when(client.get(SymfonyCommunicator.url + path,
//             headers: authenticationHeader))
//             .thenAnswer((_) async => http.Response(
//             jsonEncode(profileDtoList.map((e) => e.toJson()).toList()),
//             200)); // client response configuration
//         expect(
//             returnedList
//                 .getOrElse(() => throw Error())
//                 .map((e) => ProfileDto.fromDomain(e))
//                 .toList(),
//             profileDtoList);
//       });
//     });
//     test("Post with 200 response", () async {
//       when(client.post("ourUrl.com/profile",
//           headers: authenticationHeader,
//           body: jsonEncode(testProfileDto.toJson())))
//           .thenAnswer((realInvocation) async =>
//           http.Response(jsonEncode(testProfileDto.toJson()), 200));
//
//       Profile answer = await repository
//           .create(testProfileDto.toDomain())
//           .then((value) => value.fold((l) => throw Error(), (r) => r));
//       expect(
//           answer.maybeMap((value) => value.id.getOrCrash(), orElse: () => null),
//           testId);
//       expect(answer == null, false);
//       expect(ProfileDto.fromDomain(answer), testProfileDto);
//     });
//
//     test("Delete with 200 response", () async {
//       when(client.delete(
//           SymfonyCommunicator.url +
//               ProfileRemoteService.deletePath +
//               testId.toString(),
//           headers: authenticationHeader))
//           .thenAnswer((realInvocation) async =>
//           http.Response(jsonEncode(testProfileDto.toJson()), 200));
//       Profile answer = await repository
//           .delete(testProfileDto.toDomain())
//           .then((value) => value.fold((l) => null, (r) => r));
//       expect(
//           answer.maybeMap((value) => value.id.getOrCrash(), orElse: () => null),
//           testId);
//       expect(answer == null, false);
//       expect(ProfileDto.fromDomain(answer), testProfileDto);
//     });
//
//
//     //---------------------UPDATE----------------------
//     test("Put with 200 response", () async {
//       when(client.put(
//           SymfonyCommunicator.url +
//               ProfileRemoteService.updatePath +
//               testId.toString(),
//           headers: authenticationHeader,
//           body: jsonEncode(testProfileDto.toJson())))
//           .thenAnswer((realInvocation) async =>
//           http.Response(jsonEncode(testProfileDto.toJson()), 200));
//
//       Profile answer = await repository
//           .update(testProfileDto.toDomain())
//           .then((value) => value.fold((l) => null, (r) => r));
//       expect(
//           answer.maybeMap((value) => value.id.getOrCrash(), orElse: () => null),
//           testId);
//       expect(answer == null, false);
//       expect(ProfileDto.fromDomain(answer), testProfileDto);
//     });
//
//     //-------autogenerated on Http error codes -----------------
//     ///Test crud methods and reaction to the statuscodes
//     ///the tests are generated based on the error codes and the associated errors
//     codesAndFailures.forEach((code, pstFailure) {
//       //Autogenerated tests for the different failures in post
//       test("Post with communicaton errors. Code: $code", () async {
//         //tests for posts
//         when(client.post(SymfonyCommunicator.url + ProfileRemoteService.postPath,
//             headers: authenticationHeader,
//             body: jsonEncode(testProfileDtoWithoutId.toJson())))
//             .thenAnswer((realInvocation) async => http.Response("", code));
//         final ProfileFailure answer = await repository
//             .create(testProfileDtoWithoutId.toDomain())
//             .then((value) => value.fold((l) => l, (r) => null));
//         expect(answer, pstFailure);
//       });
//
//       test("Delete with communication errors. Code: $code", () async {
//         //Autogenerated tests for the different failures in delete
//         when(client.delete(
//             SymfonyCommunicator.url +
//                 ProfileRemoteService.deletePath +
//                 testId.toString(),
//             headers: authenticationHeader))
//             .thenAnswer((realInvocation) async => http.Response("", code));
//         final Either<ProfileFailure, Profile> answer = await repository
//             .delete(testProfileDto.toDomain()); //await answer from repository
//         final ProfileFailure failure = answer.swap().getOrElse(() =>
//         throw Error()); //swap, so we can use get or else, and throw an error if its not an failure
//         expect(failure, pstFailure);
//       });
//
//       test("Put with communication Errors. Code: $code", () async {
//         when(client.put(
//             SymfonyCommunicator.url +
//                 ProfileRemoteService.updatePath +
//                 testId.toString(),
//             headers: authenticationHeader,
//             body: jsonEncode(testProfileDtoWithoutId.toJson())))
//             .thenAnswer((realInvocation) async => http.Response("", code));
//         ProfileFailure failure = await repository
//             .update(testProfileDtoWithoutId.toDomain())
//             .then((value) => value.swap().getOrElse(() => throw Error()));
//         expect(failure, pstFailure);
//       });
//
//       ///Test for the failures in the get listCalls
//       listOperations.forEach((operation, path) {
//         test(
//             "getList with communication Errors. Operation: $operation. Code: $code",
//                 () async {
//               ProfileFailure returnedFailure;
//               when(client.get(SymfonyCommunicator.url + path,
//                   headers: authenticationHeader))
//                   .thenAnswer((_) async => http.Response(
//                   jsonEncode(profileDtoList.map((e) => e.toJson()).toList()), code));
//                 returnedFailure = await repository
//                     .getList(operation, amount)
//                     .then((value) => value.swap().getOrElse(() => throw Error()));
//               expect(returnedFailure, pstFailure);
//             });
//       });
//     });
//   });
// }
//
//
