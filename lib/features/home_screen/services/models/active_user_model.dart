import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:waslny_captain/features/home_screen/services/models/user_model.dart';

class ActiveUserModel {
  final UserModel userModel;
  final String origin;
  final String destination;
  final LatLng latLngOrigin;
  final LatLng latLngDestination;
  final String userDeviceToken;

  ActiveUserModel({
    required this.userModel,
    required this.origin,
    required this.destination,
    required this.latLngOrigin,
    required this.latLngDestination,
    required this.userDeviceToken,
  });

  factory ActiveUserModel.fromJson(Map<String, dynamic> map) {
    return ActiveUserModel(
      userModel: UserModel.fromJson(map['userModel']),
      origin: map['origin'],
      destination: map['destination'],
      latLngOrigin: LatLng(map['lat'], map['lng']),
      latLngDestination: LatLng(map['lat'], map['lng']),
      userDeviceToken: map['userDeviceToken'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userModel': userModel.toJson(),
      'origin': origin,
      'destination': destination,
      'latLngOrigin': {
        'lat': latLngOrigin.latitude,
        'lng': latLngOrigin.longitude,
      },
      'latLngDestination': {
        'lat': latLngDestination.latitude,
        'lng': latLngDestination.longitude,
      },
      'userDeviceToken': userDeviceToken,
    };
  }
}
