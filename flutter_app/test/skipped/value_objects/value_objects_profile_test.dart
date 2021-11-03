@Skip('Needs updating')

import 'package:dartz/dartz.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_frontend/application/auth/sign_in_form/sign_in_form_cubit.dart';
import 'package:flutter_frontend/domain/auth/auth_failure.dart';
import 'package:flutter_frontend/domain/auth/user.dart';
import 'package:flutter_frontend/domain/auth/value_objects.dart';
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
  //first some dummy data

  String longerThanMaxLength =
      "tse tse tse creeeeeetse tse tse creeeeeetse tse tse creeeeeetse tse tse creeeeeetse tse tse creeeeeetse tse tse creeeeeetse tse tse creeeeeetse tse tse creeeeee"
      "tse tse tse creeeeeetse tse tse creeeeeetse tse tse creeeeeetse tse tse creeeeeetse tse tse creeeeeetse tse tse creeeeeetse tse tse creeeeeetse tse tse creeeeee"
      "tse tse tse creeeeeetse tse tse creeeeeetse tse tse creeeeeetse tse tse creeeeeetse tse tse creeeeeetse tse tse creeeeeetse tse tse creeeeeetse tse tse creeeeeetse tse tse creeeeee"
      "tse tse tse creeeeeetse tse tse creeeeeetse tse tse creeeeeetse tse tse creeeeeetse tse tse creeeeeetse tse tse creeeeeetse tse tse creeeeee"
      "tse tse tse creeeeeetse tse tse creeeeeetse tse tse creeeeeetse tse tse creeeeeetse tse tse creeeeee"
      "tse tse tse creeeeeetse tse tse creeeeeetse tse tse creeeeeetse tse tse creeeeeetse tse tse creeeeeetse tse tse creeeeee"
      "tse tse tse creeeeee";
  Profile profileBaseValid = Profile(
      id: UniqueId.fromUniqueString('1'),
      name: ProfileName("Guenther Hermann"));
  Profile profileBaseInvalid = Profile(
      id: UniqueId.fromUniqueString('0'),
      name: ProfileName("Mutliliner" + "\n" + "ree"));
  DateTime trueDate = DateTime(1998, 1, 3);

  Event testEvent = Event(
      id: UniqueId.fromUniqueString('1'),
      name: EventName("coroni omi"),
      date: DateTime.now(),
      description: EventDescription("some bullshit"),
      creationDate: DateTime.now(),
      owner: profileBaseValid,
      public: true);
  Event testEventInvalid = Event(
      id: UniqueId.fromUniqueString('1'),
      name: EventName("coroni omi" + "\n" + "ree"),
      date: trueDate,
      description: EventDescription(longerThanMaxLength),
      creationDate: DateTime.now(),
      owner: profileBaseValid,
      public: true);
  Comment testComment = Comment(
      id: UniqueId.fromUniqueString('3'),
      creationDate: DateTime.now(),
      commentContent: CommentContent("ihhhhhhhhhhhhh"),
      owner: profileBaseValid,
      post: 2,
      commentChildren: Comment.children(count: 0, commentChildren: []));

  Comment testCommentInvalid = Comment(
      id: UniqueId.fromUniqueString('3'),
      creationDate: DateTime.now(),
      commentContent: CommentContent(longerThanMaxLength),
      owner: profileBaseValid,
      post: 2,
      commentChildren: Comment.children(count: 0, commentChildren: []));

  List<Comment> commentList = [testComment];

  Post testPost = Post(
      id: UniqueId.fromUniqueString('2'),
      creationDate: DateTime.now(),
      postContent: PostContent("asdasddsa"),
      owner: profileBaseValid,
      event: testEvent,
      comments: commentList);
  Post testPostInvalid = Post(
      id: UniqueId.fromUniqueString('2'),
      creationDate: DateTime.now(),
      postContent: PostContent(longerThanMaxLength),
      owner: profileBaseValid,
      event: testEvent,
      comments: commentList);

  List<Event> listi = [testEvent];
  List<Profile> friendlist = [profileBaseValid];
  List<Post> postList = [testPost];
  Profile profileFullValid = Profile.full(
      id: UniqueId.fromUniqueString('1'),
      name: ProfileName("Toni Hurenficker"),
      ownedEvents: listi,
      invitations: listi,
      friendships: friendlist,
      posts: postList,
      comments: commentList);
  SignInFormState testSignInFormState = SignInFormState(
      emailAddress: EmailAddress("huso@gmail.com"),
      password: Password("TestPw!2"),
      showErrorMessages: true,
      isSubmitting: true,
      authFailureOrSuccessOption: none());
  SignInFormState testSignInFormStateInvalid = SignInFormState(
      emailAddress: EmailAddress("huso"),
      password: Password("testpw"),
      showErrorMessages: true,
      isSubmitting: true,
      authFailureOrSuccessOption: none());
  //Test the entities if they can Validate, and when they should not be validate Objects
  test("Profile full valid test", () {
    expect(profileFullValid.failureOption, None<ValueFailure<dynamic>>());
  });
  test("Profile base invalid test", () {
    expect(
        profileBaseInvalid.failureOption,
        Some<ValueFailure<dynamic>>(ValueFailure<String>.multiLine(
            failedValue: "Mutliliner" + "\n" + "ree")));
  });
  test("Event valid test", () {
    expect(testEvent.failureOption, None<ValueFailure<dynamic>>());
  });
  test("Event invalid test", () {
    expect(
        testEventInvalid.failureOption,
        Some<ValueFailure<dynamic>>(ValueFailure<String>.multiLine(
            failedValue: "coroni omi" + "\n" + "ree")));
  });
  //if the first entity gets tested wrong, it wont test the second, so thats why check eventdescription seperate
  test("EventDescription invalid", () {
    expect(
        testEventInvalid.description.failureOrUnit,
        Left(ValueFailure<String>.exceedingLength(
            failedValue: longerThanMaxLength, maxLength: 500)));
  });
  test("Post valid test", () {
    expect(testPost.failureOption, None<ValueFailure<dynamic>>());
  });
  test("Post invalid test", () {
    expect(
        testPostInvalid.failureOption,
        Some<ValueFailure<dynamic>>(ValueFailure<String>.exceedingLength(
            failedValue: longerThanMaxLength, maxLength: 500)));
  });
  test("Comment valid test", () {
    expect(testComment.failureOption, None<ValueFailure<dynamic>>());
  });
  test("Comment invalid test", () {
    expect(
        testCommentInvalid.failureOption,
        Some<ValueFailure<dynamic>>(ValueFailure<String>.exceedingLength(
            failedValue: longerThanMaxLength, maxLength: 500)));
  });
  test("SignInFormState Password", () {
    expect(testSignInFormState.password.failureOrUnit,
        None<ValueFailure<dynamic>>());
  });
  test("SignInFormState Password invalid", () {
    expect(
        testSignInFormStateInvalid.password.failureOrUnit,
        Left<ValueFailure<dynamic>, Unit>(
            ValueFailure<String>.noBigCaseLetterPassword()));
  });
}
