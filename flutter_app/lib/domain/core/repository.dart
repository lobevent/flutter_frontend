

import 'package:dartz/dartz.dart';
import 'package:flutter_frontend/domain/core/failures.dart';
import 'package:flutter_frontend/domain/post/comment.dart';
import 'package:flutter_frontend/infrastructure/core/exceptions.dart';
import 'package:flutter_frontend/infrastructure/core/exceptions_handler.dart';
import 'package:flutter_frontend/infrastructure/post/comment_dtos.dart';

import '../../infrastructure/core/base_dto.dart';


class Repository<Domain>{

  ///
  /// executes try catch routine and returns failure if there was a networkexception
  ///
  Future<Either<NetWorkFailure, T>> localErrorHandler<T>(Future<Either<NetWorkFailure, T>> Function() function) async {
    Either<NetWorkFailure, T> result;
    try {
      result = await function();
      //return function();
    } on CommunicationException catch (e) {
      result = left(ExceptionsHandler.reactOnCommunicationException(e));
    }
    return result;
  }



  Future<Either<NetWorkFailure, List<Domain>>> getList<T extends BaseDto<Domain>>(Future<List<T>> Function() repocall) async {
    return localErrorHandler(() async{
      final dto = await repocall();
      //convert the dto objects to domain Objects
      final domainObjects = dto.map((idto) => idto.toDomain()).toList();
      return right(domainObjects);
    });
  }
}