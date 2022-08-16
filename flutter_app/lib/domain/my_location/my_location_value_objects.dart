import 'package:dartz/dartz.dart';
import 'package:flutter_frontend/data/constants.dart';
import 'package:flutter_frontend/domain/core/failures.dart';
import 'package:flutter_frontend/domain/core/value_objects.dart';

import '../core/value_validators.dart';

class MyLocationName extends ValueObject<String>{

  static int maxLength = Constants.maxLocationName;

  @override
  final Either<ValueFailure<String>, String>  value;

  factory MyLocationName(String input){
    assert(input != null);
    {
      return MyLocationName._(validateLength(input, maxLength: maxLength));
    }
  }

  MyLocationName._(this.value);

}

class MyLocationAddress extends ValueObject<String>{

  static int maxLength = Constants.maxLocationAddres;

  @override
  final Either<ValueFailure<String>, String>  value;

  factory MyLocationAddress(String input){
    assert(input != null);
    {
      return MyLocationAddress._(validateLength(input, maxLength: maxLength));
    }
  }

  MyLocationAddress._(this.value);

}