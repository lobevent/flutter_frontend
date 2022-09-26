import 'package:dartz/dartz.dart';
import 'package:flutter_frontend/domain/core/failures.dart';
import 'package:flutter_frontend/domain/core/repository.dart';
import 'package:flutter_frontend/infrastructure/event_profile_picture/epp_remote_service.dart';
import 'package:flutter_frontend/infrastructure/event_profile_picture/event_profile_picture_dtos.dart';

import '../../domain/event/event.dart';
import '../../domain/event/event_profile_picture.dart';

class EventProfilePictureRepository extends Repository{

  final EventProfilePictureRemoteService remoteService;

  EventProfilePictureRepository({required this.remoteService});


  Future<Either<NetWorkFailure, List<EventProfilePicture>>> getEPPsFromEvent(Event event) async {
    return localErrorHandler<List<EventProfilePicture>>(() async {

      List<EventProfilePictureDto> eppDtos =  await remoteService.getFromEvent(event.id.value.toString());
      return right(convertToDomainList(eppDtos));

    });
  }



  ///
  /// converts to domain list
  ///
  List<EventProfilePicture> convertToDomainList(List<EventProfilePictureDto> epp_dtos) {
    return epp_dtos.map((epp_dtos) => epp_dtos.toDomain()).toList();
  }
}