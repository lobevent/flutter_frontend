import 'dart:math' as math;


// ignore: avoid_classes_with_only_static_members
class DistanceCoordinatesValidator{


  static double calcDistanceHaversine(double longitude1, double latitude1,
      double longitude2, double latitude2) {
    double R = 6371000;
    double phi1 = latitude1 * math.pi / 180;
    double phi2 = latitude2 * math.pi / 180;
    double deltaPhi = (latitude2 - latitude1) * math.pi / 180;
    double deltaLambda = (longitude2 - longitude1) * math.pi / 180;
    double a = math.sin(deltaPhi / 2) * math.sin(deltaPhi / 2) +
        math.cos(phi1) *
            math.cos(phi2) *
            math.sin(deltaLambda / 2) *
            math.sin(deltaLambda / 2);
    double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    double distance = R * c;

    return distance;
  }
}