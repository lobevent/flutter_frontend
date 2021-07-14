import 'package:flutter_frontend/domain/core/failures.dart';

import 'exceptions.dart';

class ExceptionsHandler {
    static NetWorkFailure reactOnCommunicationException(CommunicationException e) {
       switch (e.runtimeType) {
         case NotFoundException:
           return const NetWorkFailure.notFound();
           break;
         case InternalServerException:
           return const NetWorkFailure.internalServer();
           break;
         case NotAuthenticatedException:
           return const NetWorkFailure.notAuthenticated();
           break;
         case NotAuthorizedException:
           return const NetWorkFailure.insufficientPermissions();
           break;
         case UnexpectedFormatException:
           return const NetWorkFailure.unexpected();
         default:
           return const NetWorkFailure.unexpected();
           break;
       }
    }
}