import 'package:flutter/material.dart';
import 'package:dartz/dartz.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:waslny_captain/core/error/exceptions.dart';
import 'package:waslny_captain/core/error/failures.dart';
import 'package:waslny_captain/features/home_screen/services/models/direction_model.dart';
import 'package:waslny_captain/features/home_screen/services/models/place_model.dart';
import 'package:waslny_captain/features/home_screen/services/home_remote_data.dart';

import '../../../core/network/network_info.dart';
import 'home_local_data.dart';

class HomeRepo {
  final HomeRemoteData homeRemoteData;
  final HomeLocalData homeLocalData;
  final NetworkInfo networkInfo;
  HomeRepo(this.homeRemoteData, this.homeLocalData, this.networkInfo);

  //-----------------Local data source-----------------

  Future<Either<Failure, LocPermission>> checkLocationPermissions() async {
    try {
      final locPermission = await homeLocalData.checkLocationPermissions();
      return Right(locPermission);
    } on LocationPermissionException {
      return Left(LocationPermissionFailure());
    }
  }

  Future<Either<Failure, LatLng>> getMyLocation() async {
    try {
      final latLng = await homeLocalData.getMyLocation();
      return Right(latLng);
    } on TimeLimitException {
      return Left(TimeLimitFailure());
    } on LocationDisabledException {
      return Left(LocationDisabledFailure());
    }
  }

  Either<Failure, Stream<LatLng>> getMyLocationStream() {
    try {
      final latLngStream = homeLocalData.getMyLocationStream();
      return Right(latLngStream);
    } on TimeLimitException {
      return Left(TimeLimitFailure());
    } on LocationDisabledException {
      return Left(LocationDisabledFailure());
    }
  }

  //
  //
  //-----------------Remote data source-----------------

  Future<bool> isConnected() async {
    return await networkInfo.isConnected;
  }

  Future<Either<Failure, List<PlaceModel>>> searchForPlace(
      String value, bool isEnglish) async {
    if (await networkInfo.isConnected) {
      //
      try {
        final result = await homeRemoteData.searchForPlace(value, isEnglish);
        return Right(result);
      } on ServerException {
        debugPrint('Home Repo :: searchForPlace :: ServerException :: ');
        return Left(ServerFailure());
      } catch (e) {
        debugPrint('Home Repo :: searchForPlace Exception :: $e');
        return Left(ServerFailure());
      }
      //
    } else {
      return Left(OfflineFailure());
    }
  }

  Future<Either<Failure, DirectionModel>> getDirections(
      LatLng latLngOrigin, LatLng latLngDestination, bool isEnglish) async {
    if (await networkInfo.isConnected) {
      //
      try {
        final result = await homeRemoteData.getDirections(
            latLngOrigin, latLngDestination, isEnglish);
        return Right(result);
      } on ServerException {
        debugPrint('Home Repo :: getDirections :: ServerException :: ');
        return Left(ServerFailure());
      } catch (e) {
        debugPrint('Home Repo :: getDirections Exception :: $e');
        return Left(ServerFailure());
      }
      //
    } else {
      return Left(OfflineFailure());
    }
  }

  double getDistanceBetween(LatLng origin, LatLng destination) {
    return homeLocalData.getDistanceBetween(origin, destination);
  }
}
