import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_frontend/infrastructure/core/serialization.dart';
import 'package:flutter_frontend/infrastructure/auth/user_dto.dart';


void main() {





  test("Test the base serialization function", () async {
    final userDto = UserDto(
      id: "thisIsUniqueUgliness",
      username: "UglyUser",
      emailAddress: "ugly@ugly.com"
    );
    final userJsonString = "[${jsonEncode(userDto.toJson())}]"; // convert to a list of dtos with one single dto
    
    final List<UserDto> afterSerialization = await deserialize<UserDto>(userJsonString);
    print(afterSerialization);
  });
}