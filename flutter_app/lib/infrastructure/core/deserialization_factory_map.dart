import 'package:flutter_frontend/infrastructure/auth/user_dto.dart';

// import 'package:flutter_frontend/infrastructure/';

// I call this the one single point of ugliness
// BUT it's just one central single point instead many over all dto classes
final Map<Type, dynamic> factoryMap = {
  UserDto : (Map<String, dynamic> json) => UserDto.fromJson(json),
};