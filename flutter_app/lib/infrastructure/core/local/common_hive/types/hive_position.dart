import 'package:geolocator/geolocator.dart';
import 'package:hive/hive.dart';

part "hive_position.g.dart";

@HiveType(typeId: 1, adapterName: 'HivePositionAdapter')
class HivePosition extends HiveObject {
  /// The latitude of this position in degrees normalized to the interval -90.0
  /// to +90.0 (both inclusive).
  @HiveField(0)
  final double latitude;

  /// The longitude of the position in degrees normalized to the interval -180
  /// (exclusive) to +180 (inclusive).
  @HiveField(1)
  final double longitude;

  /// The time at which this position was determined.
  @HiveField(2)
  final DateTime? timestamp;

  /// The altitude of the device in meters.
  ///
  /// The altitude is not available on all devices. In these cases the returned
  /// value is 0.0.
  @HiveField(3)
  final double altitude;

  /// The estimated horizontal accuracy of the position in meters.
  ///
  /// The accuracy is not available on all devices. In these cases the value is
  /// 0.0.
  @HiveField(4)
  final double accuracy;

  /// The heading in which the device is traveling in degrees.
  ///
  /// The heading is not available on all devices. In these cases the value is
  /// 0.0.
  @HiveField(5)
  final double heading;

  /// The floor specifies the floor of the building on which the device is
  /// located.
  ///
  /// The floor property is only available on iOS and only when the information
  /// is available. In all other cases this value will be null.
  @HiveField(6)
  final int? floor;

  /// The speed at which the devices is traveling in meters per second over
  /// ground.
  ///
  /// The speed is not available on all devices. In these cases the value is
  /// 0.0.
  @HiveField(7)
  final double speed;

  /// The estimated speed accuracy of this position, in meters per second.
  ///
  /// The speedAccuracy is not available on all devices. In these cases the
  /// value is 0.0.
  @HiveField(8)
  final double speedAccuracy;

  /// Will be true on Android (starting from API lvl 18) when the location came
  /// from the mocked provider.
  ///
  /// On iOS this value will always be false.
  @HiveField(9)
  final bool isMocked;

  HivePosition({
    required this.longitude,
    required this.latitude,
    required this.timestamp,
    required this.accuracy,
    required this.altitude,
    required this.heading,
    required this.speed,
    required this.speedAccuracy,
    this.floor,
    this.isMocked = false,
  });

  @override
  Map<String, dynamic> toJson() {
    // TODO: implement toJson
    throw UnimplementedError();
  }

  static HivePosition genHivePosFromPos(Position position) {
    return HivePosition(
        longitude: position.longitude,
        latitude: position.latitude,
        timestamp: position.timestamp,
        accuracy: position.accuracy,
        altitude: position.altitude,
        heading: position.heading,
        speed: position.speed,
        speedAccuracy: position.speedAccuracy);
  }

  static Position genPosfromHivePos(HivePosition hivePosition) {
    return Position(
        longitude: hivePosition.longitude,
        latitude: hivePosition.latitude,
        timestamp: hivePosition.timestamp,
        accuracy: hivePosition.accuracy,
        altitude: hivePosition.altitude,
        heading: hivePosition.heading,
        speed: hivePosition.speed,
        speedAccuracy: hivePosition.speedAccuracy);
  }
}
