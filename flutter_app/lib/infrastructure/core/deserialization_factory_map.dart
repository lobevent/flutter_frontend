import 'package:flutter_frontend/infrastructure/auth/user_dto.dart';
import 'package:flutter_frontend/infrastructure/event/event_dtos.dart';
import 'package:flutter_frontend/infrastructure/post/comment_dtos.dart';
import 'package:flutter_frontend/infrastructure/post/post_dtos.dart';
import 'package:flutter_frontend/infrastructure/profile/profile_dtos.dart';

// import 'package:flutter_frontend/infrastructure/';

// I call this the one single point of ugliness
// BUT it's just one central single point instead many over all dto classes
final Map<Type, dynamic> factoryMap = {
  UserDto : (Map<String, dynamic> json) => UserDto.fromJson(json),
  EventDto : (Map<String, dynamic> json) => EventDto.fromJson(json),
  CommentDto : (Map<String, dynamic> json) => CommentDto.fromJson(json),
  PostDto : (Map<String, dynamic> json) => PostDto.fromJson(json),
  ProfileDto : (Map<String, dynamic> json) => ProfileDto.fromJson(json),
};