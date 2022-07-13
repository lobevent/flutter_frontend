import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';


class AddressDetailed extends Address {
  final String? housenumber;

  AddressDetailed(
     {this.housenumber,
    String? postcode,
    String? name,
    String? street,
    String? city,
    String? state,
    String? country,
  }) : super(
          postcode: postcode,
          street: street,
          city: city,
          name: name,
          state: state,
          country: country,
        );

  AddressDetailed.fromPhotonAPI(Map data)
      : this.housenumber = data["housenumber"] as String?,
        super(
            postcode: data["postcode"] as String?,
            name: data["name"] as String?,
            street: data["street"] as String?,
            city: data["city"] as String?,
            state: data["state"] as String?,
            country: data["country"] as String?);

  @override
  String toString() {
    String addr = "";
    if (name != null && name!.isNotEmpty) {
      addr = addr + "$name ";
    }
    if (street != null && street!.isNotEmpty) {
      addr = addr + "$street ";
    }
    if (housenumber != null && housenumber!.isNotEmpty) {
      addr = addr + "$housenumber ";
    }
    if (postcode != null && postcode!.isNotEmpty) {
      addr = addr + "$postcode ";
    }
    if (city != null && city!.isNotEmpty) {
      addr = addr + "$city ";
    }
    if (state != null && state!.isNotEmpty) {
      addr = addr + "$state ";
    }
    if (country != null && country!.isNotEmpty) {
      addr = addr + "$country";
    }

    return addr;
  }
}

class SearchInfoDetailed extends SearchInfo {

  AddressDetailed? addressDetailed;
  SearchInfoDetailed({
    GeoPoint? point,
    AddressDetailed? address,
    this.addressDetailed
  }) : super(point: point, address: address);

  SearchInfoDetailed.fromPhotonAPI(Map data)
      : this.addressDetailed = AddressDetailed.fromPhotonAPI(data['properties'] as Map) ,super(point : GeoPoint(latitude: data["geometry"]["coordinates"][1] as double, longitude: data["geometry"]["coordinates"][0] as double),
        address : Address.fromPhotonAPI(data["properties"] as Map));
}
