import 'package:flutter/material.dart';
import 'package:waslny_captain/features/home_screen/presentation/widgets/rounded_widget.dart';

import '../../../../resources/app_margins_paddings.dart';
import '../../../localization/presentation/cubits/localization_cubit.dart';

class PositionedHambIcon extends StatelessWidget {
  const PositionedHambIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //
    final bool isEnglishLocale =
        LocalizationCubit.getIns(context).isEnglishLocale();
    //
    return Positioned(
      left: isEnglishLocale ? AppPadding.p16 : null,
      right: isEnglishLocale ? null : AppPadding.p16,
      top: AppPadding.p38,
      child: RoundedWidget(
        iconData: Icons.menu,
        onTap: () {
          //TODO :
        },
      ),
    );
  }
}
