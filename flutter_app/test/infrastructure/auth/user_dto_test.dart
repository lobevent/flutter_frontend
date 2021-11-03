import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_frontend/domain/auth/user.dart';
import 'package:flutter_frontend/infrastructure/auth/user_dto.dart';

void main() {
  test("Test the serialization", () {
    UserDto userDto = UserDto(
      id: "uniqueID",
      username: "Test username",
    );

    Map<String, dynamic> jsonMap = userDto.toJson();
    String jsonString = jsonEncode(jsonMap);
    Map<String, dynamic> jsonMapBackwards =
        jsonDecode(jsonString) as Map<String, dynamic>;
    UserDto userDtoBackwards = UserDto.fromJson(jsonMapBackwards);
    User userBackwards = userDtoBackwards.toDomain();
    print("");
  });
}
