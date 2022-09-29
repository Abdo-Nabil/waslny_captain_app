import 'package:flutter/material.dart';
import 'package:waslny_captain/core/extensions/string_extension.dart';
import 'package:waslny_captain/features/authentication/cubits/auth_cubit.dart';
import 'package:waslny_captain/features/authentication/presentation/login_screen.dart';
import 'package:waslny_captain/features/authentication/presentation/widgets/text_row.dart';

import '../../../../core/util/navigator_helper.dart';
import '../../../../core/widgets/add_vertical_space.dart';
import '../../../../core/widgets/custom_form_field.dart';
import '../../../../core/widgets/password_form_field.dart';
import '../../../../resources/app_margins_paddings.dart';
import '../../../../resources/app_strings.dart';
import 'login_or_register_text.dart';

class SecurityForm extends StatelessWidget {
  final GlobalKey<FormState> securityFormKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController rePasswordController;

  const SecurityForm({
    required this.securityFormKey,
    required this.emailController,
    required this.passwordController,
    required this.rePasswordController,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: securityFormKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const LoginOrRegisterText(AppStrings.securityInformation),
          const AddVerticalSpace(AppPadding.p20),
          CustomFormFiled(
            context: context,
            controller: emailController,
            label: AppStrings.email,
            textInputType: TextInputType.emailAddress,
            prefixWidget: const Icon(Icons.mail_outline),
            validate: (value) {
              return AuthCubit.getIns(context).validateEmail(context, value);
            },
          ),
          const AddVerticalSpace(AppPadding.p20),
          PasswordFormFiled(
            context: context,
            controller: passwordController,
            label: AppStrings.password,
            validate: (value) {
              return AuthCubit.getIns(context).validatePassword(context, value);
            },
          ),
          const AddVerticalSpace(AppPadding.p20),
          PasswordFormFiled(
            context: context,
            controller: rePasswordController,
            label: AppStrings.reenterPassword,
            validate: (value) {
              return _validateRePassword(context, value);
            },
          ),
          // Spacer(),
          const AddVerticalSpace(AppPadding.p20),
          TextRow(
            text: AppStrings.alreadyHaveAccount,
            textButton: AppStrings.loginNow,
            onTap: () {
              NavigatorHelper.pushAndRemoveUntil(
                context,
                const LoginScreen(),
              );
            },
          ),
        ],
      ),
    );
  }

  _validateRePassword(BuildContext context, String value) {
    if (value.isEmpty) {
      return AppStrings.emptyValue.tr(context);
    }
    if (value != passwordController.text) {
      return AppStrings.passwordDoesntMatch.tr(context);
    }
    return null;
  }
}
