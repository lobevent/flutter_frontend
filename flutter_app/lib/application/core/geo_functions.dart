import 'package:flutter_frontend/domain/post/post.dart';
import 'package:flutter_frontend/infrastructure/core/local/common_hive/common_hive.dart';
import 'package:flutter_frontend/infrastructure/core/local/common_hive/types/hive_position.dart';
import 'package:geolocator/geolocator.dart';

import '../../domain/event/event.dart';
import '../../presentation/core/utils/validators/distanceCoordinatesValidator.dart';

class GeoFunctions {
  Future<Position> checkUserPosition() async {
    return await determinePosition(LocationAccuracy.high);
  }

  ///check if we need to fetch position or if last position fetch was before some minutes
  Future<Position> checkIfNeedToFetchPosition(int minutes) async {
    //try to get boxentry
    final HivePosition? position = CommonHive.getBoxEntry<HivePosition>(
        "position", CommonHive.ownPosition);
    if (position == null ||
        position.timestamp!
            .isAfter(DateTime.now().subtract(Duration(minutes: minutes)))) {
      final Position positionFetched = await checkUserPosition();
      //save boxentry
      CommonHive.saveBoxEntry<HivePosition>(
          HivePosition.genHivePosFromPos(positionFetched),
          'position',
          CommonHive.ownPosition);
      return positionFetched;
    } else {
      return HivePosition.genPosfromHivePos(position);
    }
  }

  ///is event near our pos?
  Future<bool> checkPosAndNearEvent(Event event, int maxDistance) async {
    final Position position = await checkIfNeedToFetchPosition(5);
    return checkIfNearEvent(event.longitude, event.latitude, position.longitude,
        position.latitude, maxDistance);
  }

  ///check with haversine if distance between coords is <200m
  Future<bool> checkIfNearEvent(double? longitude, double? latitude,
      double? longitude2, double? latitude2, int maxDistance) async {
    double distanceMeters =
        calcDistanceHaversine(longitude2!, latitude2!, longitude!, latitude!);
    if (distanceMeters < maxDistance) {
      return true;
    } else {
      return false;
    }
  }

  ///returns the distance in metres
  double calcDistanceHaversine(double longitude1, double latitude1,
      double longitude2, double latitude2) {
    return DistanceCoordinatesValidator.calcDistanceHaversine(
        longitude1, latitude1, longitude2, latitude2);
  }

  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.
  Future<Position> determinePosition(LocationAccuracy desiredAccuracy) async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: desiredAccuracy);
  }
}
