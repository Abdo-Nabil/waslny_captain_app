import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:waslny_captain/core/extensions/string_extension.dart';
import 'package:waslny_captain/core/util/dialog_helper.dart';
import 'package:waslny_captain/features/authentication/presentation/widgets/button.dart';
import 'package:waslny_captain/features/authentication/presentation/widgets/image_with_logo.dart';
import 'package:waslny_captain/features/authentication/presentation/widgets/login_or_register_text.dart';
import 'package:waslny_captain/features/home_screen/presentation/home_screen.dart';

import '../../../core/util/navigator_helper.dart';
import '../../../core/widgets/add_vertical_space.dart';
import '../../../core/widgets/custom_form_field.dart';
import '../../../resources/app_strings.dart';
import '../../../resources/colors_manager.dart';
import '../../../resources/app_margins_paddings.dart';
import '../cubits/auth_cubit.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  //
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  //
  @override
  Widget build(BuildContext context) {
    //
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is StartLoadingState) {
          DialogHelper.loadingDialog(context);
        }
        //
        else if (state is EndLoadingToHomeScreen) {
          Navigator.of(context).pop();
          NavigatorHelper.pushAndRemoveUntil(context, const HomeScreen());
        }
        //
        else if (state is EndLoadingStateWithError) {
          Navigator.of(context).pop();
          DialogHelper.messageDialog(context, state.msg.tr(context));
        }
      },
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          backgroundColor: ColorsManager.greyBlack,
          body: SingleChildScrollView(
            child: Column(
              children: [
                const ImageWithLogo(),
                const LoginOrRegisterText(AppStrings.registerANewUser),
                const AddVerticalSpace(AppPadding.p20),
                Padding(
                  padding: const EdgeInsets.all(AppPadding.p16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        CustomFormFiled(
                          context: context,
                          controller: _nameController,
                          label: AppStrings.username,
                          iconWidget: const Icon(
                            Icons.person,
                          ),
                          validate: (value) {
                            return AuthCubit.getIns(context)
                                .validateUsername(context, value);
                          },
                        ),
                        const AddVerticalSpace(AppPadding.p16),
                      ],
                    ),
                  ),
                ),
                BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, state) {
                    return Button(
                      text: AppStrings.register,
                      onTap: () async {
                        await AuthCubit.getIns(context).register(
                          _formKey,
                          _nameController,
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
