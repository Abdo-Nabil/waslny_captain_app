import 'package:flutter/material.dart';

import '../../../../resources/app_margins_paddings.dart';

class Button extends StatelessWidget {
  final String text;
  final bool showButton;
  final Function onTap;
  final double padding;

  const Button(
      {required this.text,
      required this.onTap,
      this.showButton = true,
      this.padding = AppPadding.p16,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(padding),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: showButton
              ? () {
                  onTap();
                }
              : null,
          child: Text(text),
        ),
      ),
    );
  }
}
