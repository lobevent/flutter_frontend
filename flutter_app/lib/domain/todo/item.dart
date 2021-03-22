import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'item.freezed.dart';
@freezed
class Item implements _$Item {
  const Item._();

  const factory Item({
    required Id id,
    required Profile profile,
    required String element,
    required bool checkMark,
  }) = _Item;

}