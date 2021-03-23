// import 'dart:convert';
//
// import 'package:dartz/dartz.dart';
// import 'package:flutter_frontend/domain/profile/profile.dart';
// import 'package:flutter_frontend/domain/profile/value_objects.dart';
// import 'package:flutter_frontend/infrastructure/core/exceptions.dart';
// import 'package:flutter_frontend/infrastructure/post/comment_remote_service.dart';
// import 'package:flutter_frontend/infrastructure/post/post_dtos.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mockito/mockito.dart';
// import 'package:flutter_frontend/infrastructure/profile/profile_dtos.dart';
// import 'package:flutter_frontend/infrastructure/post/comment_dtos.dart';
// import 'package:flutter_frontend/infrastructure/core/symfony_communicator.dart';
// import 'package:flutter_frontend/infrastructure/post/comment_repository.dart';
// import 'package:flutter_frontend/domain/post/i_comment_repository.dart';
// import 'package:flutter_frontend/domain/core/value_objects.dart';
// import 'package:flutter_frontend/domain/post/comment_failure.dart';
// import 'package:flutter_frontend/domain/post/comment.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter_frontend/infrastructure/core/interpolation.dart';
//
// class MockComment extends Mock implements CommentDto, http.Client {}
//
// main() {
//   const int testId = 1;
//   CommentDto x = CommentDto.parent(id: 1);
//
//   CommentDto testCommentDtoParent = CommentDto(
//       id: testId,
//       commentContent: "eins guter Kommentar",
//       creationDate: DateTime.now(),
//       profile: ProfileDto(id: 1, name: "manfred"),
//       commentParent: left(x),
//       post: 1,
//       commentChildren: null);
//
//   CommentDto testCommentDto = CommentDto(
//       id: testId,
//       commentContent: "eins guter Kommentar",
//       creationDate: DateTime.now(),
//       profile: ProfileDto(id: 1, name: "manfred"),
//       commentParent: left(x),
//       post: 1,
//       commentChildren: null);
//
//   CommentDto testCommentDto2 = CommentDto(
//       id: testId,
//       commentContent: "zweins guter Kommentar",
//       creationDate: DateTime.now(),
//       profile: ProfileDto(id: 1, name: "manfred"),
//       commentParent: left(x),
//       post: 1,
//       commentChildren: null);
//
//   CommentDto testCommentDtoWithoutId = CommentDto.WithoutId(
//       commentContent: "dreins guter Kommentar",
//       creationDate: DateTime.now(),
//       profile: ProfileDto(id: 1, name: "manfred"),
//       commentParent: left(x),
//       post: 1,
//       commentChildren: null);
//
//   const ProfileDto profileDto = ProfileDto(id: 0, name: "manni");
//
//   List<CommentDto> commentList = [
//     testCommentDto,
//     testCommentDto2,
//     testCommentDtoWithoutId
//   ];
//
//   //initializing Client and communication Objects
//   final client = MockComment();
//   final SymfonyCommunicator communicator = SymfonyCommunicator(
//       jwt: "lalala",
//       client:
//           client); //SymfonyCommunicator for communication mocking with fake jwt and the mocking client
//   final CommentRemoteService
//       remoteService //we have to pass the communicator, as it has the mocked client
//       = CommentRemoteService(
//           communicator:
//               communicator); //remoteService for mocking in the repository
//   CommentRepository repository = CommentRepository(remoteService);
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
//   final String profileId = profileDto.id.toString();
//
//   //HTTP error codes with corresponding eventFailures
//   final codesAndFailures = {
//     111: const CommentFailure.unexpected(),
//     401: const CommentFailure.notAuthenticated(),
//     222: const CommentFailure.unableToUpdate(),
//     403: const CommentFailure.insufficientPermissions(),
//     404: const CommentFailure.notFound(),
//     500: const CommentFailure.internalServer()
//   };
//   //getList operations with corresponding api paths
//   //placeholder for the listOperations
//   final listOperations = {
//     Operation.own: CommentRemoteService.ownCommentsPath
//         .interpolate({"amount" : amount.toString(),
//                       "lastCommentTime" : lastCommentTime.toString()}),
//     Operation.fromComment: CommentRemoteService.commentsFromCommentParentPath
//         .interpolate({"parentCommentId" :  x.maybeMap(                          //x commentparent in the test left(x)
//                                               (value) => value.id.toString(),
//                                               parent: (value) => value.id.toString(),
//                                               orElse: () => throw UnexpectedFormatException()),
//                       "amount" : amount.toString(),
//                       "lastCommentTime" : lastCommentTime.toString()}),
//     Operation.fromUser: CommentRemoteService.commentsFromCommentParentPath
//         .interpolate({"profileId" : profileId.toString(),
//                       "amount" : amount.toString(),
//                       "lastCommentTime" : lastCommentTime.toString()}),
//     Operation.fromPost: CommentRemoteService.commentsFromPostPath
//         .interpolate({"postId" :   1.toString(),
//                       "amount" : amount.toString(),
//                       "lastCommentTime" : lastCommentTime.toString()}),
//   };
//
//
//   //first test
//   test("Post Convertion", () {
//     CommentDto convertedTestCommentDto = CommentDto.fromJson(
//         CommentDto.fromDomain(testCommentDto.toDomain()).toJson());
//     expect(testCommentDto, convertedTestCommentDto);
//   });
//
//   //test  CRUD HERE
//   group('CRUD', () {
//     test("get Single Test", () async {
//       when(client.get("ourUrl.com/comment/1",
//               headers: authenticationHeader))
//           .thenAnswer((_) async =>
//               http.Response(jsonEncode(testCommentDtoWithoutId.toJson()), 200));
//
//       expect(
//           await repository.getSingleComment(UniqueId.fromUniqueString(1)).then((value) =>
//               value.fold((l) => null, (r) => CommentDto.fromDomain(r))),
//           testCommentDtoWithoutId);
//     });
//
//     //testing list chain and convertion
//     listOperations.forEach((operation, path) async {
//       // generate testcases for different operations
//       test("get List Test with 200 response. Operation: $operation", () async {
//         Either<CommentFailure, List<Comment>> returnedList;
//         when(client.get(SymfonyCommunicator.url + path,
//                 headers: authenticationHeader))
//             .thenAnswer((_) async => http.Response(
//                 jsonEncode(commentList.map((e) => e.toJson()).toList()),
//                 200)); // client response configuration
//         if (operation == Operation.fromUser) {
//           returnedList = await repository.getList(
//               operation, DateTime.now(), 5, profile: Profile(id: UniqueId.fromUniqueString(1), name: ProfileName("Anita"))); //the case, when profile must be passed
//         } else {
//           returnedList = await repository.getList(
//               operation, DateTime.now(), 5);
//         }
//         expect(
//             returnedList
//                 .getOrElse(() => throw Error())
//                 .map((e) => CommentDto.fromDomain(e))
//                 .toList(),
//             commentList);
//       });
//     });
//
//     test("Post with 200 response", () async {
//       when(client.post("ourUrl.com/event/post/1/comment/",
//               headers: authenticationHeader,
//               body: jsonEncode(testCommentDtoWithoutId.toJson())))
//           .thenAnswer((realInvocation) async =>
//               http.Response(jsonEncode(testCommentDto.toJson()), 200));
//
//       Comment answer = await repository
//           .create(testCommentDtoWithoutId.toDomain())
//           .then((value) => value.fold((l) => throw Error(), (r) => r));
//       expect(
//           answer.maybeMap((value) => value.id.getOrCrash(), orElse: () => null),
//           testId);
//       expect(answer == null, false);
//       expect(CommentDto.fromDomain(answer), testCommentDto);
//     });
//
//     test("Delete with 200 response", () async {
//       when(client.delete(
//               SymfonyCommunicator.url +
//                   CommentRemoteService.deletePath +
//                   testId.toString(),
//               headers: authenticationHeader))
//           .thenAnswer((realInvocation) async =>
//               http.Response(jsonEncode(testCommentDto.toJson()), 200));
//       Comment answer = await repository
//           .delete(testCommentDto.toDomain())
//           .then((value) => value.fold((l) => null, (r) => r));
//       expect(
//           answer.maybeMap((value) => value.id.getOrCrash(), orElse: () => null),
//           testId);
//       expect(answer == null, false);
//       expect(CommentDto.fromDomain(answer), testCommentDto);
//     });
//
//     test("Delete with wrong postdto type (without id)", () async {
//       when(client.delete(
//               SymfonyCommunicator.url +
//                   CommentRemoteService.deletePath +
//                   testId.toString(),
//               headers: authenticationHeader))
//           .thenAnswer((realInvocation) async => http.Response("", 200));
//       final Either<CommentFailure, Comment> answer = await repository.delete(
//           testCommentDtoWithoutId.toDomain()); //await answer from repository
//       final CommentFailure failure = answer.swap().getOrElse(() =>
//           throw Error()); //swap, so we can use get or else, and throw an error if its not an failure
//       expect(failure, const CommentFailure.unexpected());
//     });
//
//     test("Put with wrong postdto type (without id)", () async {
//       when(client.put(
//               SymfonyCommunicator.url +
//                   CommentRemoteService.updatePath +
//                   testId.toString(),
//               headers: authenticationHeader,
//               body: jsonEncode(testCommentDto.toJson())))
//           .thenAnswer((realInvocation) async => http.Response("", 200));
//       CommentFailure failure = await repository
//           .update(testCommentDtoWithoutId.toDomain())
//           .then((value) => value.swap().getOrElse(() => throw Error()));
//       expect(failure, const CommentFailure.unexpected());
//     });
//     //---------------------UPDATE----------------------
//     test("Put with 200 response", () async {
//       when(client.put(
//               SymfonyCommunicator.url +
//                   CommentRemoteService.updatePath +
//                   testId.toString(),
//               headers: authenticationHeader,
//               body: jsonEncode(testCommentDto.toJson())))
//           .thenAnswer((realInvocation) async =>
//               http.Response(jsonEncode(testCommentDto.toJson()), 200));
//
//       Comment answer = await repository
//           .update(testCommentDto.toDomain())
//           .then((value) => value.fold((l) => null, (r) => r));
//       expect(
//           answer.maybeMap((value) => value.id.getOrCrash(), orElse: () => null),
//           testId);
//       expect(answer == null, false);
//       expect(CommentDto.fromDomain(answer), testCommentDto);
//     });
//
//     //-------autogenerated on Http error codes -----------------
//     ///Test crud methods and reaction to the statuscodes
//     ///the tests are generated based on the error codes and the associated errors
//     codesAndFailures.forEach((code, pstFailure) {
//       //Autogenerated tests for the different failures in post
//       test("Post with communicaton errors. Code: $code", () async {
//         //tests for posts
//         when(client.post(
//                 SymfonyCommunicator.url + CommentRemoteService.postPath,
//                 headers: authenticationHeader,
//                 body: jsonEncode(testCommentDtoWithoutId.toJson())))
//             .thenAnswer((realInvocation) async => http.Response("", code));
//         final CommentFailure answer = await repository
//             .create(testCommentDtoWithoutId.toDomain())
//             .then((value) => value.fold((l) => l, (r) => null));
//         expect(answer, pstFailure);
//       });
//
//       test("Delete with communication errors. Code: $code", () async {
//         //Autogenerated tests for the different failures in delete
//         when(client.delete(
//                 SymfonyCommunicator.url +
//                     CommentRemoteService.deletePath +
//                     testId.toString(),
//                 headers: authenticationHeader))
//             .thenAnswer((realInvocation) async => http.Response("", code));
//         final Either<CommentFailure, Comment> answer = await repository
//             .delete(testCommentDto.toDomain()); //await answer from repository
//         final CommentFailure failure = answer.swap().getOrElse(() =>
//             throw Error()); //swap, so we can use get or else, and throw an error if its not an failure
//         expect(failure, pstFailure);
//       });
//
//       test("Put with communication Errors. Code: $code", () async {
//         when(client.put(
//                 SymfonyCommunicator.url +
//                     CommentRemoteService.updatePath +
//                     testId.toString(),
//                 headers: authenticationHeader,
//                 body: jsonEncode(testCommentDtoWithoutId.toJson())))
//             .thenAnswer((realInvocation) async => http.Response("", code));
//         CommentFailure failure = await repository
//             .update(testCommentDtoWithoutId.toDomain())
//             .then((value) => value.swap().getOrElse(() => throw Error()));
//         expect(failure, pstFailure);
//       });
//
//       ///Test for the failures in the get listCalls
//       listOperations.forEach((operation, path) {
//         test(
//             "getList with communication Errors. Operation: $operation. Code: $code",
//             () async {
//           CommentFailure returnedFailure;
//           when(client.get(SymfonyCommunicator.url + path,
//                   headers: authenticationHeader))
//               .thenAnswer((_) async => http.Response(
//                   jsonEncode(commentList.map((e) => e.toJson()).toList()), code));
//           if (operation == Operation.fromUser) {
//             returnedFailure = await repository
//                 .getList(operation, lastCommentTime, amount)
//                 .then((value) => value.swap().getOrElse(() => throw Error()));
//           } else {
//             returnedFailure = await repository
//                 .getList(operation, lastCommentTime, amount)
//                 .then((value) => value.swap().getOrElse(() => throw Error()));
//           }
//           expect(returnedFailure, pstFailure);
//         });
//       });
//
//     });
//   });
// }
