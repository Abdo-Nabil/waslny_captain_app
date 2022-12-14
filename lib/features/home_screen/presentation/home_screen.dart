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
import 'package:waslny_captain/features/home_screen/presentation/widgets/positioned_hamb_icon.dart';
import 'package:waslny_captain/features/home_screen/presentation/widgets/positioned_loc_icon.dart';
import 'package:waslny_captain/features/home_screen/presentation/widgets/positioned_yellow_chip.dart';
import 'package:waslny_captain/features/home_screen/services/models/active_captain_model.dart';

import '../../../resources/app_strings.dart';
import '../cubits/home_screen_cubit.dart';
import '../services/models/direction_model.dart';

//TODO: After login you must get user(captain) data if any field of non-nullable fields are null,
//this means that the user account has been created in Auth section, but not in the fireStore (May be connection lost), so request the user to continue entering the data.

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //
  @override
  void initState() {
    ToastHelper.initializeToast(context);
    HomeScreenCubit.getIns(context).getMyLocationStream();
    HomeScreenCubit.getIns(context).getCaptainInformation();
    super.initState();
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
              const PositionedFormContainer(),
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
}
