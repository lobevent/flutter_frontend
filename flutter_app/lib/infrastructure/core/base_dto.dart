abstract class BaseDto<T> {
  const BaseDto(); // for freezed to work we need this const constructor

  Map<String, dynamic> toJson();

  T toDomain();
}

// Below you can see a minimal example implementation using the BaseDto as superclass

// import 'package:freezed_annotation/freezed_annotation.dart';

// part 'test_dto.freezed.dart';
// part 'test_dto.g.dart';

// @freezed
// abstract class TestDto extends BaseDto<User> implements _$TestDto {
//   const TestDto._();

//   const factory TestDto({
//     required String someTestString,
//   }) = _TestDto;

//   factory TestDto.fromJson(Map<String, dynamic> json) => _$TestDtoFromJson(json);

//   @override
//   User toDomain() => User();
// }
