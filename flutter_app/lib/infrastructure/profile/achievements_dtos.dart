import 'dart:core';

import 'package:json_annotation/json_annotation.dart';

part 'achievements_dtos.g.dart';

@JsonSerializable()
class AchievementsDto {
  //what do we need for achievements
  int eventsCount;
  int eventsAttended;
  int peopleAttendedUrEvent;
  bool profilePicUploaded;

  //constructor
  AchievementsDto(this.eventsCount, this.eventsAttended,
      this.peopleAttendedUrEvent, this.profilePicUploaded);

  factory AchievementsDto.fromJson(Map<String, dynamic> json) =>
      _$AchievementsDtoFromJson(json);
}
