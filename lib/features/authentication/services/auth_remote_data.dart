import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../../../core/error/exceptions.dart';
import '../../../resources/app_strings.dart';
import '../../../resources/constants_manager.dart';
import './models/user_model.dart';

class AuthRemoteData {
  String? verificationIdentity;
  late String phone;
  late String userId;

  //
  Future loginOrResendSms(String phoneNumber) async {
    String temp = AppStrings.countryCode + phoneNumber;
    phone = temp;
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: temp,
        timeout: const Duration(seconds: ConstantsManager.smsTimer),
        //
        verificationFailed: (FirebaseAuthException e) {
          if (e.code == 'invalid-phone-number') {
            debugPrint('The provided phone number is not valid ::::');
          }
        },
        codeSent: (String verificationId, int? resendToken) {
          // Update the UI - wait for the user to enter the SMS code
          verificationIdentity = verificationId;
          debugPrint(
              'Code hase been sent to ${AppStrings.countryCode + phoneNumber}');
          debugPrint('resend token :: $resendToken');
        },
        //
        verificationCompleted: (PhoneAuthCredential credential) {
          debugPrint('Verification Completed ::  $credential');
        },
        //
        codeAutoRetrievalTimeout: (String verificationId) {
          debugPrint('Code Auto Retrieval Timeout :: $verificationId');
        },
      );
    } catch (e) {
      debugPrint('auth remote data loginOrResendSms ServerException:: $e');
      throw ServerException();
    }
  }

  Future<UserCredential> verifySmsCode(String smsCode) async {
    PhoneAuthCredential credential;
    if (verificationIdentity == null) {
      throw ServerException();
    } else {
      credential = PhoneAuthProvider.credential(
        verificationId: verificationIdentity!,
        smsCode: smsCode,
      );
    }
    try {
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      userId = userCredential.user!.uid;

      return userCredential;
    } catch (e) {
      debugPrint('auth remote data verifySmsCode InvalidSmsException:: $e');
      throw InvalidSmsException();
    }
  }

  Future createUser(String username) async {
    final db = FirebaseFirestore.instance;
    final UserModel userModel = UserModel(
      userId: userId,
      phoneNumber: phone,
      name: username,
    );
    try {
      await db.collection(AppStrings.usersCollection).add(userModel.toJson());
    } catch (e) {
      debugPrint('auth remote data create user Exception :: $e');
      throw ServerException();
    }
  }

  Future<UserModel> getUserData(String userId) async {
    final db = FirebaseFirestore.instance;
    try {
      final jsonData = await db.collection(AppStrings.usersCollection).get();
      for (var doc in jsonData.docs) {
        final UserModel user = UserModel.fromJson(doc.data());
        if (user.userId == userId) {
          return user;
        }
      }
      debugPrint('User Not Found!');
      throw ServerException();
    } catch (e) {
      debugPrint('Get user Exception :: $e');
      throw ServerException();
    }
  }
}
