import 'package:flutter/material.dart';
import 'package:waslny_captain/core/extensions/context_extension.dart';
import 'package:waslny_captain/core/extensions/string_extension.dart';
import 'package:waslny_captain/resources/image_assets.dart';

import '../../../../core/widgets/add_vertical_space.dart';
import '../../../../resources/app_strings.dart';
import '../../../../resources/app_margins_paddings.dart';
import '../../../../resources/styles_manager.dart';

class ImageWithLogo extends StatelessWidget {
  const ImageWithLogo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      children: [
        AddVerticalSpace(context.height * 0.1),
        Stack(
          children: [
            Image.asset(ImageAssets.authImgPath),
            Positioned(
              right: AppPadding.p32,
              top: context.height * 0.1,
              child: Text(
                AppStrings.appName.tr(context),
                style: appNameTextStyle(context),
              ),
            ),
          ],
        ),
        AddVerticalSpace(context.height * 0.1),
      ],
    ));
  }
}
