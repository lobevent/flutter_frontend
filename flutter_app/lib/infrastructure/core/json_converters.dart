
import 'package:flutter_frontend/infrastructure/core/base_dto.dart';
import 'package:flutter_frontend/infrastructure/post/comment_dtos.dart';
import 'package:flutter_frontend/infrastructure/post/post_dtos.dart';
import 'package:flutter_frontend/infrastructure/profile/profile_dtos.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'deserialization_factory_map.dart';
import 'exceptions.dart';

class ListConverter<DTO extends BaseDto>
    implements JsonConverter<List<DTO>, List<dynamic>> {
  const ListConverter();

  List<DTO> convertList(List<dynamic> json) {
    List<DTO> dtoList;
    try {
      dtoList = json
          .map((e) => e as Map<String, dynamic>)
          .map((e) => factoryMap[DTO](e)
              as DTO) //factorymap is from the corefile deserialization_factory_map (single point of uglyness)
          .toList(); // TODO this is something we need to handle in a more robust and async way. This way will make our ui not responsive and also could fail if it's not a Map<String, dynamic>
    } on Exception {
      throw UnexpectedFormatException();
    }
    return dtoList;
  }

  @override
  List<DTO> fromJson(List<dynamic> list) {
    return convertList(list);
  }

  @override
  List<Map<String, dynamic>> toJson(List<DTO> object) {
    // TODO: implement toJson
    throw UnimplementedError();
  }

/*  @override
  Map<String, dynamic> toJson(ProfileDto profileDto) {
    return profileDto.toJson();
  }*/

}

class CommentsConverter extends ListConverter<CommentDto> {
  const CommentsConverter() : super();
}

class ProfileConverter
    implements JsonConverter<ProfileDto, Map<String, dynamic>> {
  const ProfileConverter();

  @override
  ProfileDto fromJson(Map<String, dynamic> owner) {
    return ProfileDto.fromJson(owner);
  }

  @override
  Map<String, dynamic> toJson(ProfileDto profileDto) {
    return profileDto.toJson();
  }
}

class PostConverter implements JsonConverter<PostDto, Map<String, dynamic>> {
  const PostConverter();

  @override
  PostDto fromJson(Map<String, dynamic> post) {
    return PostDto.fromJson(post);
  }

  @override
  Map<String, dynamic> toJson(PostDto postDto) {
    return postDto.toJson();
  }
}

class CommentConverter
    implements JsonConverter<CommentDto, Map<String, dynamic>> {
  const CommentConverter();

  @override
  CommentDto fromJson(Map<String, dynamic> comment) {
    return CommentDto.fromJson(comment);
  }

  @override
  Map<String, dynamic> toJson(CommentDto commentDto) {
    return commentDto.toJson();
  }
}

// class DatetimeConverter implements JsonConverter<DateTime, String>{
//   @override
//   DateTime fromJson(String json) {
//     // TODO: implement fromJson
//     throw UnimplementedError();
//   }
//
//   @override
//   String toJson(DateTime object) {
//     // TODO: implement toJson
//     throw UnimplementedError();
//   }
//
// }
