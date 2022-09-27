import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DirectionModel {
  final LatLngBounds bounds;
  final List<LatLng> polyLinePoints;
  final String distance;
  final String duration;

  DirectionModel({
    required this.bounds,
    required this.polyLinePoints,
    required this.distance,
    required this.duration,
  });

  factory DirectionModel.fromJson(Map<String, dynamic> map) {
    //bounds
    final boundsTemp = map['routes'][0]['bounds'];
    final LatLng northeast =
        LatLng(boundsTemp['northeast']['lat'], boundsTemp['northeast']['lng']);
    final LatLng southwest =
        LatLng(boundsTemp['southwest']['lat'], boundsTemp['southwest']['lng']);
    final bounds = LatLngBounds(northeast: northeast, southwest: southwest);
    //Distance & time
    final legsTemp = map['routes'][0]['legs'][0];
    final String distance = legsTemp['distance']['text'];
    final String duration = legsTemp['duration']['text'];
    //Polyline points
    final encodedPolyLinePoints =
        map['routes'][0]['overview_polyline']['points'];
    final pointLatLngList =
        PolylinePoints().decodePolyline(encodedPolyLinePoints);
    List<LatLng> latLngList = [];
    for (var point in pointLatLngList) {
      latLngList.add(LatLng(point.latitude, point.longitude));
    }
    //
    return DirectionModel(
      bounds: bounds,
      polyLinePoints: latLngList,
      distance: distance,
      duration: duration,
    );
  }
}
