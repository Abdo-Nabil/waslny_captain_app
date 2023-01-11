import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:waslny_captain/core/extensions/string_extension.dart';
import 'package:waslny_captain/core/widgets/add_horizontal_space.dart';
import 'package:waslny_captain/features/general/services/general_repo.dart';
import 'package:waslny_captain/features/home_screen/cubits/home_screen_cubit.dart';
import 'package:waslny_captain/features/home_screen/presentation/widgets/rounded_widget.dart';
import 'package:waslny_captain/resources/app_margins_paddings.dart';

import '../../../../resources/app_strings.dart';
import '../../../../sensitive/constants.dart';

class PositionedCallRow extends StatelessWidget {
  const PositionedCallRow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool showCallRow =
        BlocProvider.of<HomeScreenCubit>(context, listen: true).showCallRow;
    return showCallRow
        ? Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Positioned(
                bottom: AppPadding.p12,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        final String userPhoneNumber =
                            HomeScreenCubit.getIns(context)
                                .message1
                                .data['phoneNumber'];
                        HomeScreenCubit.getIns(context)
                            .generalRepo
                            .callNumber(userPhoneNumber);
                      },
                      child: Text(
                        AppStrings.callNow.tr(context),
                      ),
                    ),
                    const AddHorizontalSpace(AppPadding.p16),
                    ElevatedButton(
                      onPressed: () async {
                        //end the trip
                      },
                      child: const Icon(Icons.clear),
                    ),
                  ],
                ),
              )
            ],
          )
        : Container();
  }
}
