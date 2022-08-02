import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_frontend/infrastructure/core/position.dart';
import 'package:flutter_frontend/presentation/core/utils/validators/distanceCoordinatesValidator.dart';
import 'package:geolocator/geolocator.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'dart:math' as math;

import '../../domain/event/event.dart';

part 'geo_functions_cubit.freezed.dart';
part 'geo_functions_state.dart';

class GeoFunctionsCubit extends Cubit<GeoFunctionsState> {
  Position? position;
  final Event? event;
  bool? nearby;

  GeoFunctionsCubit({required this.event})
      : super(GeoFunctionsState.initial()) {
    emit(GeoFunctionsState.initial());
    checkPosAndNearEvent();
  }

  ///only safe the position of the user in state
  Future<void> checkUserPosition() async {
    try {
      emit(GeoFunctionsState.loading());
      position = await determinePosition(LocationAccuracy.high).then((value) {
        emit(GeoFunctionsState.loaded(position: value, nearby: false));
      });
    } catch (e) {
      GeoFunctionsState.error(error: e.toString());
    }
  }

  ///check position of user and calc if is in same area <200m of the event
  Future<void> checkPosAndNearEvent() async {
    try {
      emit(GeoFunctionsState.loading());
      position =
          await determinePosition(LocationAccuracy.high).then((posValue) {
        checkIfNearEvent(event!.longitude, event!.latitude, posValue.longitude,
                posValue.latitude)
            .then((nearbyVal) {
          emit(GeoFunctionsState.loaded(position: posValue, nearby: nearbyVal));
        });
      });
    } catch (e) {
      GeoFunctionsState.error(error: e.toString());
    }
  }

  ///check with haversine if distance between coords is <200m
  Future<bool> checkIfNearEvent(double? longitude, double? latitude,
      double? longitude2, double? latitude2) async {
    double distanceMeters =
        calcDistanceHaversine(longitude2!, latitude2!, longitude!, latitude!);
    if (distanceMeters < 200) {
      nearby = true;
      return true;
    } else {
      nearby = false;
      return false;
    }
  }

  ///returns the distance in metres
  double calcDistanceHaversine(double longitude1, double latitude1,
      double longitude2, double latitude2) {
    return DistanceCoordinatesValidator.calcDistanceHaversine(longitude1, latitude1, longitude2, latitude2);
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
