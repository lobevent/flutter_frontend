

import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/domain/my_location/my_location.dart';
import 'package:flutter_frontend/domain/my_location/my_location_value_objects.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:flutter_frontend/infrastructure/core/base_dto.dart';
import 'package:flutter_frontend/infrastructure/core/json_converters.dart';
import 'package:flutter_frontend/infrastructure/event/event_dtos.dart';
import 'package:flutter_frontend/infrastructure/profile/profile_dtos.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'my_location_dtos.freezed.dart';
part 'my_location_dtos.g.dart';


@freezed
class MyLocationDto extends BaseDto<MyLocation> with _$MyLocationDto{



  const MyLocationDto._();

  const factory MyLocationDto({
    String? id,
    required String address,
    required String name,
    required double latitude,
    required double longitude,
    @ProfileConverter() ProfileDto? profile,
  }) = MyLocationD;

  factory MyLocationDto.fromDomain(MyLocation myLocation){
    return MyLocationDto(address: myLocation.address.getOrEmptyString(), name: myLocation.name.getOrEmptyString(), latitude: myLocation.latitude, longitude: myLocation.longitude);
  }

  @override
  MyLocation toDomain() {
    return MyLocation(id: id != null ? UniqueId.fromUniqueString(id!): null, latitude: latitude, longitude: longitude, address: MyLocationAddress(address), name: MyLocationName(name));
  }


  factory MyLocationDto.fromJson(Map<String, dynamic> json) =>
      _$MyLocationDtoFromJson(json);
}