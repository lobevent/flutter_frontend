part of 'esi_repository.dart';

// ignore: avoid_classes_with_only_static_members
class _ESI_Routes {
  static String getAllESInvites = "/eventSeriesInv/own/%declined%";
  static String getAllESInvitesAsHost =
      "/eventSeriesInv/asHost/%eventSeriesId%";
  static String react = "/eventSeriesInv/%id%/reactInv/%accept%";

  /// has the fields: id, invited, profile
  /// the id is of eventseries
  /// invited is an flag, whether to uninvite or invite the
  /// profile
  static String change_status_user =
      "/eventSeriesInv/%id%/%profileId%/%invited%/%addHost%";
}
