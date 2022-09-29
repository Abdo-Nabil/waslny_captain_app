import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:waslny_captain/core/extensions/string_extension.dart';
import 'package:waslny_captain/core/util/dialog_helper.dart';
import 'package:waslny_captain/features/home_screen/presentation/widgets/positioned_form_container.dart';
import 'package:waslny_captain/features/home_screen/presentation/widgets/map_container.dart';
import 'package:waslny_captain/features/home_screen/presentation/widgets/positioned_hamb_icon.dart';
import 'package:waslny_captain/features/home_screen/presentation/widgets/positioned_loc_icon.dart';
import 'package:waslny_captain/features/home_screen/presentation/widgets/positioned_yellow_chip.dart';

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
    HomeScreenCubit.getIns(context).getMyLocationStream();
    super.initState();
  }

  //
  @override
  Widget build(BuildContext context) {
    //
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
              const PositionedHambIcon(),
              const PositionedFormContainer(),
            ],
          ),
        ),
      ),
    );
  }
}
