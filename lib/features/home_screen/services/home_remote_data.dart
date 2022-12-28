import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:waslny_captain/core/error/exceptions.dart';
import 'package:waslny_captain/features/authentication/services/models/captain_model.dart';
import 'package:waslny_captain/features/home_screen/services/models/active_captain_model.dart';
import 'package:waslny_captain/features/home_screen/services/models/place_model.dart';

import '../../../sensitive/constants.dart';
import 'package:http/http.dart' as http;

import '../../authentication/services/models/captain_model.dart';
import '../../authentication/services/models/captain_model.dart';
import 'models/direction_model.dart';

class HomeRemoteData {
  final http.Client client;

  HomeRemoteData({
    required this.client,
  });

  //
  //https://developers.google.com/maps/documentation/places/web-service/search-text#PlacesSearchStatus
  //
  Future<List<PlaceModel>> searchForPlace(String value, bool isEnglish) async {
    final String language = isEnglish ? 'en' : 'ar';
    String url =
        'https://maps.googleapis.com/maps/api/place/textsearch/json?query=$value&language=$language&key=$mapsApiKey';
    //
    final response = await client.get(Uri.parse(url));
    final data = json.decode(response.body);
    if (data['status'] == 'OK' || data['status'] == 'ZERO_RESULTS') {
      final List results = data['results'];
      List<PlaceModel> placesList = [];
      for (var place in results) {
        placesList.add(PlaceModel.fromJson(place));
      }
      return placesList;
    } else {
      debugPrint(
          "Home remote data searchForPlace Exception :: ${data['status']}");
      throw ServerException();
    }
  }

  //
  //https://developers.google.com/maps/documentation/directions/get-directions#DirectionsStatus
  //
  Future<DirectionModel> getDirections(
      LatLng latLngOrigin, LatLng latLngDestination, bool isEnglish) async {
    final String language = isEnglish ? 'en' : 'ar';
    final origin = '${latLngOrigin.latitude},${latLngOrigin.longitude}';
    final destination =
        '${latLngDestination.latitude},${latLngDestination.longitude}';
    //
    String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=$origin&destination=$destination&language=$language&key=$mapsApiKey';

    final response = await client.get(Uri.parse(url));
    final data = json.decode(response.body);
    if (data['status'] == 'OK') {
      if (data['routes'].isEmpty || data['routes'][0]['legs'].isEmpty) {
        throw ServerException();
      }
      return DirectionModel.fromJson(data);
    } else {
      debugPrint(
          "Home remote data getDirections Exception :: ${data['status']}");
      throw ServerException();
    }
  }

  Future<CaptainModel> getCaptainInformation() async {
    try {
      final captainId = FirebaseAuth.instance.currentUser?.uid;
      final db = FirebaseFirestore.instance;
      final temp = await db.collection('captains').doc(captainId).get();
      final Map<String, dynamic>? map = temp.data();
      return CaptainModel.fromJson(map!);
    } catch (e) {
      debugPrint(
          'getCaptainInformation :: Home remote repo :: Exception :: $e');
      throw ServerException();
    }
  }

  Future addActiveCaptain(ActiveCaptainModel activeCaptainModel) async {
    try {
      final db = FirebaseFirestore.instance;
      final captainId = activeCaptainModel.captainModel.captainId;
      await db
          .collection('activeCaptains')
          .doc(captainId)
          .set(activeCaptainModel.toJson());
    } catch (e) {
      debugPrint('addActiveCaptain :: Home remote repo :: Exception :: $e');
      throw ServerException();
    }
  }

  Future removeActiveCaptain(String captainId) async {
    try {
      final db = FirebaseFirestore.instance;
      await db.collection('activeCaptains').doc(captainId).delete();
    } catch (e) {
      debugPrint('addActiveCaptain :: Home remote repo :: Exception :: $e');
      throw ServerException();
    }
  }
}
