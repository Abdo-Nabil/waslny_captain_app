import 'package:flutter/material.dart';
import 'package:waslny_captain/core/extensions/string_extension.dart';

import '../../../../resources/colors_manager.dart';

class LoginOrRegisterText extends StatelessWidget {
  final String text;
  const LoginOrRegisterText(this.text, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text.tr(context),
      style: Theme.of(context)
          .textTheme
          .headline5
          ?.copyWith(color: ColorsManager.greyColor),
    );
  }
}
