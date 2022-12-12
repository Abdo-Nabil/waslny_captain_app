import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../../../core/error/exceptions.dart';

import './models/captain_model.dart';

class AuthRemoteData {
  UserCredential? userCredential;
  late String phone;
  late String userId;

  //
  //
  Future<UserCredential> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      userCredential = credential;
      return credential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        debugPrint('The password provided is too weak.');
        throw WeakPasswordException();
      } else if (e.code == 'email-already-in-use') {
        debugPrint('The account already exists for that email.');
        throw EmailInUseException();
      } else if (e.code == 'invalid-email') {
        debugPrint('the email address is not valid');
        throw InvalidEmailException();
      } else {
        throw ServerException();
      }
    } catch (e) {
      debugPrint(
          'createUserWithEmailAndPassword :: Auth remote repo :: Exception :: $e');
      throw ServerException();
    }
  }

  Future<UserCredential> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      userCredential = credential;
      return credential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        debugPrint('No user found for that email.');
        throw UserNotFoundException();
      } else if (e.code == 'wrong-password') {
        debugPrint('Wrong password provided for that user.');
        throw WrongPasswordException();
      } else if (e.code == 'invalid-email') {
        debugPrint('the email address is not valid');
        throw InvalidEmailException();
      } else {
        throw ServerException();
      }
    } catch (e) {
      debugPrint(
          'signInWithEmailAndPassword :: Auth remote repo :: Exception :: $e');
      throw ServerException();
    }
  }

  Future createCaptainAfterSign(CaptainModel captainModel) async {
    try {
      final db = FirebaseFirestore.instance;
      // await db.collection('captains').add(captainModel.toJson());
      await db
          .collection('captains')
          .doc(captainModel.captainId)
          .set(captainModel.toJson());
    } catch (e) {
      debugPrint(
          'createCaptainAfterSign :: Auth remote repo :: Exception :: $e');
      throw ServerException();
    }
  }

  // Future deleteCaptainFromAuthList() async {
  //   try {
  //     await userCredential?.user?.delete();
  //   } catch (e) {
  //     debugPrint(
  //         'deleteCaptainFromAuthList :: Auth remote repo :: Exception :: $e');
  //     throw ServerException();
  //   }
  // }
  //
  //
  //
  /* Future loginOrResendSms(String phoneNumber) async {
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
  }*/
}
