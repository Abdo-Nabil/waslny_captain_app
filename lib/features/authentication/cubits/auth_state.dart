part of 'auth_cubit.dart';

@immutable
abstract class AuthState extends Equatable {}

class AuthInitial extends AuthState {
  @override
  List<Object?> get props => [];
}

class ButtonStateEnabled extends AuthState {
  @override
  List<Object?> get props => [];
}

class ButtonStateDisabled extends AuthState {
  @override
  List<Object?> get props => [];
}

class EndLoadingStateAndNavigate extends AuthState {
  @override
  List<Object?> get props => [];
}

/////////////////////////////
class StartLoadingState extends AuthState {
  @override
  List<Object?> get props => [];
}

class EndLoadingStateWithError extends AuthState {
  final String msg;
  EndLoadingStateWithError(this.msg);
  @override
  List<Object?> get props => [msg];
}

class EndLoadingToHomeScreen extends AuthState {
  @override
  List<Object?> get props => [];
}

class EndLoadingToRegisterScreen extends AuthState {
  @override
  List<Object?> get props => [];
}
