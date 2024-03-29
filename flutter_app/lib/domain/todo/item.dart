import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:flutter_frontend/domain/todo/value_objects.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'item.freezed.dart';

@freezed
class Item with _$Item {
  const Item._();

  const factory Item({
    required UniqueId id,
    List<Profile>? profiles,
    ItemMaxProfiles? maxProfiles,
    required ItemName name,
    required ItemDescription description,
  }) = _Item;
}
