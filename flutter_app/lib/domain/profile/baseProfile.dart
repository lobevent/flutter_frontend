import 'package:flutter_frontend/domain/profile/value_objects.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'baseProfile.freezed.dart';

@freezed
abstract class BaseProfile with _$BaseProfile {
  const factory BaseProfile({
    @required int id,
    @required ProfileName name,
  }) = _BaseProfile;
}
