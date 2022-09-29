import 'package:flutter/material.dart';
import 'package:waslny_captain/core/extensions/context_extension.dart';
import 'package:waslny_captain/core/extensions/string_extension.dart';
import 'package:waslny_captain/core/util/navigator_helper.dart';
import 'package:waslny_captain/features/authentication/presentation/login_screen.dart';
import 'package:waslny_captain/features/authentication/presentation/register_screen.dart';
import 'package:waslny_captain/features/authentication/presentation/widgets/custom_button.dart';
import 'package:waslny_captain/features/authentication/presentation/widgets/image_with_logo.dart';
import 'package:waslny_captain/features/authentication/presentation/widgets/login_or_register_text.dart';

import '../../../core/widgets/add_vertical_space.dart';
import '../../../resources/app_strings.dart';
import '../../../resources/colors_manager.dart';

class LoginOrRegisterScreen extends StatelessWidget {
  const LoginOrRegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.greyBlack,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const ImageWithLogo(),
            AddVerticalSpace(context.height * 0.1),
            const LoginOrRegisterText(AppStrings.youAreYourBusiness),
            AddVerticalSpace(context.height * 0.15),
            CustomButton(
              text: AppStrings.login.tr(context),
              padding: 8,
              onTap: () {
                NavigatorHelper.pushAndRemoveUntil(
                  context,
                  const LoginScreen(),
                );
              },
            ),
            CustomButton(
              text: AppStrings.registerANewCaptain.tr(context),
              padding: 8,
              onTap: () {
                NavigatorHelper.pushAndRemoveUntil(
                  context,
                  const RegisterScreen(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
