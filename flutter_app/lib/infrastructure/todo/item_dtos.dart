import 'package:flutter_frontend/domain/todo/item.dart';
import 'package:flutter_frontend/infrastructure/core/json_converters.dart';
import 'package:flutter_frontend/infrastructure/profile/profile_dtos.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:flutter_frontend/infrastructure/core/base_dto.dart';
import 'package:flutter_frontend/domain/core/value_objects.dart';

part 'item_dtos.freezed.dart';

part 'item_dtos.g.dart';

@freezed
abstract class ItemDto extends BaseDto implements _$ItemDto {
  const ItemDto._();

  const factory ItemDto({
    @required int id,
    @required @ProfileConverter() ProfileDto profile,
    @required String element,
    @required bool checkMark,
  }) = _ItemDtos;

  factory ItemDto.fromDomain(Item item) {
    return ItemDto(
      id: item.id.getOrCrash(),
      profile: ProfileDto.fromDomain(item.profile),
      element: item.element,
      checkMark: item.checkMark,
    );
  }

  factory ItemDto.fromJson(Map<String, dynamic> json) =>
      _$ItemDtoFromJson(json);

  @override
  Item toDomain() {
    return Item(
      id: Id.fromUnique(id),
      profile: profile.toDomain(),
      element: element,
      checkMark: checkMark,
    );
  }
}