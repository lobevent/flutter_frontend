

import 'package:dartz/dartz.dart';
import 'package:flutter_frontend/domain/core/failures.dart';
import 'package:flutter_frontend/domain/post/comment.dart';
import 'package:flutter_frontend/infrastructure/core/exceptions.dart';
import 'package:flutter_frontend/infrastructure/core/exceptions_handler.dart';
import 'package:flutter_frontend/infrastructure/post/comment_dtos.dart';


class Repository<Domain>{

  ///
  /// executes try catch routine and returns failure if there was a networkexception
  ///
  Future<Either<NetWorkFailure, T>> localErrorHandler<T>(Future<Either<NetWorkFailure, T>> Function() function) async {
    try {
      return function();
    } on CommunicationException catch (e) {
      return left(ExceptionsHandler.reactOnCommunicationException(e));
    }
  }
}