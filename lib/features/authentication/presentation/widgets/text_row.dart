import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:waslny_captain/core/extensions/string_extension.dart';
import 'package:waslny_captain/resources/colors_manager.dart';

import '../../../../core/widgets/add_horizontal_space.dart';
import '../../../../resources/app_margins_paddings.dart';
import '../../cubits/auth_cubit.dart';

class TextRow extends StatelessWidget {
  final String text;
  final String textButton;
  final Function onTap;
  final bool isResendButton;
  const TextRow(
      {required this.text,
      required this.textButton,
      required this.onTap,
      this.isResendButton = false,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool showResendButton =
        BlocProvider.of<AuthCubit>(context, listen: true).showResendButton;
    //
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(text.tr(context)),
        const AddHorizontalSpace(AppPadding.p8),
        isResendButton
            ? GestureDetector(
                child: Text(
                  textButton.tr(context),
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        color: showResendButton
                            ? ColorsManager.primary
                            : ColorsManager.greyColor,
                      ),
                ),
                onTap: () {
                  showResendButton ? onTap() : () {};
                },
              )
            : TextButton(
                child: Text(
                  textButton.tr(context),
                ),
                onPressed: () {
                  onTap();
                },
              ),
      ],
    );
  }
}
