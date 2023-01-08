import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:waslny_captain/core/extensions/string_extension.dart';
import 'package:waslny_captain/core/util/dialog_helper.dart';
import 'package:waslny_captain/core/util/toast_helper.dart';
import 'package:waslny_captain/core/widgets/add_horizontal_space.dart';
import 'package:waslny_captain/features/authentication/cubits/auth_cubit.dart';
import 'package:waslny_captain/features/authentication/presentation/widgets/custom_button.dart';
import 'package:waslny_captain/features/authentication/services/models/captain_model.dart';
import 'package:waslny_captain/features/home_screen/presentation/widgets/positioned_form_container.dart';
import 'package:waslny_captain/features/home_screen/presentation/widgets/map_container.dart';
import 'package:waslny_captain/features/home_screen/presentation/widgets/positioned_status_icon.dart';
import 'package:waslny_captain/features/home_screen/presentation/widgets/positioned_loc_icon.dart';
import 'package:waslny_captain/features/home_screen/presentation/widgets/positioned_yellow_chip.dart';
import 'package:waslny_captain/features/home_screen/services/models/active_captain_model.dart';
import 'package:waslny_captain/features/home_screen/services/models/message_type.dart';

import '../../../resources/app_strings.dart';
import '../../../resources/constants_manager.dart';
import '../cubits/home_screen_cubit.dart';
import '../services/models/direction_model.dart';

//TODO: After login you must get user(captain) data if any field of non-nullable fields are null,
//this means that the user account has been created in Auth section, but not in the fireStore (May be connection lost), so request the user to continue entering the data.

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  debugPrint('############ Background message!!!');
}

//
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //

  Timer? refreshCaptainLocationTimer;
  @override
  void initState() {
    ToastHelper.initializeToast(context);
    HomeScreenCubit.getIns(context).getCaptainInformation();
    //
    refreshCaptainLocationTimer = Timer.periodic(
        const Duration(
            seconds: ConstantsManager.captainRefreshLatLngOnFirebase),
        (timer) async {
      updateCaptainLocation();
    });
    //
    HomeScreenCubit.getIns(context).getMyLocationStream();
    HomeScreenCubit.getIns(context).getCaptainInformation();
    initFirebaseMessaging();
    super.initState();
  }

  @override
  void dispose() {
    refreshCaptainLocationTimer?.cancel();
    super.dispose();
  }

  //
  @override
  Widget build(BuildContext context) {
    //
    // debugPrint(
    //     'sssss ${HomeScreenCubit.getIns(context).captainInformation.captainId}');
    final DirectionModel? directionModel =
        HomeScreenCubit.getIns(context).directionModel;
    //
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: BlocListener<HomeScreenCubit, HomeScreenState>(
        listener: (context, state) {
          //
          if (state is HomeLoadingState) {
            DialogHelper.loadingDialog(context);
          }
          //
          else if (state is HomeConnectionFailureState) {
            Navigator.pop(context);
            DialogHelper.messageDialog(
                context, AppStrings.internetConnectionError.tr(context));
          }
          //
          else if (state is HomeLocPermissionDeniedState) {
            DialogHelper.messageDialog(
                context, AppStrings.givePermission.tr(context));
          }
          //
          else if (state is HomeServerFailureWithPopState) {
            Navigator.pop(context);
            DialogHelper.messageDialog(
                context, AppStrings.someThingWentWrong.tr(context));
          }
          //
          else if (state is HomeConnectionFailureWithPopState) {
            Navigator.pop(context);
            DialogHelper.messageDialog(
                context, AppStrings.internetConnectionError.tr(context));
          }
          //
          else if (state is HomeFailureWithoutPopState) {
            DialogHelper.messageDialog(
                context, AppStrings.someThingWentWrong.tr(context));
          }
          //
          else if (state is OpenAppSettingState) {
            DialogHelper.messageWithActionDialog(context, state.msg.tr(context),
                () async {
              await Geolocator.openAppSettings();
            });
          }
          //
          else if (state is OpenLocationSettingState) {
            DialogHelper.messageWithActionDialog(context, state.msg.tr(context),
                () async {
              await Geolocator.openLocationSettings();
            });
          }
          //
          else if (state is HomeSuccessWithPopState) {
            Navigator.pop(context);
          }
          //
          else if (state is HomeWithToastState) {
            ToastHelper.showToast(
                context, state.msg.tr(context), state.toastState);
          }
          //
        },
        child: Scaffold(
          //TODO: Note
          // resizeToAvoidBottomInset: false,
          body: Stack(
            alignment: Alignment.center,
            children: [
              const MapContainer(),
              directionModel != null
                  ? PositionedYellowChip(
                      text:
                          '${directionModel.distance}, ${directionModel.duration}',
                    )
                  : Container(),
              const PositionedLocIcon(),
              const PositionedStatusIcon(),
              // const PositionedFormContainer(),
              // Container(
              //   color: Colors.black.withOpacity(0.7),
              //   // height: 200,
              //   // width: 400,
              // ),
              // Stack(
              //   alignment: Alignment.center,
              //   children: [
              //     Container(
              //       color: Colors.black.withOpacity(0.75),
              //     ),
              //     ElevatedButton(
              //       onPressed: () {
              //         HomeScreenCubit.getIns(context).addActiveCaptain();
              //       },
              //       child: FittedBox(
              //         child: Row(
              //           children: [
              //             const Icon(Icons.power_settings_new),
              //             const AddHorizontalSpace(12.0),
              //             Text(AppStrings.startWorking.tr(context)),
              //           ],
              //         ),
              //       ),
              //     )
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }

  updateCaptainLocation() async {
    if (HomeScreenCubit.getIns(context).isOnlineCaptain) {
      await HomeScreenCubit.getIns(context).addActiveCaptain(showToast: false);
    }
  }

  initFirebaseMessaging() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // request permissions
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    debugPrint('User granted permission:::::: ${settings.authorizationStatus}');

    // In foreground
    FirebaseMessaging.onMessage.listen(
      (RemoteMessage message) {
        debugPrint('Got a message whilst in the foreground!');
        DialogHelper.notificationDialog(context, message.data,
            ConstantsManager.userAndCaptainRequestTimeDuration, () {
          //implement me !!!!!!
        }, () {});
      },
    );

    //handle user click on the notification
    FirebaseMessaging.onMessageOpenedApp.listen(
      (RemoteMessage message) {
        debugPrint('Got a message whilst in the background!');
        final bool isRequestTimeOut = DateTime.now().isAfter(message.sentTime!
            .add(const Duration(
                seconds: ConstantsManager.userAndCaptainRequestTimeDuration)));
        if (isRequestTimeOut) {
          DialogHelper.requestTimeOutDialog(context);
        } else {
          // if (message.data['messageType'] ==
          //     MessageType.captainToUserFirstRequest.name) {
          // }
          var remainingTime = message.sentTime!
              .add(const Duration(
                  seconds: ConstantsManager.userAndCaptainRequestTimeDuration))
              .difference(DateTime.now())
              .inSeconds;
          DialogHelper.notificationDialog(
            context,
            message.data,
            remainingTime,
            () {},
            () {},
          );
        }
      },
    );

    // In background or terminated
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }
}
