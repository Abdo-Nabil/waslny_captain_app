import 'package:flutter/material.dart';
import 'package:waslny_captain/core/extensions/context_extension.dart';
import 'package:waslny_captain/core/extensions/string_extension.dart';
import 'package:waslny_captain/features/authentication/presentation/lists.dart';

import '../../../../core/util/dialog_helper.dart';
import '../../../../core/widgets/add_vertical_space.dart';
import '../../../../core/widgets/custom_form_field.dart';
import '../../../../resources/app_margins_paddings.dart';
import '../../../../resources/app_strings.dart';
import '../../../localization/presentation/cubits/localization_cubit.dart';
import '../../cubits/auth_cubit.dart';
import 'login_or_register_text.dart';

class PersonalForm extends StatelessWidget {
  final GlobalKey<FormState> personalFormKey;
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController ageController;
  final TextEditingController genderController;

  const PersonalForm(
      {required this.personalFormKey,
      required this.nameController,
      required this.phoneController,
      required this.ageController,
      required this.genderController,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    //
    final isEnglishLocale = LocalizationCubit.getIns(context).isEnglishLocale();
    //
    return Form(
      key: personalFormKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const LoginOrRegisterText(AppStrings.personalInformation),
          const AddVerticalSpace(AppPadding.p20),
          CustomFormFiled(
            context: context,
            controller: nameController,
            label: AppStrings.name,
            prefixWidget: const Icon(Icons.person),
            validate: (value) {
              return _validateName(context, value);
            },
          ),
          const AddVerticalSpace(AppPadding.p20),
          CustomFormFiled(
            context: context,
            controller: phoneController,
            label: AppStrings.phone,
            textInputType: TextInputType.phone,
            showPlus20: true,
            prefixWidget: isEnglishLocale
                ? const Icon(Icons.phone)
                : const Icon(Icons.phone_enabled),
            validate: (value) {
              return _validatePhone(context, value);
            },
          ),
          const AddVerticalSpace(AppPadding.p20),
          CustomFormFiled(
            context: context,
            controller: ageController,
            label: AppStrings.age,
            textInputType: TextInputType.number,
            prefixWidget: const Icon(Icons.add),
            validate: (value) {
              return _validateAge(context, value);
            },
          ),
          const AddVerticalSpace(AppPadding.p20),
          CustomFormFiled(
            readOnly: true,
            context: context,
            controller: genderController,
            label: AppStrings.gender,
            prefixWidget: const Icon(Icons.transgender),
            validate: (value) {
              return _validateGender(context, value);
            },
            onTap: () {
              DialogHelper.selectDialog(
                context,
                height: context.height * 0.2,
                title: AppStrings.gender.tr(context),
                list: isEnglishLocale ? englishGender : arabicGender,
                controller: genderController,
              );
            },
          ),
        ],
      ),
    );
  }

  _validateName(BuildContext context, String value) {
    if (value.isEmpty) {
      return AppStrings.emptyValue.tr(context);
    }
    return null;
  }

  _validatePhone(BuildContext context, String value) {
    final isValid = AuthCubit.getIns(context).isValidPhoneNumber(value);
    if (isValid) {
      return null;
    }
    return AppStrings.enterValidPhone.tr(context);
  }

  _validateAge(BuildContext context, String value) {
    if (value.isEmpty) {
      return AppStrings.emptyValue.tr(context);
    }
    if (value.length > 2) {
      return AppStrings.notValidValue.tr(context);
    }
    final result = int.tryParse(value);
    if (result == null) {
      return AppStrings.notValidValue.tr(context);
    }
    return null;
  }

  _validateGender(BuildContext context, String value) {
    if (value.isEmpty) {
      return AppStrings.emptyValue.tr(context);
    }
    return null;
  }
}
