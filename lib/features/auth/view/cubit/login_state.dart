import '../../data/models/sign_up_models.dart';

abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final ResponseModel response;

  LoginSuccess(this.response);
}

class LoginError extends LoginState {
  final String errorMessage;
  LoginError(this.errorMessage);
}

class LoginPasswordVisibilityChanged extends LoginState {
  final bool isObscure;
  LoginPasswordVisibilityChanged(this.isObscure);
}

class ForgotPasswordLoading extends LoginState {}

class ForgotPasswordSuccess extends LoginState {}

class ForgotPasswordError extends LoginState {
  final String errorMessage;
  ForgotPasswordError(this.errorMessage);
}

class OtpVerificationLoading extends LoginState {}

class OtpVerificationSuccess extends LoginState {}

class OtpVerificationError extends LoginState {
  final String errorMessage;
  OtpVerificationError(this.errorMessage);
}

class LoginUpdated extends LoginState {}

class ResendOtpCodeLoading extends LoginState {}

class ResendOtpCodeSuccess extends LoginState {}

class ResendOtpCodeError extends LoginState {
  final String errorMessage;
  ResendOtpCodeError(this.errorMessage);
}
