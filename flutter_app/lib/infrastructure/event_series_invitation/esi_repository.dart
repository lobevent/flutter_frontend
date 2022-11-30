import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:flutter_frontend/domain/core/failures.dart';
import 'package:flutter_frontend/domain/core/repository.dart';
import 'package:flutter_frontend/domain/event/event_series.dart';
import 'package:flutter_frontend/domain/event/event_series_invitation.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:flutter_frontend/infrastructure/core/interpolation.dart';
import 'package:flutter_frontend/infrastructure/core/remote_service.dart';
import 'package:flutter_frontend/infrastructure/core/symfony_communicator.dart';
import 'package:flutter_frontend/infrastructure/event_profile_picture/event_profile_picture_dtos.dart';
import 'package:flutter_frontend/infrastructure/event_series_invitation/event_series_invitation_dtos.dart';
import 'package:http/http.dart';
part 'esi_routes.dart';

class EventSeriesInvitationRepository extends Repository
    with RemoteService<EventSeriesInvitationDto> {
  final SymfonyCommunicator client;

  EventSeriesInvitationRepository({SymfonyCommunicator? communicator})
      : client = communicator ?? SymfonyCommunicator();

  ///
  /// get all [EventSeriesInvitation]s that are open or declined
  ///
  Future<Either<NetWorkFailure, List<EventSeriesInvitation>>>
      getUnacceptedEventSeriesInvites({bool declined = false}) async {
    return localErrorHandler<List<EventSeriesInvitation>>(() async {
      List<EventSeriesInvitationDto> eppDtos = await _getList(_ESI_Routes
          .getAllESInvites
          .interpolate({"declined": declined ? "1" : "0"}));
      return right(convertToDomainList(eppDtos));
    });
  }

  ///
  /// get all [EventSeriesInvitation]s that are open or declined
  ///
  Future<Either<NetWorkFailure, List<EventSeriesInvitation>>>
      getUnAcceptedInvitesAsHost({required String seriesId}) async {
    return localErrorHandler<List<EventSeriesInvitation>>(() async {
      List<EventSeriesInvitationDto> eppDtos = await _getList(_ESI_Routes
          .getAllESInvitesAsHost
          .interpolate({"eventSeriesId": seriesId}));
      return right(convertToDomainList(eppDtos));
    });
  }

  ///
  /// react to an [EventSeriesInvitation]
  /// the user can either decline or accept the invitation
  ///
  Future<Either<NetWorkFailure, EventSeriesInvitation>> react(
      {required bool accept, required EventSeriesInvitation invitation}) async {
    return localErrorHandler<EventSeriesInvitation>(() async {
      Response response = await client.delete(_ESI_Routes.react.interpolate({
        "id": invitation.eventSeries.id.value,
        "accept": accept ? "1" : "0"
      }));

      EventSeriesInvitationDto eppDtos = EventSeriesInvitationDto.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
      return right(eppDtos.toDomain());
    });
  }

  ///
  /// Sends an request to invite an user or to uninvite them
  /// Uninvitation will only have an effect if the user was invited before
  /// the [invited] flag tells whether to invite or uninvite if its false the user will be uninvited
  ///
  Future<Either<NetWorkFailure, EventSeriesInvitation>>
      changeInviteStatus_ofUser(
          {required String seriesId,
          required Profile profile,
          required bool invited,
          bool addHost = false}) async {
    return localErrorHandler<EventSeriesInvitation>(() async {
      Response response;
      if (invited) {
        response = await client.post(
            _ESI_Routes.change_status_user.interpolate({
              "id": seriesId,
              "invited": invited ? "1" : "0",
              "profileId": profile.id.value,
              "addHost": addHost ? "1" : "0",
            }),
            "");
      } else {
        response =
            await client.delete(_ESI_Routes.change_status_user.interpolate({
          "id": seriesId,
          "invited": invited ? "1" : "0",
          "profileId": profile.id.value,
          "addHost": addHost ? "1" : "0",
        }));
      }
      EventSeriesInvitationDto eppDtos = EventSeriesInvitationDto.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
      return right(eppDtos.toDomain());
    });
  }

  /// Converts Dto list to domain list
  /// this was usually used in the [Repository]s
  List<EventSeriesInvitation> convertToDomainList(
          List<EventSeriesInvitationDto> esi) =>
      esi.map((epp_dtos) => epp_dtos.toDomain()).toList();

  /// makes the repo call and converts the [EventSeriesInvitationDto]s to an actual list from json
  /// this wa usually used in the [RemoteService]s
  Future<List<EventSeriesInvitationDto>> _getList(String path) async =>
      convertList((await client.get(path)));
}
