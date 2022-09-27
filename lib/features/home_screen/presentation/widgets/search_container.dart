import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../core/widgets/custom_form_field.dart';
import '../../../../resources/app_margins_paddings.dart';
import '../../../../resources/colors_manager.dart';
import '../../../localization/presentation/cubits/localization_cubit.dart';
import '../../cubits/home_screen_cubit.dart';

class SearchContainer extends StatefulWidget {
  const SearchContainer({
    required this.label,
    required this.controller,
    Key? key,
  }) : super(key: key);
  final String label;
  final TextEditingController controller;
  @override
  State<SearchContainer> createState() => _SearchContainerState();
}

class _SearchContainerState extends State<SearchContainer> {
  final _formKey = GlobalKey<FormState>();
  bool isCurrentlySearching = false;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //
    final bool isEnglishLocale =
        LocalizationCubit.getIns(context).isEnglishLocale();
    //
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(AppPadding.p20),
          bottomRight: Radius.circular(AppPadding.p20),
        ),
        color: ColorsManager.greyBlack,
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          0,
          AppPadding.p40,
          0,
          AppPadding.p16,
        ),
        child: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.arrow_back),
            ),
            Expanded(
              child: Form(
                key: _formKey,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: AppPadding.p16),
                  child: CustomFormFiled(
                    context: context,
                    autoFocus: true,
                    controller: widget.controller,
                    label: widget.label,
                    iconWidget: const Icon(Icons.search),
                    onFieldSubmitted: (value) async {
                      await _onSearch(value, isEnglishLocale);
                    },
                    validate: (value) {
                      return HomeScreenCubit.getIns(context)
                          .validateField(context, value);
                    },
                    onChange: (String value) async {
                      _onChange(value, isEnglishLocale);
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future _onSearch(String value, bool isEnglishLocale) async {
    if (!isCurrentlySearching) {
      isCurrentlySearching = true;
      await HomeScreenCubit.getIns(context).searchForPlace(
        _formKey,
        value,
        isEnglishLocale,
      );
      isCurrentlySearching = false;
    }
  }

  _onChange(String value, bool isEnglishLocale) async {
    if (_timer != null) {
      _timer?.cancel();
    }
    _timer = Timer(
      Duration(milliseconds: value.isEmpty ? 0 : 2000),
      () async {
        if (value.length > 1) {
          await _onSearch(value, isEnglishLocale);
        } else if (value.isEmpty) {
          HomeScreenCubit.getIns(context).emitInitialState();
        }
      },
    );
  }
}
