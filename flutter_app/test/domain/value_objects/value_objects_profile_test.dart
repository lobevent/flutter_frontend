import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/domain/profile/value_objects.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:flutter_frontend/domain/profile/profile_failure.dart';
import 'package:flutter_frontend/domain/profile/i_profile_repository.dart';

class MockProfile extends Mock implements Profile {}

main() {
  Profile profile = Profile(id: 1, name: ProfileName("guenther hermann"));
}
