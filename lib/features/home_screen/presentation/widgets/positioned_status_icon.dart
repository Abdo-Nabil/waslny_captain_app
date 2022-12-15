import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:waslny_captain/core/extensions/string_extension.dart';
import 'package:waslny_captain/core/util/dialog_helper.dart';
import 'package:waslny_captain/core/widgets/add_vertical_space.dart';
import 'package:waslny_captain/features/home_screen/cubits/home_screen_cubit.dart';
import 'package:waslny_captain/features/home_screen/presentation/widgets/rounded_widget.dart';

import '../../../../resources/app_margins_paddings.dart';
import '../../../../resources/app_strings.dart';
import '../../../../resources/colors_manager.dart';
import '../../../../resources/styles_manager.dart';
import '../../../localization/presentation/cubits/localization_cubit.dart';

class PositionedStatusIcon extends StatelessWidget {
  const PositionedStatusIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //
    final bool isEnglishLocale =
        LocalizationCubit.getIns(context).isEnglishLocale();
    //
    final isOnline =
        BlocProvider.of<HomeScreenCubit>(context, listen: true).isOnlineCaptain;
    return Positioned(
      left: isEnglishLocale ? AppPadding.p16 : null,
      right: isEnglishLocale ? null : AppPadding.p16,
      top: AppPadding.p38,
      child: BuildCaptainStatus(
        isOnline: isOnline,
      ),
    );
  }
}

class BuildCaptainStatus extends StatelessWidget {
  final bool isOnline;
  const BuildCaptainStatus({Key? key, required this.isOnline})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (isOnline) {
          DialogHelper.messageWithActionsDialog(
              context, AppStrings.wantToStopWorking.tr(context), () async {
            await HomeScreenCubit.getIns(context).removeActiveCaptain();
          });
        } else {
          DialogHelper.messageWithActionsDialog(
              context, AppStrings.wantToStartWorking.tr(context), () async {
            await HomeScreenCubit.getIns(context).addActiveCaptain();
          });
        }
      },
      child: Container(
        height: AppPadding.p65,
        width: AppPadding.p80,
        padding: const EdgeInsets.all(AppPadding.p12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppPadding.p20),
          color: ColorsManager.greyBlack,
        ),
        child: Column(
          children: [
            Text(
              isOnline
                  ? AppStrings.working.tr(context)
                  : AppStrings.resting.tr(context),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const AddVerticalSpace(8),
            Divider(
              thickness: 4,
              color: isOnline ? Colors.green : Colors.red,
            )
          ],
        ),
      ),
    );
  }
}
