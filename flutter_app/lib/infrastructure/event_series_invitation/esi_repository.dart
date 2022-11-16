
import 'package:dartz/dartz.dart';
import 'package:flutter_frontend/domain/core/failures.dart';
import 'package:flutter_frontend/domain/core/repository.dart';
import 'package:flutter_frontend/domain/event/event_series_invitation.dart';
import 'package:flutter_frontend/infrastructure/core/interpolation.dart';
import 'package:flutter_frontend/infrastructure/core/remote_service.dart';
import 'package:flutter_frontend/infrastructure/core/symfony_communicator.dart';
import 'package:flutter_frontend/infrastructure/event_profile_picture/event_profile_picture_dtos.dart';
import 'package:flutter_frontend/infrastructure/event_series_invitation/event_series_invitation_dtos.dart';
import 'package:http/http.dart';
part 'esi_routes.dart';

class EventSeriesInvitationRepository extends Repository with RemoteService<EventSeriesInvitationDto>{

  final SymfonyCommunicator client;

  EventSeriesInvitationRepository({SymfonyCommunicator? communicator})
      : client = communicator ??
      SymfonyCommunicator();


  ///
  /// get all [EventSeriesInvitation]s that are open or declined
  ///
  Future<Either<NetWorkFailure, List<EventSeriesInvitation>>> getUnacceptedEventSeriesInvites({bool declined = false}) async{
    return localErrorHandler<List<EventSeriesInvitation>>(() async {
      List<EventSeriesInvitationDto> eppDtos =  await _getList(
          _ESI_Routes.getAllESInvites.interpolate({"declined": declined ? "1" : "0"}));
      return right(convertToDomainList(eppDtos));
    });
  }








  /// Converts Dto list to domain list
  List<EventSeriesInvitation> convertToDomainList(List<EventSeriesInvitationDto> esi) =>
      esi.map((epp_dtos) => epp_dtos.toDomain()).toList();



  /// makes the repo call and converts the [EventSeriesInvitationDto]s to an actual list from json
  Future<List<EventSeriesInvitationDto>> _getList(String path) async => convertList((await client.get(path)));



}