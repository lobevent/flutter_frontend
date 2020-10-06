import 'package:flutter_frontend/domain/core/value_validators.dart';
import 'package:flutter_frontend/domain/post/value_objects.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_frontend/domain/post/post.dart';
import 'package:flutter/cupertino.dart';

part 'post_dtos.freezed.dart';
part 'post_dtos.g.dart';

@freezed
abstract class PostDto implements _$PostDto {
  const PostDto._();

  const factory PostDto({
    @required int id,
    @required DateTime creationDate,
    @required String postContent,
    @required String owner,
    @required String event,
  }) = _PostDto;

  factory PostDto.fromDomain(Post post) {
    return PostDto(
      id: post.id,
      creationDate: post.creationDate,
      postContent: post.postContent.getOrCrash(),
      owner: post.owner,
      event: post.event,
    );
  }

  factory PostDto.fromJson(Map<String, dynamic> json) =>
      _$PostDtoFromJson(json);

  Post toDomain(){
    return Post(
      id: id,
      creationDate: creationDate,
      postContent: PostContent(postContent),
      owner: Profile(id: 0, name: null), //TODO
      event: Event(event),
    );
  }
}

/*
  Post toDomain(){
  return Post(
    id: id,
    creationDate: DateTime ,
    postContent: PostContent(),
    owner: Profile(owner),
    event: Event(event),

  )

   */
