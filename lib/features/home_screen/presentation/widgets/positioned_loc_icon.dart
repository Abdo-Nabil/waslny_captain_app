import 'package:flutter/material.dart';
import 'package:waslny_captain/features/home_screen/presentation/widgets/rounded_widget.dart';

import '../../../../resources/app_margins_paddings.dart';
import '../../../localization/presentation/cubits/localization_cubit.dart';
import '../../cubits/home_screen_cubit.dart';

class PositionedLocIcon extends StatelessWidget {
  const PositionedLocIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //
    final bool isEnglishLocale =
        LocalizationCubit.getIns(context).isEnglishLocale();
    //
    return Positioned(
      left: isEnglishLocale ? null : AppPadding.p16,
      right: isEnglishLocale ? AppPadding.p16 : null,
      top: AppPadding.p46,
      child: RoundedWidget(
        iconData: Icons.my_location,
        onTap: () async {
          HomeScreenCubit.getIns(context).goToHome();
        },
      ),
    );
  }
}
