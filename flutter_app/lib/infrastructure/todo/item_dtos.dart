import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/domain/todo/item.dart';
import 'package:flutter_frontend/domain/todo/value_objects.dart';
import 'package:flutter_frontend/infrastructure/core/base_dto.dart';
import 'package:flutter_frontend/infrastructure/profile/profile_dtos.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'item_dtos.freezed.dart';
part 'item_dtos.g.dart';

@freezed
class ItemDto extends BaseDto with _$ItemDto {
  const ItemDto._();

  const factory ItemDto({
    required String id,
    required List<ProfileDto>? profiles,
    required String description,
    required String name,
    int? maxProfiles,
  }) = _ItemDto;

  factory ItemDto.fromDomain(Item item) {
    return ItemDto(
      id: item.id.value,
      profiles: item.profiles!
          .map((profile) => ProfileDto.fromDomain(profile))
          .toList(),
      description: item.description.getOrCrash(),
      name: item.name.getOrCrash(),
      maxProfiles: item.maxProfiles?.getOrCrash(),
    );
  }

  factory ItemDto.fromJson(Map<String, dynamic> json) =>
      _$ItemDtoFromJson(json);

  @override
  Item toDomain() {
    return Item(
        id: UniqueId.fromUniqueString(this.id),
        profiles: profiles!.map((pdto) => pdto.toDomain()).toList(),
        maxProfiles: maxProfiles == null ? ItemMaxProfiles(maxProfiles!) : null,
        name: ItemName(name),
        description: ItemDescription(description));
  }
}
