import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_frontend/infrastructure/profile/profile_dtos.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:flutter_frontend/infrastructure/post/comment_dtos.dart';


class MockComment extends Mock implements CommentDto {}

main() {
  test("Comment Convertion", ()
  {
    CommentDto testCommentDto = CommentDto(id: 1,commentContent: "eins guter Kommentar",creationDate: DateTime.now(),profile: ProfileDto(id: 1,name: "manfred"),commentParent: null,post: 1,commentChildren: null);
    CommentDto convertedCommentDto =
    CommentDto.fromJson(CommentDto.fromDomain(testCommentDto.toDomain()).toJson());
    expect(testCommentDto, convertedCommentDto);
  });
}