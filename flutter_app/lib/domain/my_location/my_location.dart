
import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/domain/event/event.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'my_location.freezed.dart';

@freezed
class MyLocation with _$MyLocation{
  MyLocation._();

  factory MyLocation({
    UniqueId? id,
    required double latitude,
    required double longitude,
    required String address,
    required String name,
    Profile? profile,
  }) = _MyLocation;

}