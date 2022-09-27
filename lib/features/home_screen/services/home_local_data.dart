import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:waslny_captain/resources/constants_manager.dart';

import '../../../core/error/exceptions.dart';

enum LocPermission {
  done,
  disabled,
  denied,
  deniedForever,
}

class HomeLocalData {
  //
  Future<LocPermission> checkLocationPermissions() async {
    // Test if location services are enabled.
    final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      debugPrint('Location services are disabled ::');
      return LocPermission.disabled;
    }
    //check permissions
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      try {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          debugPrint('Location permissions are denied ::');
          return LocPermission.denied;
        }
      } catch (e) {
        debugPrint('Location permissions Exception :: $e');
        throw LocationPermissionException();
      }
    }

    if (permission == LocationPermission.deniedForever) {
      debugPrint(
          'Location permissions are permanently denied, we cannot request permissions ::');
      return LocPermission.deniedForever;
    }
    return LocPermission.done;
  }

  Future<LatLng> getMyLocation() async {
    try {
      final Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation,
        timeLimit: const Duration(seconds: ConstantsManager.locationTimeLimit),
      );
      return LatLng(position.latitude, position.longitude);
    } on TimeoutException {
      throw TimeLimitException();
    } on LocationServiceDisabledException {
      throw LocationDisabledException();
    }
  }

  Stream<LatLng> getMyLocationStream() {
    try {
      const LocationSettings locationSettings = LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: ConstantsManager.minDistanceToUpdate,
        // timeLimit: Duration(seconds: ConstantsManager.locationTimeLimit),
      );
      //
      Stream<LatLng> latLngStream =
          Geolocator.getPositionStream(locationSettings: locationSettings)
              .map((position) => LatLng(position.latitude, position.longitude));
      return latLngStream;
    } on TimeoutException {
      throw TimeLimitException();
    } on LocationServiceDisabledException {
      throw LocationDisabledException();
    }
  }

  double getDistanceBetween(LatLng origin, LatLng destination) {
    return Geolocator.distanceBetween(origin.latitude, origin.longitude,
        destination.latitude, destination.longitude);
  }
}
