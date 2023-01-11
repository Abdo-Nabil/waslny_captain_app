import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:waslny_captain/core/extensions/string_extension.dart';
import 'package:waslny_captain/core/util/dialog_helper.dart';
import 'package:waslny_captain/core/util/toast_helper.dart';
import 'package:waslny_captain/features/home_screen/presentation/widgets/map_container.dart';
import 'package:waslny_captain/features/home_screen/presentation/widgets/positioned_call_row.dart';
import 'package:waslny_captain/features/home_screen/presentation/widgets/positioned_status_icon.dart';
import 'package:waslny_captain/features/home_screen/presentation/widgets/positioned_loc_icon.dart';
import 'package:waslny_captain/features/home_screen/presentation/widgets/two_chips.dart';

import '../../../resources/app_strings.dart';
import '../../../resources/constants_manager.dart';
import '../cubits/home_screen_cubit.dart';

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
            children: const [
              MapContainer(),
              TwoChips(),
              PositionedLocIcon(),
              PositionedStatusIcon(),
              PositionedCallRow(),
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
      (RemoteMessage message) async {
        HomeScreenCubit.getIns(context).firstMessageData = message;
        debugPrint('Got a message whilst in the foreground!');
        await DialogHelper.notificationDialog(
          context,
          message.data,
          ConstantsManager.userAndCaptainRequestTimeDuration,
          () async {
            await HomeScreenCubit.getIns(context)
                .onMessageConfirm(message, context);
          },
          () async {
            await HomeScreenCubit.getIns(context)
                .onMessageReject(message, context);
          },
        );
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
