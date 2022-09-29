import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:waslny_captain/core/extensions/string_extension.dart';
import 'package:waslny_captain/core/util/navigator_helper.dart';
import 'package:waslny_captain/core/widgets/add_vertical_space.dart';
import 'package:waslny_captain/core/widgets/custom_form_field.dart';
import 'package:waslny_captain/features/authentication/presentation/register_screen.dart';
import 'package:waslny_captain/features/authentication/presentation/widgets/custom_button.dart';
import 'package:waslny_captain/features/authentication/presentation/widgets/image_with_logo.dart';
import 'package:waslny_captain/features/authentication/presentation/widgets/login_or_register_text.dart';
import 'package:waslny_captain/features/authentication/presentation/widgets/text_row.dart';
import 'package:waslny_captain/features/home_screen/presentation/home_screen.dart';
import 'package:waslny_captain/resources/app_strings.dart';
import 'package:waslny_captain/resources/app_margins_paddings.dart';

import '../../../core/util/dialog_helper.dart';
import '../../../core/widgets/password_form_field.dart';
import '../../../resources/colors_manager.dart';
import '../cubits/auth_cubit.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
          NavigatorHelper.pushReplacement(
            context,
            const HomeScreen(),
          );
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
                const LoginOrRegisterText(AppStrings.loginAsACaptain),
                const AddVerticalSpace(AppPadding.p20),
                Padding(
                  padding: const EdgeInsets.all(AppPadding.p16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        CustomFormFiled(
                          context: context,
                          controller: _emailController,
                          label: AppStrings.email,
                          prefixWidget: const Icon(Icons.mail_outline),
                          validate: (value) {
                            return AuthCubit.getIns(context)
                                .validateEmail(context, value);
                          },
                        ),
                        const AddVerticalSpace(AppPadding.p20),
                        PasswordFormFiled(
                          context: context,
                          controller: _passwordController,
                          label: AppStrings.password,
                          validate: (value) {
                            return AuthCubit.getIns(context)
                                .validatePassword(context, value);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                CustomButton(
                  text: AppStrings.login.tr(context),
                  onTap: () async {
                    await AuthCubit.getIns(context).login(_emailController.text,
                        _passwordController.text, _formKey);
                  },
                ),
                TextRow(
                  text: AppStrings.dontHaveAccount,
                  textButton: AppStrings.registerNow,
                  onTap: () {
                    NavigatorHelper.pushAndRemoveUntil(
                      context,
                      const RegisterScreen(),
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
