import 'package:flutter_frontend/domain/event/event_series_invitation.dart';
import 'package:flutter_frontend/infrastructure/auth/user_dto.dart';
import 'package:flutter_frontend/infrastructure/event/event_dtos.dart';
import 'package:flutter_frontend/infrastructure/event_series/eventSeries_dtos.dart';
import 'package:flutter_frontend/infrastructure/invitation/invitation_dtos.dart';
import 'package:flutter_frontend/infrastructure/my_location/my_location_dtos.dart';
import 'package:flutter_frontend/infrastructure/post/comment_dtos.dart';
import 'package:flutter_frontend/infrastructure/post/post_dtos.dart';
import 'package:flutter_frontend/infrastructure/profile/achievements_dtos.dart';
import 'package:flutter_frontend/infrastructure/profile/profile_dtos.dart';
import 'package:flutter_frontend/infrastructure/todo/item_dtos.dart';
import 'package:flutter_frontend/infrastructure/todo/todo_dtos.dart';
import 'package:flutter_frontend/infrastructure/event_series_invitation/event_series_invitation_dtos.dart';

import '../event_profile_picture/event_profile_picture_dtos.dart';

// import 'package:flutter_frontend/infrastructure/';

// I call this the one single point of ugliness
// BUT it's just one central single point instead many over all dto classes
final Map<Type, dynamic> factoryMap = {
  UserDto: (Map<String, dynamic> json) => UserDto.fromJson(json),
  EventDto: (Map<String, dynamic> json) => EventDto.fromJson(json),
  CommentDto: (Map<String, dynamic> json) => CommentDto.fromJson(json),
  PostDto: (Map<String, dynamic> json) => PostDto.fromJson(json),
  ProfileDto: (Map<String, dynamic> json) => ProfileDto.fromJson(json),
  TodoDto: (Map<String, dynamic> json) => TodoDto.fromJson(json),
  ItemDto: (Map<String, dynamic> json) => ItemDto.fromJson(json),
  InvitationDto: (Map<String, dynamic> json) => InvitationDto.fromJson(json),
  EventSeriesDto: (Map<String, dynamic> json) => EventSeriesDto.fromJson(json),
  MyLocationDto: (Map<String, dynamic> json) => MyLocationDto.fromJson(json),
  EventProfilePictureDto: (Map<String, dynamic> json) =>
      EventProfilePictureDto.fromJson(json),
  AchievementsDto: (Map<String, dynamic> json) =>
      AchievementsDto.fromJson(json),
  EventSeriesInvitationDto: (Map<String, dynamic> json) =>
      EventSeriesInvitationDto.fromJson(json),
};
