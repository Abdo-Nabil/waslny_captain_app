import 'package:alt_sms_autofill/alt_sms_autofill.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:waslny_captain/core/extensions/context_extension.dart';
import 'package:waslny_captain/core/extensions/string_extension.dart';
import 'package:waslny_captain/core/util/navigator_helper.dart';
import 'package:waslny_captain/core/util/toast_helper.dart';
import 'package:waslny_captain/core/widgets/add_vertical_space.dart';
import 'package:waslny_captain/features/authentication/presentation/register_screen.dart';
import 'package:waslny_captain/features/authentication/presentation/widgets/button.dart';
import 'package:waslny_captain/features/authentication/presentation/widgets/text_row.dart';
import 'package:waslny_captain/features/authentication/presentation/widgets/timer_widget.dart';
import 'package:waslny_captain/features/localization/presentation/cubits/localization_cubit.dart';
import 'package:waslny_captain/resources/app_margins_paddings.dart';
import 'package:waslny_captain/resources/constants_manager.dart';
import 'package:waslny_captain/resources/image_assets.dart';

import '../../../core/util/dialog_helper.dart';
import '../../../resources/app_strings.dart';
import '../../home_screen/presentation/home_screen.dart';
import '../cubits/auth_cubit.dart';

class OtpScreen extends StatefulWidget {
  final String phoneNumber;
  const OtpScreen({
    required this.phoneNumber,
    Key? key,
  }) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final TextEditingController _otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    AltSmsAutofill().unregisterListener();
    _otpController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    ToastHelper.initializeToast(context);
    AuthCubit.getIns(context)
        .listenForSms(context, _formKey, _otpController, mounted);
    super.initState();
  }

  // initSmsListener() async {
  //   try {
  //     _otpController.text = (await AltSmsAutofill().listenForSms)!;
  //     if (!mounted) return;
  //     await AuthCubit.getIns(context)
  //         .verifySmsCode(_otpController.text, _formKey);
  //     debugPrint('code ${_otpController.text}');
  //   } catch (e) {
  //     debugPrint('SMS Automatic fetching problem Problem :: $e');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    //
    final bool isEnglishLocale =
        LocalizationCubit.getIns(context).isEnglishLocale();
    //
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is StartLoadingState) {
          DialogHelper.loadingDialog(context);
        }
        //
        else if (state is EndLoadingStateWithError) {
          Navigator.of(context).pop();
          DialogHelper.messageDialog(context, state.msg.tr(context));
        }
        //
        else if (state is EndLoadingStateWithSmsError) {
          Navigator.of(context).pop();
          ToastHelper.showToast(
              context, AppStrings.invalidSMS.tr(context), ToastStates.error);
        }
        //
        else if (state is SmsListeningException) {
          DialogHelper.messageDialog(
              context, AppStrings.someThingWentWrong.tr(context));
        }
        //
        else if (state is EndLoadingToOtpScreen) {
          Navigator.of(context).pop();
          NavigatorHelper.pushAndRemoveUntil(
            context,
            OtpScreen(phoneNumber: widget.phoneNumber),
            hasAnimation: false,
          );
        }
        //
        else if (state is EndLoadingToHomeScreen) {
          Navigator.of(context).pop();
          NavigatorHelper.pushAndRemoveUntil(
            context,
            const HomeScreen(),
          );
        }
        //
        else if (state is EndLoadingToRegisterScreen) {
          Navigator.of(context).pop();
          NavigatorHelper.pushAndRemoveUntil(
            context,
            const RegisterScreen(),
          );
        }
        //
      },
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(AppPadding.p16),
              child: Column(
                children: [
                  AddVerticalSpace(context.height * 0.03),
                  Image.asset(ImageAssets.authOtpImgPath),
                  AddVerticalSpace(context.height * 0.03),
                  Text(
                    AppStrings.phoneNumberVerification.tr(context),
                    style: Theme.of(context).textTheme.headline5?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const AddVerticalSpace(AppPadding.p16),
                  Text.rich(
                    TextSpan(
                      text: AppStrings.enterTheCodeSent.tr(context),
                      style: Theme.of(context).textTheme.subtitle1?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.normal,
                          ),
                      children: <TextSpan>[
                        TextSpan(
                          text: isEnglishLocale
                              ? ' ${AppStrings.stars}${widget.phoneNumber.substring(7)}'
                              : ' ${widget.phoneNumber.substring(7)}${AppStrings.stars}',
                          style:
                              Theme.of(context).textTheme.subtitle1?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  const AddVerticalSpace(AppPadding.p28),
                  Form(
                    key: _formKey,
                    child: PinCodeTextField(
                      errorTextDirection: isEnglishLocale
                          ? TextDirection.ltr
                          : TextDirection.rtl,
                      autoDisposeControllers:
                          false, //without that line the dispose an error occurred
                      appContext: context,
                      controller: _otpController,
                      length: ConstantsManager.pinCodesLength,
                      obscureText: false,
                      animationType: AnimationType.fade,
                      animationDuration: const Duration(milliseconds: 300),
                      // enableActiveFill: true,
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(AppPadding.p16),
                        fieldHeight: 50,
                        fieldWidth: 50,
                      ),
                      // errorAnimationController: errorController,
                      // controller: textEditingController,
                      onCompleted: (v) async {
                        // debugPrint("Completed");
                        // AuthCubit.getIns(context).verifySmsCode(v);
                      },
                      validator: (_) {
                        return AuthCubit.getIns(context).validatePinCodeFields(
                            context, _otpController.text);
                      },
                      onChanged: (_) {
                        // debugPrint("onChanged!");
                      },
                      errorTextSpace: AppPadding.p30,
                      beforeTextPaste: (text) {
                        // print("Allowing to paste $text");
                        //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                        //but you can show anything you want here, like your pop up saying wrong paste format or etc
                        return true;
                      },
                    ),
                  ),
                  // const AddVerticalSpace(AppPadding.p16),
                  Button(
                    text: AppStrings.verify.tr(context),
                    padding: AppPadding.p10,
                    onTap: () async {
                      await AuthCubit.getIns(context)
                          .verifySmsCode(_otpController.text, _formKey);
                    },
                  ),
                  const AddVerticalSpace(AppPadding.p8),
                  const TimerWidget(),
                  const AddVerticalSpace(AppPadding.p12),
                  TextRow(
                    isResendButton: true,
                    text: AppStrings.didntRecieveTheCode,
                    textButton: AppStrings.resend,
                    onTap: () async {
                      await AuthCubit.getIns(context)
                          .loginOrResendSms(_otpController.text);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
