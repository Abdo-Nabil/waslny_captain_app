import 'package:flutter/material.dart';
import 'package:waslny_captain/core/extensions/context_extension.dart';

import '../../../../resources/app_margins_paddings.dart';
import '../../../../resources/colors_manager.dart';
import '../../../../resources/font_manager.dart';

class PositionedYellowChip extends StatelessWidget {
  const PositionedYellowChip({required this.text, Key? key}) : super(key: key);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: AppPadding.p40,
      child: Container(
        //Note The solver is BoxConstraints
        constraints: BoxConstraints(
          maxWidth: context.width * 0.60,
        ),
        padding: const EdgeInsets.symmetric(
          vertical: AppPadding.p6,
          horizontal: AppPadding.p12,
        ),
        decoration: BoxDecoration(
          color: ColorsManager.yellowAccent,
          borderRadius: BorderRadius.circular(AppPadding.p20),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 2.0),
              blurRadius: 6.0,
            )
          ],
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: FontSize.s20,
            color: ColorsManager.greyBlack,
            fontWeight: FontWeightManager.medium,
          ),
        ),
      ),
    );
  }
}
