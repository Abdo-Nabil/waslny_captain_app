import 'package:flutter/material.dart';
import 'package:waslny_captain/features/home_screen/services/models/place_model.dart';
import 'package:waslny_captain/features/localization/presentation/cubits/localization_cubit.dart';

import '../../../../resources/app_margins_paddings.dart';
import '../../../../resources/colors_manager.dart';
import '../../cubits/home_screen_cubit.dart';

class PlaceItem extends StatelessWidget {
  final TextEditingController controller;
  final PlaceModel placeModel;
  final bool isGreenColor;
  const PlaceItem({
    required this.controller,
    required this.placeModel,
    this.isGreenColor = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isEnglishLocale =
        LocalizationCubit.getIns(context).isEnglishLocale();
    return Padding(
      padding: const EdgeInsets.all(AppPadding.p8),
      child: ListTile(
        leading: Icon(
          Icons.location_on_sharp,
          color:
              isGreenColor ? ColorsManager.greenColor : ColorsManager.redColor,
        ),
        title: Text(placeModel.name),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppPadding.p20),
        ),
        tileColor: Theme.of(context).cardColor,
        onTap: () async {
          _onTap(context, isEnglishLocale);
        },
      ),
    );
  }

  _onTap(BuildContext context, bool isEnglishLocale) async {
    controller.text = placeModel.name;
    final bool isOrigin = HomeScreenCubit.getIns(context).getIsOrigin();
    Navigator.of(context).pop();
    if (isOrigin) {
      HomeScreenCubit.getIns(context).toController?.clear();
      HomeScreenCubit.getIns(context).origin = placeModel.location;
      HomeScreenCubit.getIns(context).addOrgOrDesMarker(context);
    } else {
      HomeScreenCubit.getIns(context).destination = placeModel.location;
      HomeScreenCubit.getIns(context).addOrgOrDesMarker(context);
      // HomeScreenCubit.getIns(context).getDirections(context, isEnglishLocale);
    }
  }
}
