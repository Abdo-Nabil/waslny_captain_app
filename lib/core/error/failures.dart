import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {}

class OfflineFailure extends Failure {
  @override
  List<Object?> get props => [];
}

class ServerFailure extends Failure {
  @override
  List<Object?> get props => [];
}

class EmptyCacheFailure extends Failure {
  @override
  List<Object?> get props => [];
}

class GetCacheFailure extends Failure {
  @override
  List<Object?> get props => [];
}

class CacheSavingFailure extends Failure {
  @override
  List<Object?> get props => [];
}

class LoginVerificationFailure extends Failure {
  @override
  List<Object?> get props => [];
}

class InvalidSmsFailure extends Failure {
  @override
  List<Object?> get props => [];
}

class LocationPermissionFailure extends Failure {
  @override
  List<Object?> get props => [];
}

class TimeLimitFailure extends Failure {
  @override
  List<Object?> get props => [];
}

class LocationDisabledFailure extends Failure {
  @override
  List<Object?> get props => [];
}

class WeakPasswordFailure extends Failure {
  @override
  List<Object?> get props => [];
}

class EmailInUseFailure extends Failure {
  @override
  List<Object?> get props => [];
}

class UserNotFoundFailure extends Failure {
  @override
  List<Object?> get props => [];
}

class WrongPasswordFailure extends Failure {
  @override
  List<Object?> get props => [];
}

class InvalidEmailFailure extends Failure {
  @override
  List<Object?> get props => [];
}

class CallNumberFailure extends Failure {
  @override
  List<Object?> get props => [];
}
