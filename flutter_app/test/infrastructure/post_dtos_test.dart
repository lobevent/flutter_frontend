import 'package:flutter_frontend/infrastructure/core/symfony_communicator.dart';
import 'package:flutter_frontend/infrastructure/event/event_dtos.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_frontend/infrastructure/profile/profile_dtos.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:flutter_frontend/infrastructure/post/post_dtos.dart';
import 'package:flutter_frontend/infrastructure/post/post_remote_service.dart';
import 'package:flutter_frontend/infrastructure/post/post_repository.dart';
import 'package:flutter_frontend/domain/post/post_failure.dart';
import 'package:flutter_frontend/domain/post/i_post_repository.dart';
import 'package:http/http.dart' as http;

class MockPost extends Mock implements Profile, http.Client {}

main() {
  const int testId = 3;

  PostDto normalPostDto1 = PostDto(id: 1,
      creationDate: DateTime.now(),
      postContent: "geiler post yeye 1",
      owner: ProfileDto(id: 0, name: "manni"),
      event: EventDto(id: 0,
          name: "corona event 1",
          public: true,
          description: "geile corona party mit 20 mann",
          date: DateTime.now(),
          creationDate: DateTime.now(),
          owner: ProfileDto(id: 1, name: "adolf")));

  PostDto normalPostDto2 = PostDto(id: 2,
      creationDate: DateTime.now(),
      postContent: "geiler post yeye 2",
      owner: ProfileDto(id: 0, name: "manni"),
      event: EventDto(id: 0,
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
      event: EventDto(id: 0,
          name: "corona event 1",
          public: true,
          description: "geile corona party mit 20 mann",
          date: DateTime.now(),
          creationDate: DateTime.now(),
          owner: ProfileDto(id: 1, name: "adolf")));

  PostDto postDtoWithoutId2 = PostDto.WithoutId(
      creationDate: DateTime.now(),
      postContent: "geiler post yeye 3",
      owner: ProfileDto(id: 0, name: "manni"),
      event: EventDto(id: 0,
          name: "corona event 1",
          public: false,
          description: "geile corona party mit 20 mann",
          date: DateTime.now(),
          creationDate: DateTime.now(),
          owner: ProfileDto(id: 1, name: "adolf")));

  const ProfileDto profileDto = ProfileDto(id: 1, name: "max");

  List<PostDto> postList = [normalPostDto1,normalPostDto2,postDtoWithoutId1,postDtoWithoutId2];

  //initializing Client and communication Objects
  final client = MockPost();
  final PostRemoteService remoteService //we have to pass the communicator, as it has the mocked client
  = PostRemoteService(); //remoteService for mocking in the repository
  final SymfonyCommunicator communicator
  = SymfonyCommunicator(jwt: "lalala", client: client); //SymfonyCommunicator for communication mocking with fake jwt and the mocking client
  PostRepository repository = PostRepository(remoteService);

  //some often used values

  const String jwt = "lalala";
  const Map<String, String> authenticationHeader = {"Authentication": "Baerer $jwt"};

  //HTTP error codes with corresponding eventFailures
  final codesAndFailures ={
    401:const PostFailure.notAuthenticated(),
    403:const PostFailure.insufficientPermissions(),
    404:const PostFailure.notFound(),
    500:const PostFailure.internalServer()
  };

  //getList operations with corresponding api paths
  final listOperations = {
    Operation.own:PostRemoteService.ownPostsPath,
    Operation.feed:PostRemoteService.feedPath,
    Operation.fromUser:PostRemoteService.postsFromUserPath,
  };

  //first test


  test("Post Convertion", () {
    PostDto convertedTestPostDto =
    PostDto.fromJson(PostDto.fromDomain(normalPostDto1.toDomain()).toJson());
    expect(normalPostDto1, convertedTestPostDto);
  });
}
