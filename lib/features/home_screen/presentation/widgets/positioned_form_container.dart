import 'package:flutter/material.dart';
import 'package:waslny_captain/core/extensions/context_extension.dart';
import 'package:waslny_captain/core/extensions/string_extension.dart';

import '../../../../core/util/navigator_helper.dart';
import '../../../../core/widgets/add_vertical_space.dart';
import '../../../../core/widgets/custom_form_field.dart';
import '../../../../resources/app_margins_paddings.dart';
import '../../../../resources/app_strings.dart';
import '../../../../resources/colors_manager.dart';
import '../../cubits/home_screen_cubit.dart';
import '../select_location_screen.dart';

class PositionedFormContainer extends StatefulWidget {
  const PositionedFormContainer({Key? key}) : super(key: key);

  @override
  State<PositionedFormContainer> createState() =>
      _PositionedFormContainerState();
}

class _PositionedFormContainerState extends State<PositionedFormContainer> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fromController = TextEditingController();
  final TextEditingController _toController = TextEditingController();

  @override
  void dispose() {
    _fromController.dispose();
    _toController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      child: Container(
        decoration: BoxDecoration(
          color: ColorsManager.greyBlack,
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(AppPadding.p20),
            topLeft: Radius.circular(AppPadding.p20),
          ),
          boxShadow: [
            BoxShadow(
              color: ColorsManager.greyBlack,
              offset: const Offset(0.0, 1.0), //(x,y)
              blurRadius: AppPadding.p6,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppPadding.p8),
          child: SizedBox(
            height: context.height * 0.265,
            width: context.width - AppPadding.p16,
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const AddVerticalSpace(AppPadding.p8),
                    CustomFormFiled(
                      context: context,
                      label: AppStrings.from,
                      readOnly: true,
                      prefixWidget: const Icon(Icons.add_location_alt_outlined),
                      controller: _fromController,
                      onTap: () {
                        HomeScreenCubit.getIns(context).fromController =
                            _fromController;
                        HomeScreenCubit.getIns(context).setOrigin();
                        HomeScreenCubit.getIns(context).emitInitialState();
                        NavigatorHelper.push(
                          context,
                          SelectLocationScreen(
                            label: AppStrings.pickUpLocation,
                            controller: _fromController,
                          ),
                        );
                      },
                    ),
                    const AddVerticalSpace(AppPadding.p16),
                    CustomFormFiled(
                      context: context,
                      readOnly: true,
                      label: AppStrings.whereToGo,
                      prefixWidget: const Icon(Icons.add_location_alt_outlined),
                      controller: _toController,
                      onTap: () {
                        HomeScreenCubit.getIns(context).toController =
                            _toController;
                        HomeScreenCubit.getIns(context).clearOrigin();
                        HomeScreenCubit.getIns(context).emitInitialState();
                        NavigatorHelper.push(
                          context,
                          SelectLocationScreen(
                            controller: _toController,
                            label: AppStrings.to,
                          ),
                        );
                      },
                    ),
                    const AddVerticalSpace(AppPadding.p16),
                    ElevatedButton(
                      onPressed: () {
                        HomeScreenCubit.getIns(context).requestCar(_formKey);
                      },
                      child: Text(
                        AppStrings.requestCar.tr(context),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
