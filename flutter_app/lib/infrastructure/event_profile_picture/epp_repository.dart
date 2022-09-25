import 'package:flutter_frontend/domain/core/repository.dart';
import 'package:flutter_frontend/infrastructure/event_profile_picture/epp_remote_service.dart';

class EventProfilePictureRepository extends Repository{

  final EventProfilePictureRemoteService _eppRemoteService;

  EventProfilePictureRepository(this._eppRemoteService);


}