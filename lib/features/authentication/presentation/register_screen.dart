import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:waslny_captain/core/extensions/string_extension.dart';
import 'package:waslny_captain/core/util/dialog_helper.dart';
import 'package:waslny_captain/features/authentication/presentation/widgets/car_form.dart';
import 'package:waslny_captain/features/authentication/presentation/widgets/personal_form.dart';
import 'package:waslny_captain/features/authentication/presentation/widgets/security_form.dart';
import 'package:waslny_captain/features/authentication/services/models/captain_model.dart';
import 'package:waslny_captain/features/home_screen/presentation/home_screen.dart';

import '../../../core/util/navigator_helper.dart';
import '../../../resources/app_strings.dart';
import '../../../resources/colors_manager.dart';
import '../cubits/auth_cubit.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  //
  final securityFormKey = GlobalKey<FormState>();
  final personalFormKey = GlobalKey<FormState>();
  final carFormKey = GlobalKey<FormState>();
  //
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController rePasswordController = TextEditingController();
  //
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  //
  final TextEditingController carModelController = TextEditingController();
  final TextEditingController plateNumberController = TextEditingController();
  final TextEditingController carColorController = TextEditingController();
  final TextEditingController productionDateController =
      TextEditingController();
  final TextEditingController numOfPassengersController =
      TextEditingController();

  //
  final introKey = GlobalKey<IntroductionScreenState>();
  //
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    rePasswordController.dispose();
    nameController.dispose();
    phoneController.dispose();
    ageController.dispose();
    genderController.dispose();
    carModelController.dispose();
    plateNumberController.dispose();
    carColorController.dispose();
    productionDateController.dispose();
    numOfPassengersController.dispose();
    super.dispose();
  }

  //
  @override
  Widget build(BuildContext context) {
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
          //TODO: hereeeeeeeeeeee
          resizeToAvoidBottomInset: false,
          backgroundColor: ColorsManager.greyBlack,
          body: IntroductionScreen(
            key: introKey,
            globalBackgroundColor: ColorsManager.greyBlack,
            dotsDecorator: DotsDecorator(
              activeColor: Theme.of(context).colorScheme.primary,
              color: Theme.of(context).primaryColorLight,
              activeSize: const Size.square(12.5),
            ),
            next: TextButton(
              child: Text(
                AppStrings.next.tr(context),
              ),
              onPressed: () {
                _onNext();
              },
            ),
            showBackButton: true,
            back: TextButton(
              child: Text(
                AppStrings.back.tr(context),
              ),
              onPressed: () {
                _onBack();
              },
            ),
            done: TextButton(
              child: Text(
                AppStrings.done.tr(context),
              ),
              onPressed: () async {
                await _onDone();
              },
            ),
            onDone: () {},
            pages: [
              PageViewModel(
                title: '',
                bodyWidget: SecurityForm(
                  securityFormKey: securityFormKey,
                  emailController: emailController,
                  passwordController: passwordController,
                  rePasswordController: rePasswordController,
                ),
              ),
              PageViewModel(
                title: '',
                bodyWidget: PersonalForm(
                  personalFormKey: personalFormKey,
                  nameController: nameController,
                  phoneController: phoneController,
                  ageController: ageController,
                  genderController: genderController,
                ),
              ),
              PageViewModel(
                title: '',
                bodyWidget: CarForm(
                  carFormKey: carFormKey,
                  carModelController: carModelController,
                  plateNumberController: plateNumberController,
                  carColorController: carColorController,
                  productionDateController: productionDateController,
                  numOfPassengersController: numOfPassengersController,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _onBack() {
    introKey.currentState?.controller.previousPage(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeIn,
    );
  }

  _onNext() {
    final currentPage = introKey.currentState?.controller.page;
    if (currentPage == 0.0) {
      if (securityFormKey.currentState!.validate()) {
        introKey.currentState?.controller.nextPage(
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeIn,
        );
      }
    } else if (currentPage == 1.0) {
      if (personalFormKey.currentState!.validate()) {
        introKey.currentState?.controller.nextPage(
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeIn,
        );
      }
    }
  }

  _onDone() async {
    if (securityFormKey.currentState!.validate() &&
        personalFormKey.currentState!.validate() &&
        carFormKey.currentState!.validate()) {
      await AuthCubit.getIns(context).createNewUser(
        CaptainModel(
          email: emailController.text,
          password: passwordController.text,
          name: nameController.text,
          phone: '+20${phoneController.text}',
          age: ageController.text,
          gender: genderController.text,
          carModel: carModelController.text,
          plateNumber: plateNumberController.text,
          carColor: carColorController.text,
          productionDate: productionDateController.text,
          numOfPassengers: numOfPassengersController.text,
        ),
      );
    } else {
      DialogHelper.messageDialog(context, AppStrings.emptyValue.tr(context));
    }
  }
}

// body: SingleChildScrollView(
//   child: Column(
//     children: [
//       // const ImageWithLogo(),
//       const AddVerticalSpace(AppPadding.p100),
//       const LoginOrRegisterText(AppStrings.registerANewCaptain),
//       const AddVerticalSpace(AppPadding.p20),
//       Padding(
//         padding: const EdgeInsets.all(AppPadding.p16),
//         child: Form(
//           key: _formKey1,
//           child: Column(
//             children: [
//               CustomFormFiled(
//                 context: context,
//                 controller: _nameController,
//                 label: AppStrings.username,
//                 prefixWidget: const Icon(
//                   Icons.person,
//                 ),
//                 validate: (value) {
//                   // return AuthCubit.getIns(context)
//                   //     .validateUsername(context, value);
//                   return 'enter your name';
//                 },
//               ),
//               const AddVerticalSpace(AppPadding.p16),
//               ],
//           ),
//         ),
//       ),
//       BlocBuilder<AuthCubit, AuthState>(
//         builder: (context, state) {
//           return CustomButton(
//             text: AppStrings.register.tr(context),
//             onTap: () async {
//               // await AuthCubit.getIns(context).register(
//               //   _formKey,
//               //   _nameController,
//               // );
//               _formKey.currentState?.widget;
//             },
//           );
//         },
//       ),
//       TextRow(
//         text: AppStrings.alreadyHaveAccount,
//         textButton: AppStrings.loginNow,
//         onTap: () {
//           NavigatorHelper.pushAndRemoveUntil(
//             context,
//             const LSizedBoxn(),
//           );
//         },
//       ),
//     ],
//   ),
// ),
// body: IntroductionScreen(
//   globalBackgroundColor: ColorsManager.greyBlack,
//   dotsDecorator: DotsDecorator(
//     activeColor: Theme.of(context).colorScheme.primary,
//     color: Theme.of(context).primaryColorLight,
//     activeSize: const Size.square(15),
//   ),
//   next: CustomButton(onTap: () {}, text: 'zzz'),
//   key: introKey,
//   pages: [
//     PageViewModel(
//       title: "Title of first page",
//       bodyWidget: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: const [
//           Text(" to edit a post"),
//           Text(" to edit a post"),
//           Text(" to edit a post"),
//           Text(" to edit a post"),
//           Text(" to edit a post"),
//           Text(" to edit a post"),
//           Text(" to edit a post"),
//           Text(" to edit a post"),
//           Text(" to edit a post"),
//         ],
//       ),
//     ),
//     PageViewModel(
//       title: "Title of first page",
//       bodyWidget: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: const [
//           Text("Click on "),
//           Icon(Icons.edit),
//           Text(" to edit a post"),
//         ],
//       ),
//       image: const Center(child: Icon(Icons.android)),
//     ),
//   ],
//   done: const Text("Done",
//       style: TextStyle(fontWeight: FontWeight.w600)),
//   onDone: () {
//     // When done button is press
//   },
//   onChange: (index) {
//     setState(() {
//       pageIndex = index;
//     });
//   },
// ),
