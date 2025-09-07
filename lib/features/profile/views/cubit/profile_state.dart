import 'package:image_picker/image_picker.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final bool isPasswordVisible;
  final bool isEmailValid;
  final XFile? profileImage;
  final String? serverImageUrl;

  ProfileLoaded({
    required this.isPasswordVisible,
    required this.isEmailValid,
    this.profileImage,
    this.serverImageUrl,
  });
  ProfileLoaded copyWith({
    bool? isPasswordVisible,
    bool? isEmailValid,
    XFile? profileImage,
    String? serverImageUrl,
  }) {
    return ProfileLoaded(
        isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
        isEmailValid: isEmailValid ?? this.isEmailValid,
        profileImage: profileImage ?? this.profileImage,
        serverImageUrl: serverImageUrl ?? this.serverImageUrl);
  }
}

class ProfileError extends ProfileState {
  final String message;

  ProfileError(this.message);
}

class ProfileUpdated extends ProfileState {}

class ProfileDeleted extends ProfileState {}

class LogoutLoadingState extends ProfileState {}

class LogoutErrorState extends ProfileState {
  final String massage;

  LogoutErrorState(this.massage);
}

class LogoutSuccessState extends ProfileState {
  final String massage;

  LogoutSuccessState(this.massage);
}

// Add these new states to your ProfileState
class EmailVerificationLoading extends ProfileState {}

class EmailVerificationSuccess extends ProfileState {
  final String message;

  EmailVerificationSuccess(this.message);
}

class EmailVerificationError extends ProfileState {
  final String message;

  EmailVerificationError(this.message);
}

class OtpVerificationLoading extends ProfileState {}

class OtpVerificationSuccess extends ProfileState {
  final String message;

  OtpVerificationSuccess(this.message);
}

class OtpVerificationError extends ProfileState {
  final String message;

  OtpVerificationError(this.message);
}
