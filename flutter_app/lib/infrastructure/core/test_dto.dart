import 'package:freezed_annotation/freezed_annotation.dart';

part 'test_dto.freezed.dart';
part 'test_dto.g.dart';

abstract class BaseDto {
  const BaseDto();

   Map<String, dynamic> toJson();
}

@freezed
abstract class TestDto extends BaseDto implements _$TestDto {
  const TestDto._();

  const factory TestDto({
    @required String someTestString,
  }) = _TestDto;

  factory TestDto.fromJson(Map<String, dynamic> json) => _$TestDtoFromJson(json);
}