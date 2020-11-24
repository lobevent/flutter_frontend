import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_frontend/infrastructure/core/deserialization.dart';
import 'package:flutter_frontend/infrastructure/auth/user_dto.dart';


void main() {

  test("Test the base serialization function", () async {
    const userDto = UserDto(
      id: "thisIsUniqueUgliness",
      username: "UglyUser",
      emailAddress: "ugly@ugly.com"
    );
    final userJsonString = "[${jsonEncode(userDto.toJson())}]"; // convert to a list of dtos with one single dto
    
    final List<UserDto> afterSerialization = await deserializeModelList<UserDto>(userJsonString);
    print(afterSerialization);
  });
}