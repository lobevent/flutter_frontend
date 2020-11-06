import 'package:dartz/dartz.dart';
import 'package:flutter_frontend/infrastructure/event/event_dtos.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_frontend/infrastructure/profile/profile_dtos.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:flutter_frontend/domain/post/post.dart';
import 'package:flutter_frontend/infrastructure/post/post_dtos.dart';
import 'package:flutter_frontend/domain/event/event.dart';

class MockPost extends Mock implements Post {}

main() {
  test("Event Convertion", ()
  {
    PostDto testPostDto = PostDto(
        id: 1,
        event: EventDto(id: 1,name: "event1",public: true,description: "best event ever", date: DateTime.now(),creationDate: DateTime.now(), owner: ProfileDto(id: 1,name: "Manfred")),
        postContent: "kleines event",
        owner: ProfileDto(id: 0, name: "manfred"),
        creationDate: DateTime.now());
    PostDto convertedTestPostDto =
    PostDto.fromJson(PostDto.fromDomain(testPostDto.toDomain()).toJson());
    expect(testPostDto, convertedTestPostDto);
  });
}
