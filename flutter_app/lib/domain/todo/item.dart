import 'package:dartz/dartz.dart';
import 'package:flutter_frontend/domain/core/failures.dart';
import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:flutter_frontend/domain/todo/value_objects.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'item.freezed.dart';
@freezed
abstract class Item implements _$Item {
  const Item._();

  const factory Item({
    @required Id id,
    @required Profile profile,
    @required ItemContent itemContent,
    @required bool checkMark,
  }) = _Item;

  Option<ValueFailure<dynamic>> get failureOption {
    return itemContent.failureOrUnit.fold((f) => some(f), (_) => none());
  }
}