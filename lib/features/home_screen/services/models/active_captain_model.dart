import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:waslny_captain/features/authentication/services/models/captain_model.dart';

class ActiveCaptainModel extends Equatable {
  final CaptainModel captainModel;
  final LatLng latLng;

  const ActiveCaptainModel({required this.captainModel, required this.latLng});

  factory ActiveCaptainModel.fromJson(Map<String, dynamic> map) {
    return ActiveCaptainModel(
      captainModel: CaptainModel.fromJson(map['captainModel']),
      latLng: LatLng(map['latLng']['lat'], map['latLng']['lng']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'captainModel': captainModel.toJson(),
      'latLng': {'lat': latLng.latitude, 'lng': latLng.longitude},
    };
  }

  @override
  List<Object?> get props => [captainModel, latLng];
}
