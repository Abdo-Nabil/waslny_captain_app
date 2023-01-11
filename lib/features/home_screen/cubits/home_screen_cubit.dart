import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waslny_captain/core/error/failures.dart';
import 'package:waslny_captain/core/extensions/string_extension.dart';
import 'package:waslny_captain/core/util/toast_helper.dart';
import 'package:waslny_captain/features/authentication/services/auth_repo.dart';
import 'package:waslny_captain/features/authentication/services/models/captain_model.dart';
import 'package:waslny_captain/features/general/services/general_repo.dart';
import 'package:waslny_captain/features/home_screen/services/home_repo.dart';
import 'package:waslny_captain/resources/constants_manager.dart';
import 'package:waslny_captain/resources/image_assets.dart';

import '../../../core/error/exceptions.dart';
import '../../../resources/app_strings.dart';
import '../../localization/presentation/cubits/localization_cubit.dart';
import '../services/home_local_data.dart';
import '../services/models/active_captain_model.dart';
import '../services/models/direction_model.dart';

part 'home_screen_state.dart';

class HomeScreenCubit extends Cubit<HomeScreenState> {
  final HomeRepo homeRepo;
  final GeneralRepo generalRepo;
  HomeScreenCubit(this.homeRepo, this.generalRepo) : super(HomeScreenInitial());

  LatLng? myInitialLatLng;
  late LatLng myCurrentLatLng;
  late Stream<LatLng> latLngStream;
  late bool _isOrigin;
  late GoogleMapController mapController;
  Set<Marker> markers = {};
  List<LatLng> polyLinePointsList1 = [];
  List<LatLng> polyLinePointsList2 = [];
  late LatLng origin;
  late LatLng destination;
  Marker? originMarker;
  Marker? destinationMarker;
  DirectionModel? directionModel1;
  DirectionModel? directionModel2;
  late BitmapDescriptor markerCustomIcon;
  TextEditingController? toController;
  TextEditingController? fromController;
  late CaptainModel captainInformation;
  bool isOnlineCaptain = false;
  LatLng captainCurrentLocation = ConstantsManager.nullLatLng;
  late dynamic firstMessageData;
  bool showCallRow = false;

  //
  //from userToCaptainFirstMessage
  late RemoteMessage message1;
  //
  //from captainToUserFirstMessage
  late RemoteMessage message2;

  //
  getIsOrigin() {
    return _isOrigin;
  }

  setOrigin() {
    _isOrigin = true;
  }

  clearOrigin() {
    _isOrigin = false;
  }

  cleanMarkers() {
    markers = {};
  }

  emitInitialState() {
    emit(HomeScreenInitial());
  }

  static HomeScreenCubit getIns(BuildContext context) {
    return BlocProvider.of<HomeScreenCubit>(context);
  }

  String? validateField(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.emptyValue.tr(context);
    } else {
      return null;
    }
  }

  Marker _getCurrentLocationMarker(LatLng latLng) {
    return Marker(
      markerId: const MarkerId('current location marker'),
      position: latLng,
      icon: markerCustomIcon,
    );
  }

  Future<void> onMapCreatedCallback(GoogleMapController controller) async {
    mapController = controller;
    markerCustomIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration.empty, ImageAssets.markerImgPath);
    //
    Stream<LatLng>? stream = await getMyLocationStream();
    if (stream != null) {
      //
      myInitialLatLng = await stream.first;
      myCurrentLatLng = myInitialLatLng!;
      //TODO: hint null value above
      markers.add(_getCurrentLocationMarker(myCurrentLatLng));
      emit(HomeRefreshMarkerState('$myCurrentLatLng'));
      animateCameraWithUserZoomLevel(myInitialLatLng!);
      stream.listen(
        (latLng) async {
          markers.remove(_getCurrentLocationMarker(myCurrentLatLng));
          myCurrentLatLng = latLng;
          markers.add(_getCurrentLocationMarker(myCurrentLatLng));
          animateCameraWithUserZoomLevel(latLng);

          emit(HomeRefreshMarkerState('$latLng'));
        },
      );
      //
    } else {
      animateCameraWithUserZoomLevel(cairoLatLng);
    }
  }

  getDistanceBetween(LatLng origin, LatLng destination) {
    final distanceInMetres = homeRepo.getDistanceBetween(origin, destination);
  }

  animateCameraWithUserZoomLevel(LatLng latLng) async {
    final userZoomLevel = await mapController.getZoomLevel();
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: latLng, zoom: userZoomLevel),
      ),
    );
  }

  void goToHome() {
    //
    if (myInitialLatLng != null) {
      animateCameraWithUserZoomLevel(myInitialLatLng!);
    } else {
      animateCameraWithUserZoomLevel(cairoLatLng);
    }
  }

  void addOrgOrDesMarker(BuildContext context) {
    if (_isOrigin) {
      //
      originMarker != null ? markers.remove(originMarker) : () {};
      destinationMarker != null ? markers.remove(destinationMarker) : () {};
      polyLinePointsList1.clear();
      //
      originMarker = Marker(
        markerId: const MarkerId('origin'),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueRed,
        ),
        infoWindow: InfoWindow(title: AppStrings.startPosition.tr(context)),
        position: origin,
      );
      markers.add(
        originMarker!,
      );
      animateCameraWithUserZoomLevel(origin);
      emit(HomeSuccessWithoutPopState());
    } else {
      destinationMarker = Marker(
        markerId: const MarkerId('destination'),
        icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueGreen,
        ),
        infoWindow: InfoWindow(
          title: AppStrings.endPosition.tr(context),
        ),
        position: destination,
      );
      markers.add(
        destinationMarker!,
      );
      emit(HomeSuccessWithoutPopState());
    }
  }

  Future searchForPlace(
      GlobalKey<FormState> formKey, String value, bool isEnglish) async {
    if (formKey.currentState!.validate()) {
      emit(SelectLocationLoadingState());
      //
      await Future.delayed(const Duration(seconds: 3));

      final either = await homeRepo.searchForPlace(value, isEnglish);
      either.fold((failure) {
        if (failure.runtimeType == ServerFailure) {
          emit(SearchPlaceServerFailureState());
        } else if (failure.runtimeType == OfflineFailure) {
          emit(SearchPlaceConnectionFailureState());
        }
      }, (success) {
        emit(SearchPlaceSuccessState(success));
      });
    }
  }

  Future<Stream<LatLng>?> getMyLocationStream() async {
    //
    final either = await homeRepo.checkLocationPermissions();
    bool isOk = false;
    either.fold(
      (failure) {
        emit(HomeFailureWithoutPopState());
      },
      (success) {
        switch (success) {
          case LocPermission.disabled:
            // ignore: prefer_const_constructors
            emit(OpenLocationSettingState(AppStrings.locationServicesDisabled));
            break;

          case LocPermission.denied:
            // ignore: prefer_const_constructors
            emit(OpenAppSettingState(AppStrings.locationPermissionsDenied));
            break;

          case LocPermission.deniedForever:
            // ignore: prefer_const_constructors
            emit(OpenAppSettingState(
                AppStrings.locationPermissionsDeniedForEver));
            break;
          case LocPermission.done:
            isOk = true;
            break;
        }
      },
    );

    //
    if (isOk) {
      emit(HomeLoadingState());
      await Future.delayed(const Duration(seconds: 3));
      final isConnected = await homeRepo.isConnected();
      if (isConnected) {
        final either = homeRepo.getMyLocationStream();

        return either.fold(
          (failure) {
            emit(HomeServerFailureWithPopState());
            return null;
          },
          (success) async {
            latLngStream = success;
            emit(HomeSuccessWithPopState());
            debugPrint('My Location $success');
            return success;
          },
        );
      }
      //
      else {
        emit(HomeConnectionFailureState());
        return null;
      }
    } else {
      emit(HomeLocPermissionDeniedState());
      return null;
    }
  }
  //

  void requestCar(GlobalKey<FormState> formKey) async {
    if (formKey.currentState!.validate()) {
      //
      //request  car
    }
  }

  getCaptainInformation() async {
    final storedId = generalRepo.getString(AppStrings.storedId);
    if (storedId != null) {
      // emit(HomeLoadingState());
      final either2 = await homeRepo.getCaptainInformation();
      either2.fold(
        (failure) {
          //to implement failure
          emit(const HomeWithToastState(
              AppStrings.cannotGetCaptainInfo, ToastStates.error));
        },
        (success) {
          captainInformation = success;
          // emit(HomeSuccessWithPopState());
        },
      );
    } else {
      emit(const HomeWithToastState(
          AppStrings.cannotGetLocalCaptainInfo, ToastStates.error));
    }
  }

  Future addActiveCaptain({bool showToast = true}) async {
    //get current captain location
    final either1 = await homeRepo.getMyLocation();
    //
    either1.fold((failure) {
      _showErrorToast();
    }, (latLng) async {
      //To reduce # requests in case of refreshing every 3 minutes
      if (captainCurrentLocation != latLng) {
        captainCurrentLocation = latLng;
        //send the request for adding active captain
        final fcmDeviceToken = generalRepo.getString(AppStrings.fcmToken);
        if (fcmDeviceToken != null) {
          final either2 = await homeRepo.addActiveCaptain(
            ActiveCaptainModel(
              captainModel: captainInformation,
              latLng: latLng,
              deviceToken: fcmDeviceToken,
            ),
          );
          //
          either2.fold(
            (failure) {
              //to implement failure
              _showErrorToast();
            },
            (success) {
              //to implement success
              isOnlineCaptain = true;
              showToast
                  ? emit(const HomeWithToastState(
                      AppStrings.youAreOnlineNow, ToastStates.success))
                  : () {};
            },
          );
        } else {
          _showErrorToast();
        }
      }
    });
  }

  Future removeActiveCaptain() async {
    //send the request for adding active captain
    final either =
        await homeRepo.removeActiveCaptain(captainInformation.captainId!);
    //
    either.fold(
      (failure) {
        //to implement failure
        _showErrorToast();
      },
      (success) {
        //to implement success
        isOnlineCaptain = false;
        captainCurrentLocation = ConstantsManager.nullLatLng;
        emit(const HomeWithToastState(
            AppStrings.youAreOfflineNow, ToastStates.warning));
      },
    );
  }

  Future<bool> getDirections(
    LatLng captainOrigin,
    LatLng userOrigin,
    LatLng userDestination,
    bool isEnglish,
  ) async {
    //
    emit(HomeLoadingState());
    bool isFailed = true;
    await Future.delayed(const Duration(seconds: 3));
    final either =
        await homeRepo.getDirections(captainOrigin, userOrigin, isEnglish);
    await either.fold(
      (failure) {
        if (failure.runtimeType == ServerFailure) {
          emit(HomeServerFailureWithPopState());
        } else if (failure.runtimeType == OfflineFailure) {
          emit(HomeConnectionFailureWithPopState());
        }
      },
      (success1) async {
        directionModel1 = success1;
        polyLinePointsList1 = success1.polyLinePoints;
        //
        final either2 = await homeRepo.getDirections(
            userOrigin, userDestination, isEnglish);
        either2.fold(
          (failure) {
            if (failure.runtimeType == ServerFailure) {
              emit(HomeServerFailureWithPopState());
            } else if (failure.runtimeType == OfflineFailure) {
              emit(HomeConnectionFailureWithPopState());
            }
          },
          (success2) {
            isFailed = false;
            directionModel2 = success2;
            polyLinePointsList2 = success2.polyLinePoints;
          },
        );
      },
    );
    return isFailed;
  }

  Future<bool> _sendConfirmResponse() async {
    bool isFailed = true;
    final userDeviceToken = message1.data['userDeviceToken'];
    final either =
        await homeRepo.sendConfirmResponse(userDeviceToken, myCurrentLatLng);
    either.fold((failure) {
      if (failure.runtimeType == ServerFailure) {
        emit(HomeServerFailureWithPopState());
      } else if (failure.runtimeType == OfflineFailure) {
        emit(HomeConnectionFailureWithPopState());
      }
    }, (r) {
      //implement success
      isFailed = false;
    });
    return isFailed;
  }

  Future onMessageConfirm(RemoteMessage message, BuildContext context) async {
    message1 = message;
    final captainOrigin = myCurrentLatLng;
    final userOrigin = LatLng(
      jsonDecode(message.data['latLngOrigin'])['lat'],
      jsonDecode(message.data['latLngOrigin'])['lng'],
    );
    final userDestination = LatLng(
      jsonDecode(message.data['latLngDestination'])['lat'],
      jsonDecode(message.data['latLngDestination'])['lng'],
    );
    final bool isFailed = await getDirections(
      captainOrigin,
      userOrigin,
      userDestination,
      LocalizationCubit.getIns(context).isEnglishLocale(),
    );
    if (!isFailed) {
      bool isFailed2 = await _sendConfirmResponse();
      if (!isFailed2) {
        showCallRow = true;
        mapController.animateCamera(CameraUpdate.newLatLngBounds(
            directionModel1!.bounds, ConstantsManager.mapPadding));
        emit(HomeSuccessWithPopState());
      }
    }
  }

  Future onMessageReject(RemoteMessage message, BuildContext context) async {
    final userDeviceToken = message1.data['userDeviceToken'];
    final either = await homeRepo.sendRejectResponse(userDeviceToken);
    either.fold((failure) {
      if (failure.runtimeType == ServerFailure) {
        emit(HomeServerFailureWithPopState());
      } else if (failure.runtimeType == OfflineFailure) {
        emit(HomeConnectionFailureWithPopState());
      }
    }, (r) {
      //implement success
    });
  }

  //-------------------------------------------------------------------------

  static const LatLng cairoLatLng = LatLng(
    31.2357116,
    30.0444196,
  );
  static const CameraPosition cairoCameraPosition = CameraPosition(
    target: cairoLatLng,
    zoom: ConstantsManager.mapZoomLevel,
  );
  //

  _showErrorToast() {
    emit(HomeWithToastState(AppStrings.someThingWentWrong, ToastStates.error));
  }
}
