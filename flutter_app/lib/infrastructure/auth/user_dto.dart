import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';

import 'package:flutter_frontend/domain/auth/user.dart';

part 'user_dto.freezed.dart';

abstract class UserDto implements _UserDto {
  const UserDto._();

  factory UserDto({
    @required Uuid id,
    @required 
  })
}
