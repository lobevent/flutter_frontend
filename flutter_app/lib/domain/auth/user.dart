import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:uuid/uuid.dart';

part 'user.freezed.dart';

@freezed
abstract class User with _$User {
  const factory User({
    @required Uuid id,
    @required String username,
    String email,
    String phoneNumber,
    String profilePictureUrl,
  }) = _User;
}
