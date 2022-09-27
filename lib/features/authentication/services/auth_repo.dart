import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:waslny_captain/features/authentication/services/auth_local_data.dart';
import 'package:waslny_captain/features/authentication/services/auth_remote_data.dart';

import '../../../core/error/exceptions.dart';
import '../../../core/error/failures.dart';
import '../../../core/network/network_info.dart';
import './models/user_model.dart';

class AuthRepo {
  final NetworkInfo networkInfo;
  final AuthRemoteData authRemoteData;
  final AuthLocalData authLocalData;
  AuthRepo({
    required this.networkInfo,
    required this.authRemoteData,
    required this.authLocalData,
  });

  //-------------Auth remote data--------------------

  Future<Either<Failure, dynamic>> loginOrResendSms(String phoneNumber) async {
    final bool isConnected = await networkInfo.isConnected;
    if (isConnected) {
      //
      try {
        await authRemoteData.loginOrResendSms(phoneNumber);
        return const Right(unit);
      } on ServerException {
        return Left(ServerFailure());
      }
      //
    } else {
      return Left(OfflineFailure());
    }
  }

  Future<Either<Failure, UserCredential>> verifySmsCode(String smsCode) async {
    final bool isConnected = await networkInfo.isConnected;
    if (isConnected) {
      //
      try {
        final UserCredential userCredential =
            await authRemoteData.verifySmsCode(smsCode);
        return Right(userCredential);
      } on InvalidSmsException {
        return Left(InvalidSmsFailure());
      } on ServerException {
        return Left(ServerFailure());
      }
      //
    } else {
      return Left(OfflineFailure());
    }
  }

  Future<Either<Failure, Unit>> createUser(String userName) async {
    final bool isConnected = await networkInfo.isConnected;
    if (isConnected) {
      //
      try {
        await authRemoteData.createUser(userName);
        return Future.value(const Right(unit));
      } on ServerException {
        return Left(ServerFailure());
      }
      //
    } else {
      return Left(OfflineFailure());
    }
  }

  Future<Either<Failure, UserModel>> getUserData(String userId) async {
    final bool isConnected = await networkInfo.isConnected;
    if (isConnected) {
      //
      try {
        final UserModel userModel = await authRemoteData.getUserData(userId);
        return Right(userModel);
      } on ServerException {
        return Left(ServerFailure());
      }
      //
    } else {
      return Left(OfflineFailure());
    }
  }

  //-------------Auth local data--------------------

  Either<Failure, String?> getToken() {
    final String? result = authLocalData.getToken();
    return Right(result);
  }

  Future<Either<Failure, Unit>> setToken(String token) async {
    try {
      await authLocalData.setToken(token);
      return Future.value(const Right(unit));
    } on CacheSavingException {
      return Left(CacheSavingFailure());
    }
  }
}
