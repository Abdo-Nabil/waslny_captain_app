import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:waslny_captain/features/home_screen/presentation/widgets/positioned_chip.dart';

import '../../../../resources/app_margins_paddings.dart';
import '../../../../resources/colors_manager.dart';
import '../../cubits/home_screen_cubit.dart';
import '../../services/models/direction_model.dart';

class TwoChips extends StatelessWidget {
  const TwoChips({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DirectionModel? directionModel1 =
        BlocProvider.of<HomeScreenCubit>(context, listen: true).directionModel1;
    final DirectionModel? directionModel2 =
        BlocProvider.of<HomeScreenCubit>(context, listen: true).directionModel2;
    return Stack(
      alignment: Alignment.center,
      children: [
        directionModel1 != null
            ? PositionedChip(
                topPadding: AppPadding.p30,
                color: ColorsManager.purpleColor,
                text:
                    '${directionModel1.distance}, ${directionModel1.duration}',
              )
            : Container(),
        //
        directionModel2 != null
            ? PositionedChip(
                topPadding: AppPadding.p80,
                color: ColorsManager.redColor,
                text:
                    '${directionModel2.distance}, ${directionModel2.duration}',
              )
            : Container(),
      ],
    );
  }
}
