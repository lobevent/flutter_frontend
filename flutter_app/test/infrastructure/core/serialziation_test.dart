import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_frontend/infrastructure/core/deserialization.dart';
import 'package:flutter_frontend/infrastructure/core/serilization.dart';
import 'package:flutter_frontend/infrastructure/auth/user_dto.dart';


void main() {
    const userDto = UserDto(
      id: "thisIsUniqueUglinessOfAnId",
      username: "UglyUser",
      emailAddress: "ugly@ugly.com"
    );
    //generated with serializeModel(userDto);
    const String expectedUserDtoString = """{"id":"thisIsUniqueUglinessOfAnId","username":"UglyUser","emailAddress":"ugly@ugly.com"}""";
    // generated with serializedModelList([userDto, userDto])
    const String expectedUserDtoListString = """[{"id":"thisIsUniqueUglinessOfAnId","username":"UglyUser","emailAddress":"ugly@ugly.com"},{"id":"thisIsUniqueUglinessOfAnId","username":"UglyUser","emailAddress":"ugly@ugly.com"}]""";
  
  test("Test the serializeModel serialization function", () async {
    final String userJsonString = serializeModel(userDto);    
    expect(userJsonString, expectedUserDtoString);
  });

  test("Test the serializedModelList serialization function", () async {
    final String userJsonListString = serializedModelList([userDto, userDto]);
    expect(userJsonListString, expectedUserDtoListString);
  });

  test("Test the deserializeModel deserialization function", () async {
    final UserDto deserializedUserDto = await deserializeModel<UserDto>(expectedUserDtoString);
    expect(deserializedUserDto, userDto);
  });

  test("Test the deserializeModelList deserialization function", () async {
    final List<UserDto> deserializedUserDtoList = await deserializeModelList<UserDto>(expectedUserDtoListString);
    expect(deserializedUserDtoList.length, 2);
    expect(deserializedUserDtoList[0], userDto);
    expect(deserializedUserDtoList[1], userDto);
  });

  test("Test the deserializedModelList function on errors", () async {
    // test if the requested type (in this case dynamic since no 
    // type was provided for deserializeModel<T>()) is in the
    // deserialization_factory_map.dart map. This should throw an error of type
    // DtoTypeNotFoundInDeserializationFactoryMapError since dynamic has no
    // entry in the deserialization_factory_map.
    expect(deserializeModel(expectedUserDtoString), throwsException);
  });
}