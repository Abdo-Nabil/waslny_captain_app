import 'package:flutter/material.dart';
import 'package:waslny_captain/core/extensions/context_extension.dart';
import 'package:waslny_captain/core/extensions/string_extension.dart';
import 'package:waslny_captain/core/util/dialog_helper.dart';
import 'package:waslny_captain/features/localization/presentation/cubits/localization_cubit.dart';

import '../../../../core/widgets/add_vertical_space.dart';
import '../../../../core/widgets/custom_form_field.dart';
import '../../../../resources/app_margins_paddings.dart';
import '../../../../resources/app_strings.dart';
import '../lists.dart';
import 'login_or_register_text.dart';

class CarForm extends StatelessWidget {
  final GlobalKey<FormState> carFormKey;
  final TextEditingController carModelController;
  final TextEditingController plateNumberController;
  final TextEditingController carColorController;
  final TextEditingController productionDateController;
  final TextEditingController numOfPassengersController;

  const CarForm({
    required this.carFormKey,
    required this.carModelController,
    required this.plateNumberController,
    required this.carColorController,
    required this.productionDateController,
    required this.numOfPassengersController,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //
    final isEnglishLocale = LocalizationCubit.getIns(context).isEnglishLocale();
    //
    return Form(
      key: carFormKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const LoginOrRegisterText(
            AppStrings.carInformation,
          ),
          const AddVerticalSpace(AppPadding.p20),
          CustomFormFiled(
            context: context,
            controller: carModelController,
            label: AppStrings.carModel,
            readOnly: true,
            prefixWidget: const Icon(Icons.car_rental),
            validate: (value) {
              return _validateField(context, value);
            },
            onTap: () {
              DialogHelper.selectWithSearchDialog(
                context,
                title: AppStrings.carModel.tr(context),
                searchHint: AppStrings.searchDots.tr(context),
                controller: carModelController,
                list: isEnglishLocale ? englishCars : arabicCars,
              );
            },
          ),
          const AddVerticalSpace(AppPadding.p20),
          CustomFormFiled(
            context: context,
            controller: plateNumberController,
            label: AppStrings.plateNumber,
            prefixWidget: const Icon(Icons.window),
            validate: (value) {
              return _validateField(context, value);
            },
          ),
          const AddVerticalSpace(AppPadding.p20),
          CustomFormFiled(
            context: context,
            controller: carColorController,
            label: AppStrings.carColor,
            readOnly: true,
            prefixWidget: const Icon(Icons.color_lens),
            validate: (value) {
              return _validateField(context, value);
            },
            onTap: () {
              DialogHelper.selectDialog(
                context,
                height: context.height * 0.3,
                title: AppStrings.carColor.tr(context),
                list: isEnglishLocale ? englishColors : arabicColors,
                leadingListWidgets: getColorWidgets(),
                controller: carColorController,
              );
            },
          ),
          const AddVerticalSpace(AppPadding.p20),
          CustomFormFiled(
            readOnly: true,
            context: context,
            controller: productionDateController,
            label: AppStrings.productionDate,
            prefixWidget: const Icon(Icons.date_range),
            validate: (value) {
              return _validateField(context, value);
            },
            onTap: () {
              DialogHelper.selectDialog(
                context,
                title: AppStrings.productionDate.tr(context),
                list: getDatesList(),
                controller: productionDateController,
                height: context.height * 0.4,
              );
            },
          ),
          const AddVerticalSpace(AppPadding.p20),
          CustomFormFiled(
            readOnly: true,
            context: context,
            controller: numOfPassengersController,
            label: AppStrings.numOfPassengers,
            prefixWidget: const Icon(Icons.family_restroom),
            validate: (value) {
              return _validateField(context, value);
            },
            onTap: () {
              DialogHelper.selectDialog(
                context,
                title: AppStrings.numOfPassengers.tr(context),
                list: [2, 4, 6],
                controller: numOfPassengersController,
                height: context.height * 0.2,
              );
            },
          ),
        ],
      ),
    );
  }

  _validateField(BuildContext context, String value) {
    if (value.isEmpty) {
      return AppStrings.emptyValue.tr(context);
    }
    return null;
  }
}
