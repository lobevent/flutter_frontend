import 'package:flutter_frontend/domain/core/value_objects.dart';
import 'package:flutter_frontend/domain/profile/profile.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import 'event.dart';

class Invitation {
  UniqueId id = UniqueId();
  Profile profile;
  Event? event;
  bool? addHost;
  EventStatus userEventStatus = EventStatus.attending;

  Invitation({
    required this.id,
    required this.profile,
    required this.event,
    this.addHost,
    this.userEventStatus = EventStatus.attending,
  });
}
