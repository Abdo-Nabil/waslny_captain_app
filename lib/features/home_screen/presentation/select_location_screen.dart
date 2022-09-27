import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:waslny_captain/core/extensions/context_extension.dart';
import 'package:waslny_captain/core/extensions/string_extension.dart';
import 'package:waslny_captain/core/widgets/no_x_widget.dart';
import 'package:waslny_captain/features/home_screen/cubits/home_screen_cubit.dart';
import 'package:waslny_captain/features/home_screen/presentation/widgets/location_item.dart';
import 'package:waslny_captain/features/home_screen/presentation/widgets/search_container.dart';
import 'package:waslny_captain/features/home_screen/services/models/place_model.dart';
import 'package:waslny_captain/resources/app_margins_paddings.dart';
import 'package:waslny_captain/resources/image_assets.dart';

import '../../../resources/app_strings.dart';

class SelectLocationScreen extends StatelessWidget {
  final String label;
  final TextEditingController controller;

  const SelectLocationScreen({
    required this.label,
    required this.controller,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //
    final PlaceItem? myCurrentLocationPlaceItem =
        HomeScreenCubit.getIns(context).getIsOrigin()
            ? PlaceItem(
                controller: controller,
                isGreenColor: true,
                placeModel: PlaceModel(
                  name: AppStrings.myCurrentLocation.tr(context),
                  placeId: 'MyCurrentLocation',
                  location: HomeScreenCubit.getIns(context).myInitialLatLng ??
                      HomeScreenCubit.cairoLatLng,
                ),
              )
            : null;
    //
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: BlocBuilder<HomeScreenCubit, HomeScreenState>(
        builder: (context, state) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            body: Column(
              children: [
                SearchContainer(
                  controller: controller,
                  label: label,
                ),
                BlocBuilder<HomeScreenCubit, HomeScreenState>(
                  builder: (context, state) {
                    if (state is SearchPlaceSuccessState) {
                      if (state.places.isEmpty) {
                        return _myLocationAndWidget(
                          context,
                          myCurrentLocationPlaceItem,
                          Expanded(
                            child: NoXWidget(
                              msg: AppStrings.notFoundLocation.tr(context),
                              imagePath: ImageAssets.notFoundImgPath,
                            ),
                          ),
                        );
                      }
                      //
                      else {
                        return Expanded(
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            physics: const BouncingScrollPhysics(),
                            itemCount: state.places.length,
                            itemBuilder: (context, index) {
                              if (index == 0) {
                                return Column(
                                  children: [
                                    myCurrentLocationPlaceItem ?? Container(),
                                    PlaceItem(
                                      placeModel: state.places[index],
                                      controller: controller,
                                    ),
                                  ],
                                );
                              }
                              return PlaceItem(
                                placeModel: state.places[index],
                                controller: controller,
                              );
                            },
                          ),
                        );
                      }
                    }

                    //
                    else if (state is SearchPlaceServerFailureState) {
                      return Expanded(
                        child: NoXWidget(
                          msg: AppStrings.someThingWentWrong.tr(context),
                          imagePath: ImageAssets.alertImgPath,
                        ),
                      );
                    }
                    //
                    else if (state is SearchPlaceConnectionFailureState) {
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(AppPadding.p30),
                          child: NoXWidget(
                            msg: AppStrings.internetConnectionError.tr(context),
                            imagePath: ImageAssets.noInternetConnectionImgPath,
                          ),
                        ),
                      );
                    }
                    //
                    else if (state is SelectLocationLoadingState) {
                      return _myLocationAndWidget(
                        context,
                        myCurrentLocationPlaceItem,
                        SizedBox(
                          height: context.height * 0.60,
                          width: double.infinity,
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      );
                    }
                    //
                    return _myLocationAndWidget(
                      context,
                      myCurrentLocationPlaceItem,
                      Expanded(
                        child: NoXWidget(
                          msg: AppStrings.searchForLocation.tr(context),
                          imagePath: ImageAssets.searchImgPath,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

_myLocationAndWidget(
    BuildContext context, Widget? nullWidget, Widget mainWidget) {
  return SizedBox(
    height: context.height * 0.70,
    child: Column(
      children: [
        nullWidget ?? Container(),
        mainWidget,
      ],
    ),
  );
}
