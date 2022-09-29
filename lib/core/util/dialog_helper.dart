import 'package:flutter/material.dart';
import 'package:waslny_captain/core/extensions/context_extension.dart';
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

  //foe only String searches
  static Future selectWithSearchDialog(
    BuildContext context, {
    required String title,
    required String searchHint,
    required List list,
    required TextEditingController controller,
  }) {
    List searchList = list;
    return showDialog(
      context: context,
      // barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Container(
            width: context.width * 0.95,
            constraints: BoxConstraints(
              maxHeight: context.height * 0.4,
            ),
            child: StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  children: [
                    TextField(
                      decoration: InputDecoration(
                        label: Text(searchHint),
                      ),
                      onChanged: (value) {
                        setState(
                          () {
                            searchList = list
                                .where((element) =>
                                    element.toString().toLowerCase().contains(
                                          value.toString().toLowerCase(),
                                        ))
                                .toList();
                          },
                        );
                      },
                    ),
                    searchList.isEmpty
                        ? Expanded(
                            child: Center(
                              child: Text(AppStrings.notFound.tr(context)),
                            ),
                          )
                        : Expanded(
                            child: ListView.builder(
                              itemCount: searchList.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title: Text('${searchList[index]}'),
                                  onTap: () {
                                    controller.text =
                                        searchList[index].toString();
                                    Navigator.of(context).pop();
                                  },
                                );
                              },
                            ),
                          ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  static Future selectDialog(
    BuildContext context, {
    required String title,
    required List list,
    required TextEditingController controller,
    required double height,
    List<Widget>? leadingListWidgets,
  }) {
    return showDialog(
      context: context,
      // barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Container(
            width: context.width * 0.95,
            constraints: BoxConstraints(
              maxHeight: height,
            ),
            child: StatefulBuilder(
              builder: (context, setState) {
                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: list.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text('${list[index]}'),
                            leading: leadingListWidgets != null
                                ? leadingListWidgets[index]
                                : null,
                            onTap: () {
                              controller.text = list[index].toString();
                              Navigator.of(context).pop();
                            },
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }
}
