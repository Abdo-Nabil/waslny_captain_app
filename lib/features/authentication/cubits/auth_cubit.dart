import 'package:email_validator/email_validator.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:waslny_captain/core/extensions/string_extension.dart';
import 'package:waslny_captain/features/authentication/services/models/captain_model.dart';
import 'package:waslny_captain/features/general/services/general_repo.dart';
import 'package:waslny_captain/resources/app_strings.dart';

import '../../../../core/error/failures.dart';
import '../../../../resources/constants_manager.dart';
import '../services/auth_repo.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepo authRepo;
  final GeneralRepo generalRepo;

  AuthCubit({
    required this.authRepo,
    required this.generalRepo,
  }) : super(AuthInitial());

  bool showLoginButton = false;
  bool showResendButton = false;
  //
  late final UserCredential userCred;

  static AuthCubit getIns(context) {
    return BlocProvider.of<AuthCubit>(context);
  }
  //
  // activeResendButton() {
  //   showResendButton = true;
  //   emit(ActiveResendButtonState());
  // }

  //
  //
  validateEmail(BuildContext context, String value) {
    if (value.isEmpty) {
      return AppStrings.emptyValue.tr(context);
    }
    final isValid = EmailValidator.validate(value);
    if (isValid) {
      return null;
    }
    return AppStrings.invalidEmail.tr(context);
  }

  validatePassword(BuildContext context, String value) {
    if (value.isEmpty) {
      return AppStrings.emptyValue.tr(context);
    }
    if (value.length < 5) {
      return AppStrings.passwordMustBe.tr(context);
    }
    return null;
  }

  //
  _handleFailure(Failure failure) {
    if (failure.runtimeType == OfflineFailure) {
      emit(EndLoadingStateWithError(AppStrings.internetConnectionError));
    } else if (failure.runtimeType == ServerFailure) {
      emit(EndLoadingStateWithError(AppStrings.someThingWentWrong));
    } else if (failure.runtimeType == WeakPasswordFailure) {
      emit(EndLoadingStateWithError(AppStrings.weakPassword));
    } else if (failure.runtimeType == EmailInUseFailure) {
      emit(EndLoadingStateWithError(AppStrings.emailInUse));
    } else if (failure.runtimeType == UserNotFoundFailure) {
      emit(EndLoadingStateWithError(AppStrings.userNotFound));
    } else if (failure.runtimeType == WrongPasswordFailure) {
      emit(EndLoadingStateWithError(AppStrings.wrongPassword));
    } else if (failure.runtimeType == CacheSavingFailure) {
      emit(EndLoadingStateWithError(AppStrings.savingTokenError));
    } else if (failure.runtimeType == InvalidEmailFailure) {
      emit(EndLoadingStateWithError(AppStrings.invalidEmail));
    }
  }

  Future createNewUser(CaptainModel captainModel) async {
    emit(StartLoadingState());
    final either1 = await authRepo.createUserWithEmailAndPassword(
        captainModel.email, captainModel.password);
    either1.fold(
      (failure) {
        _handleFailure(failure);
      },
      (credential) async {
        //
        final String captainId = credential.user!.uid;
        await generalRepo.setString(AppStrings.storedId, captainId);
        //
        final either2 = await authRepo.createCaptainAfterSign(
            captainModel.copyWith(captainId: captainId));
        either2.fold(
          (failure) async {
            _handleFailure(failure);
          },
          (success) async {
            final either3 = await generalRepo.setString(
                AppStrings.storedToken, '${credential.credential?.token}');
            either3.fold(
              (failure) {
                _handleFailure(failure);
              },
              (success) {
                emit(EndLoadingToHomeScreen());
              },
            );
          },
        );
      },
    );
  }

  Future login(
      String email, String password, GlobalKey<FormState> formKey) async {
    if (formKey.currentState!.validate()) {
      //
      emit(StartLoadingState());
      final either = await authRepo.signInWithEmailAndPassword(email, password);
      either.fold(
        (failure) {
          _handleFailure(failure);
        },
        (credential) async {
          //
          final String captainId = credential.user!.uid;
          await generalRepo.setString(AppStrings.storedId, captainId);
          //
          final either2 = await generalRepo.setString(
              AppStrings.storedToken, '${credential.credential?.token}');
          either2.fold(
            (failure) {
              _handleFailure(failure);
            },
            (success) {
              emit(EndLoadingToHomeScreen());
            },
          );
        },
      );
      //
    }
  }

  //

  //
  //
  bool isValidPhoneNumber(String value) {
    if (value.length == 10 &&
        (value.startsWith('10') ||
            value.startsWith('11') ||
            value.startsWith('12') ||
            value.startsWith('15'))) {
      return true;
    }
    return false;
  }

  phoneNumberValidator(String value) {
    if (isValidPhoneNumber(value)) {
      showLoginButton = true;
      emit(ButtonStateEnabled());
    } else {
      showLoginButton = false;
      emit(ButtonStateDisabled());
    }
  }

  String? validatePinCodeFields(BuildContext context, String value) {
    if (value.isEmpty) {
      return AppStrings.emptyValue.tr(context);
    } else if (value.length != ConstantsManager.pinCodesLength) {
      return AppStrings.enterAllDigits.tr(context);
    } else {
      return null;
    }
  }

  // String? validatePhoneNumberInRegisterMode(String? value) {
  //   if (value == null || value.isEmpty) {
  //     return AppStrings.enterYourPhone;
  //   } else if (!isValidPhoneNumber(value)) {
  //     return AppStrings.enterValidPhone;
  //   }
  //   return null;
  // }

  String? validateUsername(BuildContext context, String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.enterYourName.tr(context);
    }
    return null;
  }

  // Future listenForSms(BuildContext context, GlobalKey<FormState> formKey,
  //     TextEditingController otpController, mounted) async {
  //   try {
  //     otpController.text = (await AltSmsAutofill().listenForSms)!;
  //     if (!mounted) return;
  //     await AuthCubit.getIns(context)
  //         .verifySmsCode(otpController.text, formKey);
  //     debugPrint('code ${otpController.text}');
  //   } catch (e) {
  //     debugPrint('SMS Automatic fetching problem Problem :: $e');
  //     emit(SmsListeningException());
  //   }
  // }

  ///----------------------------------------------------------\\\

  // handleFailure(Failure failure) {
  //   if (failure.runtimeType == OfflineFailure) {
  //     emit(EndLoadingStateWithError(AppStrings.internetConnectionError));
  //   } else if (failure.runtimeType == ServerFailure) {
  //     emit(EndLoadingStateWithError(AppStrings.someThingWentWrong));
  //   } else if (failure.runtimeType == InvalidSmsFailure) {
  //     emit(EndLoadingStateWithSmsError());
  //   } else if (failure.runtimeType == CacheSavingFailure) {
  //     emit(EndLoadingStateWithError(AppStrings.savingTokenError));
  //   }
  // }

  // Future loginOrResendSms(String phoneNumber) async {
  //   emit(StartLoadingState());
  //   debugPrint(phoneNumber);
  //   await Future.delayed(const Duration(seconds: 3));
  //   final result = await authRepo.loginOrResendSms(phoneNumber);
  //   result.fold(
  //     (failure) {
  //       handleFailure(failure);
  //     },
  //     (success) {
  //       showResendButton = false;
  //       emit(EndLoadingToOtpScreen());
  //     },
  //   );
  // }

  // Future<bool> _saveToken() async {
  //   final token = await userCred.user?.getIdToken();
  //   if (token != null) {
  //     final either = await authRepo.setToken(token);
  //     return either.fold((failure) {
  //       handleFailure(failure);
  //       return false;
  //     }, (success) {
  //       return true;
  //     });
  //   } else {
  //     debugPrint('The token is nullllllllllll!');
  //     return false;
  //   }
  // }
  //
  // Future verifySmsCode(String smsCode, GlobalKey<FormState> formKey) async {
  //   if (formKey.currentState!.validate()) {
  //     emit(StartLoadingState());
  //     final result = await authRepo.verifySmsCode(smsCode);
  //     result.fold(
  //       (failure) {
  //         handleFailure(failure);
  //       },
  //       (userCredential) async {
  //         //
  //         userCred = userCredential;
  //         if (userCredential.additionalUserInfo!.isNewUser) {
  //           emit(EndLoadingToRegisterScreen());
  //         } else {
  //           final isSaved = await _saveToken();
  //           if (isSaved) {
  //             emit(EndLoadingToHomeScreen());
  //           }
  //         }
  //       },
  //     );
  //   }
  // }
  //
  // //Create New User
  // Future register(
  //   GlobalKey<FormState> formKey,
  //   TextEditingController username,
  // ) async {
  //   if (formKey.currentState!.validate()) {
  //     emit(StartLoadingState());
  //     await Future.delayed(const Duration(seconds: 3));
  //     final result = await authRepo.createUser(username.text);
  //     result.fold(
  //       (failure) {
  //         handleFailure(failure);
  //       },
  //       (success) async {
  //         final isSaved = await _saveToken();
  //         if (isSaved) {
  //           emit(EndLoadingToHomeScreen());
  //         }
  //       },
  //     );
  //   }
  // }

  // Future getUserData(String userId) async {
  //     final result = await getUserDataUseCase.call(userId);
  //     result.fold(
  //       (failure) {
  //         handleFailure(failure);
  //       },
  //       (success) async {
  //         emit(EndLoadingToHomeScreen());
  //       },
  //     );
  //   }

}
