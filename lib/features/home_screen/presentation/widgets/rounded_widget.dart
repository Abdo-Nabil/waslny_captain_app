import 'package:flutter/material.dart';

import '../../../../resources/app_margins_paddings.dart';
import '../../../../resources/colors_manager.dart';

class RoundedWidget extends StatelessWidget {
  final IconData iconData;
  final Function onTap;
  const RoundedWidget({
    Key? key,
    required this.iconData,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap();
      },
      child: Container(
        height: AppPadding.p46,
        width: AppPadding.p46,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppPadding.p20),
          color: ColorsManager.greyBlack,
        ),
        child: Icon(
          iconData,
          color: ColorsManager.whiteColor,
        ),
      ),
    );
  }
}
