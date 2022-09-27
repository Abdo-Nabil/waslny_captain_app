import 'package:google_maps_flutter/google_maps_flutter.dart';

class PlaceModel {
  final String name;
  final String placeId;
  final LatLng location;
  final LatLng? northeastView;
  final LatLng? southwestView;

  const PlaceModel({
    required this.name,
    required this.placeId,
    required this.location,
    this.northeastView,
    this.southwestView,
  });

  factory PlaceModel.fromJson(Map<String, dynamic> map) {
    //
    return PlaceModel(
      name: map['name'],
      placeId: map['place_id'],
      location: LatLng(map['geometry']['location']['lat'],
          map['geometry']['location']['lng']),
      northeastView: LatLng(map['geometry']['viewport']['northeast']['lat'],
          map['geometry']['viewport']['northeast']['lng']),
      southwestView: LatLng(map['geometry']['viewport']['southwest']['lat'],
          map['geometry']['viewport']['northeast']['lng']),
    );
  }
}
