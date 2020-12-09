import 'package:dartz/dartz.dart';
import 'package:flutter_frontend/domain/core/failures.dart';
import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/domain/event/value_objects.dart';
import 'package:flutter_frontend/domain/core/value_validators.dart';
import 'package:flutter_frontend/domain/post/comment.dart';
import 'package:flutter_frontend/domain/post/post.dart';
import 'package:flutter_frontend/domain/post/value_objects.dart';
import 'package:flutter_frontend/domain/profile/value_objects.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:flutter_frontend/domain/profile/profile_failure.dart';
import 'package:flutter_frontend/domain/profile/i_profile_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockProfile extends Mock implements Profile {}

main() {
  //Profile profile = Profile(id: 1, name: ProfileName("guenther hermann"));
  Profile profileBaseValid =
      Profile(id: Id.fromUnique(1), name: ProfileName("Guenther Hermann"));
  Profile profileBaseInvalid =
      Profile(id: Id.fromUnique(0), name: ProfileName(""));

  Event testEvent = Event(
      id: Id.fromUnique(1),
      name: EventName("coroni omi"),
      date: DateTime.now(),
      description: EventDescription("tse tse tse creeeeee"),
      creationDate: DateTime.now(),
      owner: profileBaseValid,
      public: true);
  Comment testComment = Comment(
      id: Id.fromUnique(3),
      creationDate: DateTime.now(),
      commentContent: CommentContent("ihhhhhhhhhhhhh"),
      owner: profileBaseValid,
      post: 2);

  List<Comment> commentList = [testComment];

  Post testPost = Post(
      id: Id.fromUnique(2),
      creationDate: DateTime.now(),
      postContent: PostContent("asdasddsa"),
      owner: profileBaseValid,
      event: testEvent,
      comments: commentList);

  List<Event> listi = [testEvent];
  List<Profile> friendlist = [profileBaseValid];
  List<Post> postList = [testPost];
  Profile profileFullValid = Profile.full(
      id: Id.fromUnique(1),
      name: ProfileName("Toni Hurenficker"),
      ownedEvents: listi,
      invitations: listi,
      friendships: friendlist,
      posts: postList,
      comments: commentList);
  test("Profile full valid test", () {
    //expect(right(profileBaseValid.id.failureOrUnit), true);
    //expect(right(profileBaseValid.name.isValid()), true);
    expect(profileFullValid.failureOption, None<ValueFailure<dynamic>>());
  });
  test("Profile base invalid test", () {
    expect(profileBaseInvalid, None<ValueFailure<dynamic>>());
  });
}
