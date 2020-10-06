
import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/event/event.dart';
import '../../domain/post/comment.dart';
import '../../domain/post/comment.dart';
import '../event/event_dtos.dart';
import '../profile/profile_dtos.dart';
import '../profile/profile_dtos.dart';
import 'post_dtos.dart';
import 'post_dtos.dart';

part 'comment_dtos.freezed.dart';
part 'comment_dtos.g.dart';

@freezed
abstract class CommentDto with _$CommentDto{
  const CommentDto._();


  const factory CommentDto({
    @required int id,
    @required String description,
    @required DateTime creationDate,
    @required ProfileDto owner,
    @required EventDto event,
    @required PostDto post,
    //ProfileDto profile, //TODO: implement profile
  }) = _CommentDto;

  factory CommentDto.fromDomain(Event event)
  {
    return CommentDto(
      id: event.id,
      description: event.description.getOrCrash(),
      creationDate: event.creationDate,
      owner: ProfileDto.fromDomain(comment.owner),
      event: EventDto.fromDomain(comment.event),
      commentContent: comment.commentContent.getOrCrash(),
      post: PostDto.fromDomain(comment.post),

    );


  }

  factory CommentDto.fromJson(Map<String, dynamic> json) =>
      _$CommentDtoFromJson(json);

  Comment toDomain(){
    return Comment(
      id: id,
      creationDate: creationDate,
      commentContent: commentContent(commentContent),
      owner: profile.toDomain(),
      event: event.toDomain(),

    );
  }


}