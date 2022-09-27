import 'package:flutter/material.dart';
import 'package:waslny_captain/core/extensions/string_extension.dart';

import '../../resources/app_strings.dart';

class DialogHelper {
  static Future loadingDialog(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(AppStrings.loading.tr(context)),
              const CircularProgressIndicator(),
            ],
          ),
        );
      },
    );
  }

  static Future messageDialog(BuildContext context, String msg) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text(AppStrings.alert.tr(context)),
          content: Text(msg),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(AppStrings.ok.tr(context)))
          ],
        );
      },
    );
  }

  static Future messageWithActionDialog(
      BuildContext context, String msg, Function onOkButton) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text(AppStrings.alert.tr(context)),
          content: Text(msg),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await onOkButton();
              },
              child: Text(
                AppStrings.ok.tr(context),
              ),
            )
          ],
        );
      },
    );
  }
}
