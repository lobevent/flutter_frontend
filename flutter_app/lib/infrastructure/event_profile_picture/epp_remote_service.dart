
import 'package:flutter_frontend/infrastructure/core/remote_service.dart';

import '../core/symfony_communicator.dart';
import 'event_profile_picture_dtos.dart';

class EventProfilePictureRemoteService extends RemoteService<EventProfilePictureDto>{
  final SymfonyCommunicator client;

  EventProfilePictureRemoteService({SymfonyCommunicator? communicator})
      : client = communicator ??
      SymfonyCommunicator();




}